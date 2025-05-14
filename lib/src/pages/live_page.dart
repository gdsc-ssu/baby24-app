import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:baby24_io_app/src/services/signalling.service.dart';
import 'package:baby24_io_app/src/pages/role_selection_page.dart';
import 'package:baby24_io_app/src/pages/main_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  bool isAudioOn = true, isVideoOn = true;
  late String _deviceId;
  final RTCVideoRenderer _remoteRTCVideoRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _localRTCVideoRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  RTCPeerConnectionState _connectionState = RTCPeerConnectionState.RTCPeerConnectionStateConnecting;
  String? _roomId;
  bool _isConnected = false;
  bool _isStreaming = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // 먼저 렌더러 초기화를 완료
      await _remoteRTCVideoRenderer.initialize();
      await _localRTCVideoRenderer.initialize();
      debugPrint('=== Monitor: Video renderers initialized ===');
      
      // 룸 ID 생성은 동기적으로 수행
      _createNewRoom();
      
      // 다른 초기화 작업 수행
      await _createPeerConnection();
      await _createLocalStream();
      await _getDeviceId();
      
      setState(() {
        _isInitialized = true;
      });
      
      // 소켓 연결은 렌더러와 다른 초기화가 완료된 후에 시작
      _connectSocket();
    } catch (e) {
      debugPrint('=== Monitor: Initialization error: $e ===');
      _showError('Failed to initialize: $e');
    }
  }

  void _createNewRoom() {
    _roomId = (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
    debugPrint('=== Monitor: Created new room with ID: $_roomId ===');
    
    // 방코드 팝업은 UI가 준비된 후에 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showRoomCode(_roomId!);
      }
    });
  }

  Future<void> _createLocalStream() async {
    var cameraStatus = await _checkCameraPermission();
    var micStatus = await _checkMicrophonePermission();

    if (cameraStatus.isGranted && micStatus.isGranted) {
      final Map<String, dynamic> mediaConstraints = {
        'audio': true,
        'video': {
          'facingMode': 'user',
          'mandatory': {
            'minWidth': '640',
            'minHeight': '320',
          },
        },
      };
      
      try {
        MediaStream stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
        _localStream = stream;
        
        // 로컬 비디오 렌더러에 스트림 연결
        _localRTCVideoRenderer.srcObject = stream;

        _localStream?.getTracks().forEach((track) {
          _peerConnection!.addTrack(track, _localStream!);
        });

        setState(() {});
      } catch (e) {
        debugPrint('=== Monitor: Error creating local stream: $e ===');
        _showError('Error creating local stream.');
      }
    } else {
      _showError('Camera and microphone permissions are required.');
    }
  }

  void _connectSocket() {
    debugPrint('=== Monitor: _connectSocket() called ===');
    String signalingUrl;

    if (kIsWeb) {
      signalingUrl = 'http://localhost:3333'; // 웹 브라우저용
    } else if (Platform.isAndroid) {
      signalingUrl = 'http://10.0.2.2:3333'; // AVD(Android 에뮬레이터)용
    } else {
      signalingUrl = 'http://192.168.35.242:3333'; // 실제 안드로이드 기기용
    }

    debugPrint('=== Monitor: signalingUrl = $signalingUrl ===');
    SignallingService.instance.init(
      websocketUrl: signalingUrl,
      selfCallerID: 'mobile_${DateTime.now().millisecondsSinceEpoch}',
    );

    final socket = SignallingService.instance.socket;

    // 소켓 이벤트 리스너 설정
    socket?.on('connect', (_) {
      debugPrint('=== Monitor: Socket connected ===');

      debugPrint('=== Monitor: joinRoom emit with roomId $_roomId ===');
      if (_roomId != null) {
        socket.emit('joinRoom', {
          'roomId': _roomId,
          'role': 'monitor'
        });
        debugPrint('=== Monitor: joinRoom event emitted with data: {"roomId": $_roomId} ===');
      } else {
        debugPrint('=== Monitor: Cannot join room - roomId is null ===');
      }
    });

    socket?.on('start', (_) async {
      debugPrint('=== Monitor: start event received ===');
      // Monitor는 이제 offer를 생성하지 않고, 단지 연결이 시작되었음을 알림
      // camera 측에서 offer를 보내면 그것을 받아 answer를 생성할 것임
      setState(() {
        _isConnected = true;
      });
      debugPrint('=== Monitor: Connection state updated, waiting for offer ===');
    });

    socket?.on('offer', (data) async {
      debugPrint('=== Monitor: offer received ===');
      if (_peerConnection != null) {
        try {
          await _peerConnection!.setRemoteDescription(
            RTCSessionDescription(
              data['sdp'],
              data['type'],
            ),
          );
          debugPrint('=== Monitor: Remote description set successfully ===');
          
          // 원격 설명이 성공적으로 설정되면 answer 생성
          _createAnswer();
        } catch (e) {
          debugPrint('=== Monitor: Error setting remote description: $e ===');
          _showError('Error setting up remote connection.');
        }
      } else {
        debugPrint('=== Monitor: Cannot set remote description - peerConnection is null ===');
      }
    });

    socket?.on('answer', (data) async {
      if (_peerConnection != null) {
        try {
          await _peerConnection!.setRemoteDescription(
            RTCSessionDescription(
              data['sdp'],
              data['type'],
            ),
          );
          debugPrint('=== Monitor: Answer set successfully ===');
        } catch (e) {
          debugPrint('=== Monitor: Error setting answer: $e ===');
          _showError('Error setting answer.');
        }
      } else {
        debugPrint('=== Monitor: Cannot set answer - peerConnection is null ===');
      }
    });

    // 서버로부터 받는 ICE candidate 처리
    socket?.on('iceCandidate', (data) async {
      if (_peerConnection != null) {
        try {
          final candidate = RTCIceCandidate(
            data['candidate'],
            data['sdpMid'],
            data['sdpMLineIndex'],
          );
          await _peerConnection!.addCandidate(candidate);
          debugPrint('=== Monitor: Added remote ICE candidate ===');
        } catch (e) {
          debugPrint('=== Monitor: Error adding ICE candidate: $e ===');
        }
      } else {
        debugPrint('=== Monitor: Cannot add ICE candidate - peerConnection is null ===');
      }
    });

    // 서버로부터 받는 연결 상태 처리
    socket?.on('connectionStatus', (data) {
      debugPrint('=== Monitor: Connection status: ${data['status']} ===');
      if (data['status'] == 'disconnected') {
        setState(() => _isStreaming = false);
      }
    });

    socket?.on('error', (data) {
      debugPrint('=== Monitor: Error: ${data['message']} ===');
      _showError(data['message']);
    });

    socket?.on('disconnect', (_) {
      debugPrint('=== Monitor: Socket disconnected ===');
    });

    // 소켓 연결 시도
    socket?.connect();
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final configuration = <String, dynamic>{
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
      "sdpSemantics": "unified-plan",
    };

    final pc = await createPeerConnection(configuration);

    pc.onIceCandidate = (candidate) {
      debugPrint('=== Monitor: ICE candidate: $candidate ===');
      SignallingService.instance.socket?.emit('iceCandidate', {
        'roomId': _roomId,
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };

    pc.onTrack = (event) {
      _handleRemoteStream(event.streams[0]);
      setState(() => _isStreaming = true);
    };

    _peerConnection = pc;
    return pc;
  }

  void _createOffer() async {
    RTCSessionDescription description = await _peerConnection!
        .createOffer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
    await _peerConnection!.setLocalDescription(description);
    debugPrint('=== Monitor: Offer sent via Socket.IO ===');
    SignallingService.instance.socket!.emit('offer', {
      'sdp': description.sdp,
      'type': description.type,
      'roomId': _roomId,
    });
  }

  Future<void> _createAnswer() async {
    try {
      RTCSessionDescription description = await _peerConnection!.createAnswer({
        'offerToReceiveVideo': 1,
        'offerToReceiveAudio': 1
      });
      await _peerConnection!.setLocalDescription(description);
      
      SignallingService.instance.socket?.emit('answer', {
        'roomId': _roomId,
        'type': description.type,
        'sdp': description.sdp
      });
      debugPrint('=== Monitor: Answer sent via Socket.IO ===');
    } catch (e) {
      debugPrint('=== Monitor: Error creating answer: $e ===');
      _showError('Error creating answer.');
      rethrow;
    }
  }

  void _handleRemoteStream(MediaStream stream) {
    setState(() {
      _isStreaming = true;
    });
    
    _remoteRTCVideoRenderer.srcObject = stream;
    
    // Audio track handling
    final audioTracks = stream.getAudioTracks();
    for (var track in audioTracks) {
      track.enabled = isAudioOn;
    }
    
    // Video track handling
    final videoTracks = stream.getVideoTracks();
    for (var track in videoTracks) {
      track.enabled = isVideoOn;
    }
  }

  Future<void> _showRoomCode(String roomId) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connection Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Share this code with the camera device:'),
              const SizedBox(height: 16),
              Text(
                roomId,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    _deviceId = androidInfo.id;
  }

  Future<PermissionStatus> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    return status;
  }

  Future<PermissionStatus> _checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }
    return status;
  }

  void _toggleMic() {
    isAudioOn = !isAudioOn;
    if (_remoteRTCVideoRenderer.srcObject != null) {
      final audioTracks = _remoteRTCVideoRenderer.srcObject!.getAudioTracks();
      for (var track in audioTracks) {
        track.enabled = isAudioOn;
      }
    }
    setState(() {});
  }

  void _toggleCamera() {
    isVideoOn = !isVideoOn;
    if (_remoteRTCVideoRenderer.srcObject != null) {
      final videoTracks = _remoteRTCVideoRenderer.srcObject!.getVideoTracks();
      for (var track in videoTracks) {
        track.enabled = isVideoOn;
      }
    }
    setState(() {});
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('=== Monitor: Building UI with _roomId=$_roomId, _isConnected=$_isConnected ===');
    
    if (!_isInitialized || _roomId == null) {
      // 초기화 중이거나 방 코드가 아직 생성되지 않았으면 로딩
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 항상 비디오 스트림을 표시하되, 연결 전까지는 코드와 대기 메시지 오버레이
    return WillPopScope(
      onWillPop: () async {
        SignallingService.instance.socket?.disconnect();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              SignallingService.instance.socket?.disconnect();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
                (route) => false,
              );
            },
          ),
        ),
        body: Stack(
          children: [
            // 항상 비디오 뷰 표시
            Container(
              color: Colors.black,
              child: _remoteRTCVideoRenderer.srcObject != null
                  ? RTCVideoView(
                      _remoteRTCVideoRenderer,
                      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    )
                  : const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
            
            // 미연결 상태일 때 오버레이 표시
            if (!_isConnected)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Waiting for camera to connect...',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Connection Code: $_roomId',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () => _showRoomCode(_roomId!),
                        child: const Text('Show Code'),
                      ),
                    ],
                  ),
                ),
              ),
            
            // 연결된 상태에서만 표시할 컨트롤
            if (_isConnected) ...[
              Positioned(
                left: 16,
                bottom: 16,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Call 911?'),
                        content: const Text('Do you want to call emergency number 911?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Implement actual call action
                              Navigator.of(context).pop();
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.phone, color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ),
              
              // 상태 표시
              if (_isStreaming)
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: Colors.black.withOpacity(0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          isAudioOn ? Icons.mic : Icons.mic_off,
                          color: Colors.white,
                        ),
                        onPressed: _toggleMic,
                      ),
                      IconButton(
                        icon: Icon(
                          isVideoOn ? Icons.videocam : Icons.videocam_off,
                          color: Colors.white,
                        ),
                        onPressed: _toggleCamera,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 페이지가 dispose될 때도 소켓 연결 해제
    SignallingService.instance.socket?.disconnect();
    _remoteRTCVideoRenderer.dispose();
    _peerConnection?.dispose();
    super.dispose();
  }
} 