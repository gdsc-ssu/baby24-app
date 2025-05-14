const express = require("express");
const http = require("http");
const socketIo = require("socket.io");
const cors = require("cors");

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

const PORT = process.env.PORT || 3333;

app.use(cors());

app.get("/", (req, res) => {
  res.send("WebRTC Signaling Server");
});

const rooms = new Map();

io.on("connection", (socket) => {
  console.log("New user connected");

  // 방 참여
  socket.on("joinRoom", (data) => {
    const { roomId, role } = data;
    console.log(`joinRoom ${roomId}, role: ${role}`);
    
    // 방이 없으면 생성
    if (!rooms.has(roomId)) {
      console.log(`Room not found ${roomId}, creating new room`);
      rooms.set(roomId, { 
        users: new Map(),
        cameraSocketId: null,
        monitorSocketId: null
      });
    }

    const roomData = rooms.get(roomId);
    
    // 해당 소켓이 이미 방에 있으면 처리하지 않음
    if (roomData.users.has(socket.id)) {
      console.log(`User ${socket.id} already in room ${roomId}`);
      return;
    }
    
    // 소켓을 해당 룸에 join
    socket.join(roomId);
    
    // 역할 기록 및 사용자 추가
    if (role === 'camera') {
      roomData.cameraSocketId = socket.id;
      roomData.users.set(socket.id, { role: 'camera' });
      console.log(`Camera device (${socket.id}) joined room ${roomId}`);
    } else if (role === 'monitor') {
      roomData.monitorSocketId = socket.id;
      roomData.users.set(socket.id, { role: 'monitor' });
      console.log(`Monitor device (${socket.id}) joined room ${roomId}`);
    } else {
      roomData.users.set(socket.id, { role: 'unknown' });
      console.log(`Unknown role device (${socket.id}) joined room ${roomId}`);
    }
    
    console.log(`Room ${roomId} now has ${roomData.users.size} users`);
    
    // 방에 카메라와 모니터 모두 참여했으면 start 이벤트 전송
    if (roomData.cameraSocketId && roomData.monitorSocketId) {
      console.log(`Room ${roomId} has both camera and monitor, sending start event`);
      io.to(roomId).emit("start");
      
      // 카메라에게 offer 생성 요청
      setTimeout(() => {
        console.log(`Requesting offer from camera in room ${roomId}`);
        io.to(roomData.cameraSocketId).emit("create_offer");
      }, 1000); // 1초 후에 create_offer 이벤트 전송
    } else {
      console.log(`Waiting for ${roomData.cameraSocketId ? 'monitor' : 'camera'} to join room ${roomId}`);
    }
  });

  // offer 전송
  socket.on("offer", (data) => {
    const roomId = data.roomId;
    console.log(`Received offer from ${socket.id} for room ${roomId}`);
    
    if (roomId) {
      // 방의 다른 참가자에게만 offer 전송
      socket.to(roomId).emit("offer", data);
    } else {
      console.error("Received offer with undefined roomId");
    }
  });

  // answer 전송
  socket.on("answer", (data) => {
    const roomId = data.roomId;
    console.log(`Received answer from ${socket.id} for room ${roomId}`);
    
    if (roomId) {
      socket.to(roomId).emit("answer", data);
    } else {
      console.error("Received answer with undefined roomId");
    }
  });

  // ICE candidate 전송
  socket.on("iceCandidate", (data) => {
    const roomId = data.roomId;
    console.log(`Received ICE candidate from ${socket.id} for room ${roomId}`);
    
    if (roomId) {
      socket.to(roomId).emit("iceCandidate", data);
    } else {
      console.error("Received ICE candidate with undefined roomId");
    }
  });

  // 연결 상태 업데이트
  socket.on("connectionStatus", (data) => {
    const roomId = data.roomId;
    console.log(`Connection status update for room ${roomId}: ${data.status}`);
    
    if (roomId) {
      socket.to(roomId).emit("connectionStatus", data);
    } else {
      console.error("Received connection status with undefined roomId");
    }
  });

  // 연결 해제
  socket.on("disconnect", () => {
    for (const [roomId, data] of rooms.entries()) {
      if (data.users.has(socket.id)) {
        console.log(`User ${socket.id} left room ${roomId}`);
        data.users.delete(socket.id);
        
        // Camera/Monitor 역할 정보 업데이트
        if (data.cameraSocketId === socket.id) {
          data.cameraSocketId = null;
          console.log(`Camera left room ${roomId}`);
        } else if (data.monitorSocketId === socket.id) {
          data.monitorSocketId = null;
          console.log(`Monitor left room ${roomId}`);
        }
        
        // 방이 비어있으면 삭제
        if (data.users.size === 0) {
          console.log(`Room ${roomId} is empty. Deleting room`);
          rooms.delete(roomId);
        } else {
          // 남은 사용자에게 연결 해제 알림
          socket.to(roomId).emit("connectionStatus", {
            roomId: roomId,
            status: "disconnected"
          });
        }
        break;
      }
    }
  });
});

server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Server IP address: ${require('os').networkInterfaces()['eth0']?.[0]?.address || 'localhost'}`);
}); 