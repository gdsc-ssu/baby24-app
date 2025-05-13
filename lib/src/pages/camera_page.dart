import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:baby24_io_app/src/services/signalling.service.dart';
import 'package:baby24_io_app/src/services/ai_service.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baby24_io_app/src/pages/role_selection_page.dart';
import 'package:baby24_io_app/src/pages/main_screen.dart';
import 'package:baby24_io_app/src/services/device_service.dart';

// 카메라 디바이스용 페이지 (새로 생성)
class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = false;
  bool _isStreaming = false;
  String? _roomId;
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  CameraController? _controller;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final _localRTCVideoRenderer = RTCVideoRenderer();
  List<RTCIceCandidate> rtcIceCadidates = [];
  bool isAudioOn = true, isVideoOn = true, isFrontCameraSelected = true;
  String _deviceId = '';
  RTCPeerConnectionState _connectionState = RTCPeerConnectionState.RTCPeerConnectionStateConnecting;
  Timer? _captureTimer;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _initializeComponents();
  }

  Future<void> _initializeComponents() async {
    try {
      await _localRTCVideoRenderer.initialize();
      await _createPeerConnection();
      await _createLocalStream();
      await _getDeviceId();
      
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showRoomCodeInput();
        });
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to initialize components: $e');
      }
    }
  }

  Future<void> _showRoomCodeInput() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter Connection Code'),
        content: TextField(
          controller: _codeController,
          decoration: const InputDecoration(
            hintText: 'Enter 6-digit code',
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
                (route) => false,
              );
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              debugPrint('=== Camera: Connect button pressed ===');
              if (_codeController.text.length == 6) {
                setState(() => _isLoading = true);
                _roomId = _codeController.text;
                
                try {
                  Future.microtask(() {
                    _connectSocket();
                  });
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  if (mounted) {
                    _showError('Failed to connect: $e');
                  }
                } finally {
                  if (mounted) {
                    setState(() => _isLoading = false);
                  }
                }
              }
            },
            child: const Text('Connect'),
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

  // 카메라 권한상태를 조회하고 요청
  Future<PermissionStatus> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    return status;
  }

  // 마이크의 권한 상태를 조회하고 요청
  Future<PermissionStatus> _checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }
    return status;
  }

  // 로컬스트림 생성
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

  void _toggleMic() {
    isAudioOn = !isAudioOn;
    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = isAudioOn;
    });
    setState(() {});
  }

  void _toggleCamera() {
    isVideoOn = !isVideoOn;
    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = isVideoOn;
    });
    setState(() {});
  }

  void _switchCamera() {
    isFrontCameraSelected = !isFrontCameraSelected;
    _localStream?.getVideoTracks().forEach((track) {
      track.switchCamera();
    });
    setState(() {});
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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

    // Start periodic analysis when streaming begins
    startPeriodicAnalysis();
  }

  Future<Uint8List?> captureFrame() async {
    if (_localRTCVideoRenderer.srcObject != null) {
      try {
        final image = await _localRTCVideoRenderer.captureFrame();
        return image;
      } catch (e) {
        debugPrint('=== Camera: Error capturing frame: $e ===');
        return null;
      }
    }
    return null;
  }

  Future<void> analyzeFrame() async {
    if (_isAnalyzing) return;
    
    try {
      _isAnalyzing = true;
      final frameData = await captureFrame();
      if (frameData == null) return;

      final result = await AIService.instance.analyzeImage([InlineDataPart('image/jpeg', frameData)]);
      debugPrint('=== Camera: AI Analysis Result: $result ===');
      
      if (result == 'face : 0') {
        try {
          await DeviceService.instance.alertOn("1");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Warning: Child\'s face is not visible!')),
            );
          }
        } catch (e) {
          debugPrint('=== Camera: Error sending alert: $e ===');
          if (mounted) {
            _showError('Alert sending failed: $e');
          }
        }
      } else if (result == 'face : 1') {
        try {
          await DeviceService.instance.alertOff("1");
        } catch (e) {
          debugPrint('=== Camera: Error turning off alert: $e ===');
          if (mounted) {
            _showError('Failed to turn off alert: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('=== Camera: Error analyzing frame: $e ===');
      if (mounted) {
        _showError('Error analyzing frame: $e');
      }
    } finally {
      _isAnalyzing = false;
    }
  }

  void startPeriodicAnalysis() {
    _captureTimer?.cancel();
    _captureTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      analyzeFrame();
    });
  }

  void stopPeriodicAnalysis() {
    _captureTimer?.cancel();
    _captureTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
          title: const Text('Camera Mode'),
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
            // 카메라 프리뷰 (전체 화면)
            Container(
              color: Colors.black,
              child: _localRTCVideoRenderer.srcObject != null
                  ? RTCVideoView(
                      _localRTCVideoRenderer,
                      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: CameraPreview(_controller!),
                          ),
                        ),
                        if (_isStreaming)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Streaming...', style: TextStyle(color: Colors.red)),
                          ),
                      ],
                    ),
            ),
            // 컨트롤 버튼
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
                      icon: const Icon(
                        Icons.call_end,
                        color: Colors.red,
                      ),
                      iconSize: 30,
                      onPressed: () {
                        SignallingService.instance.socket?.disconnect();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const MainScreen()),
                          (route) => false,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cameraswitch,
                        color: Colors.white,
                      ),
                      onPressed: _switchCamera,
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
    stopPeriodicAnalysis();
    _codeController.dispose();
    _controller?.dispose();
    _localRTCVideoRenderer.dispose();
    _localStream?.dispose();
    _peerConnection?.dispose();
    SignallingService.instance.socket?.dispose();
    super.dispose();
  }
}