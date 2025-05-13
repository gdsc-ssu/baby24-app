import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:baby24_io_app/src/services/signalling.service.dart';
import 'package:baby24_io_app/src/pages/role_selection_page.dart';
import 'package:baby24_io_app/src/pages/main_screen.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  bool isAudioOn = true, isVideoOn = true;
  late String _deviceId;
  late RTCVideoRenderer _remoteRTCVideoRenderer;
  late RTCPeerConnection _peerConnection;
  late RTCPeerConnectionState _connectionState;
  String? _roomId;
  bool _isLoading = true;
  bool _isConnected = false;

  @override
  void initState() {
    _remoteRTCVideoRenderer.initialize();
    _localRTCVideoRenderer.initialize().then((_) => _createPeerConnection()).then((_) => _createLocalStream());
    _getDeviceId();
    _createNewRoom();
    _connectSocket();
    super.initState();
  }

  Future<void> _createNewRoom() async {
    setState(() => _isLoading = true);
    
    try {
      // 새로운 방 ID 생성 (6자리 숫자)
      _roomId = (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
      debugPrint('=== Monitor: Created new room with ID: $_roomId ===');
      
      // 시그널링 서버 연결 초기화
      await _initializeSignaling();

      if (!mounted) return;
      await _showRoomCode(_roomId!);

    } catch (e) {
      debugPrint('=== Monitor: Error creating room: $e ===');
      _showError('Error creating room');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
        debugPrint('=== Camera: Error creating local stream: $e ===');
        _showError('Error creating local stream.');
      }
    } else {
      _showError('Camera and microphone permissions are required.');
    }
  }

   void _connectSocket() {
    debugPrint('=== Camera: _connectSocket() called ===');
    String signalingUrl;

    if (kIsWeb) {
      signalingUrl = 'http://localhost:3000'; // 웹 브라우저용
    } else if (Platform.isAndroid) {
      signalingUrl = 'http://10.0.2.2:3000'; // AVD(Android 에뮬레이터)용
    } else {
      signalingUrl = 'http://192.168.35.242:3000'; // 실제 안드로이드 기기용
    }

    debugPrint('=== Camera: signalingUrl = $signalingUrl ===');
    SignallingService.instance.init(
      websocketUrl: signalingUrl,
      selfCallerID: 'mobile_${DateTime.now().millisecondsSinceEpoch}',
    );

    final socket = SignallingService.instance.socket;

    // 소켓 이벤트 리스너 설정
    socket?.on('connect', (_) {
      debugPrint('=== Camera: Socket connected ===');
      debugPrint('=== Camera: joinRoom emit with roomId $_roomId ===');
      if (_roomId != null) {
        socket.emit('joinRoom', {
          'roomId': _roomId
        });
        debugPrint('=== Camera: joinRoom event emitted with data: {"roomId": $_roomId} ===');
      } else {
        debugPrint('=== Camera: Cannot join room - roomId is null ===');
      }
    });

    socket?.on('disconnect', (_) {
      debugPrint('=== Camera: Socket disconnected ===');
      setState(() => _isStreaming = false);
    });

    socket?.on('start', (_) async {
      debugPrint('=== Camera: start event received ===');
      _createOffer();
    });

    socket?.on('offer', (data) async {
      if (_peerConnection != null) {
        try {
          await _peerConnection!.setRemoteDescription(
            RTCSessionDescription(
              data['sdp'],
              data['type'],
            ),
          );
          debugPrint('=== Camera: Remote description set successfully ===');
          _createAnswer();
        } catch (e) {
          debugPrint('=== Camera: Error setting remote description: $e ===');
          _showError('Error setting up remote connection.');
        }
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
          debugPrint('=== Camera: Answer set successfully ===');
        } catch (e) {
          debugPrint('=== Camera: Error setting answer: $e ===');
          _showError('Error setting answer.');
        }
      }
    });

    // 서버로부터 받는 ICE candidate 처리
    socket?.on('iceCandidate', (data) async {
      if (_peerConnection != null) {
        final candidate = RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );
        await _peerConnection!.addCandidate(candidate);
        debugPrint('=== Camera: Added remote ICE candidate ===');
      }
    });

    // 서버로부터 받는 연결 상태 처리
    socket?.on('connectionStatus', (data) {
      debugPrint('=== Camera: Connection status: ${data['status']} ===');
      if (data['status'] == 'disconnected') {
        setState(() => _isStreaming = false);
      }
    });

    socket?.on('error', (data) {
      debugPrint('=== Camera: Error: ${data['message']} ===');
      _showError(data['message']);
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

    pc.onTrack = (event) {
      _handleRemoteStream(event.streams[0]);
      setState(() => _isStreaming = true);
    }

    _peerConnection = pc;
  }

    void _createOffer() async {
    RTCSessionDescription description = await _peerConnection!
        .createOffer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
    await _peerConnection!.setLocalDescription(description);
    SignallingService.instance.socket!.emit('offer', {
      'sdp': description.sdp,
      'type': description.type,
      'room': _roomId,
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
        'room': _roomId,
        'type': description.type,
        'sdp': description.sdp
      });
      debugPrint('=== Camera: Answer sent via Socket.IO ===');
    } catch (e) {
      debugPrint('=== Camera: Error creating answer: $e ===');
      _showError('Error creating answer.');
      rethrow;
    }
  }

    void _handleRemoteStream(MediaStream stream) {
    setState(() {
      _isStreaming = true;
    });
    
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

  Future<void> _showRoomCode(String code) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Connection Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter this code in the camera app:'),
            const SizedBox(height: 16),
            Text(
              code,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    setState(() {
      _deviceId = androidInfo.id;
    });
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
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isConnected) {
      return WillPopScope(
        onWillPop: () async {
          // 소켓 연결 해제 (서버에서 disconnect 이벤트로 처리)
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
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87,),
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Waiting for camera to connect...',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Text(
                  'Room Code: $_roomId',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        // 소켓 연결 해제 (서버에서 disconnect 이벤트로 처리)
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
          title: const Text('Live View'),
        ),
        body: Stack(
          children: [
            RTCVideoView(
              _remoteRTCVideoRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
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
                  child: Center(
                    child: Image.asset(
                      'assets/icons/emergency_call.png',
                      width: 28,
                      height: 28,
                      color: Colors.white,
                    ),
                  ),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 페이지가 dispose될 때도 소켓 연결 해제
    SignallingService.instance.socket?.disconnect();
    _remoteRTCVideoRenderer.dispose();
    _peerConnection.dispose();
    super.dispose();
  }
} 