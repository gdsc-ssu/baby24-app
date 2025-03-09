import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

// 카메라 디바이스용 페이지 (새로 생성)
class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  bool _isLoading = false;
  bool _isStreaming = false;
  CameraController? _controller;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final _localRTCVideoRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _localRTCVideoRenderer.initialize();
    _handleIncomingLink();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showError('사용 가능한 카메라가 없습니다.');
        return;
      }

      _controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
      );

      await _controller?.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      _showError('카메라 초기화 중 오류가 발생했습니다.');
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _handleIncomingLink() async {
    // Dynamic Link 처리 로직 구현 예정
  }

  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final code = _codeController.text.trim();
      final snapshot = await _database.child('connection_codes').child(code).get();

      if (!snapshot.exists) {
        _showError('유효하지 않은 코드입니다.');
        return;
      }

      final data = snapshot.value as Map<Object?, Object?>;
      if (data['isUsed'] == true) {
        _showError('이미 사용된 코드입니다.');
        return;
      }

      // 코드를 사용됨으로 표시
      await _database.child('connection_codes').child(code).update({
        'isUsed': true,
        'connectedAt': ServerValue.timestamp,
      });

      if (mounted) {
        _showSuccess('연결이 완료되었습니다!');
      }
    } catch (e) {
      _showError('오류가 발생했습니다. 다시 시도해주세요.');
      debugPrint('Error verifying code: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _setupPeerConnection() async {
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ]
    });

    // 로컬 스트림 추가
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    // Offer 수신 및 Answer 전송
    _database.child('webrtc').child(_codeController.text).onValue.listen((event) async {
      if (!event.snapshot.exists) return;
      final data = event.snapshot.value as Map;
      
      if (data['type'] == 'offer') {
        await _peerConnection!.setRemoteDescription(
          RTCSessionDescription(data['sdp'], 'offer'),
        );

        // Answer 생성
        final answer = await _peerConnection!.createAnswer();
        await _peerConnection!.setLocalDescription(answer);

        // Firebase에 Answer 저장
        await _database.child('webrtc').child(_codeController.text).update({
          'type': 'answer',
          'sdp': answer.sdp,
        });
      }
    });
  }

  Future<void> _startStreaming() async {
    try {
      _localStream = await navigator.mediaDevices.getUserMedia({
        'video': true,
        'audio': false,
      });

      _localRTCVideoRenderer.srcObject = _localStream;
      await _setupPeerConnection();

      // 스트리밍 상태 업데이트
      await _database.child('streams').child(_codeController.text).update({
        'status': 'streaming',
        'timestamp': ServerValue.timestamp,
      });

      setState(() {
        _isStreaming = true;
      });
    } catch (e) {
      _showError('스트리밍 시작 중 오류가 발생했습니다.');
      debugPrint('Streaming error: $e');
    }
  }

  Future<void> _stopStreaming() async {
    _localStream?.getTracks().forEach((track) => track.stop());
    await _peerConnection?.close();
    _localStream = null;
    _peerConnection = null;

    await _database.child('streams').child(_codeController.text).update({
      'status': 'stopped',
    });

    setState(() {
      _isStreaming = false;
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _codeController.dispose();
    _localRTCVideoRenderer.dispose();
    _localStream?.dispose();
    _peerConnection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Mode'),
        actions: [
          // 스트리밍 상태 표시 및 제어
          Switch(
            value: _isStreaming,
            onChanged: (value) async {
              if (value) {
                await _startStreaming();
              } else {
                await _stopStreaming();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      labelText: '연결 코드 입력',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '코드를 입력해주세요';
                      }
                      if (value.length != 6) {
                        return '6자리 코드를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _verifyCode,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('연결하기'),
                  ),
                  if (_isStreaming)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '스트리밍 중...',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 