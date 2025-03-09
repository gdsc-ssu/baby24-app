import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  String? _connectionCode;
  bool _isConnected = false;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final _remoteRTCVideoRenderer = RTCVideoRenderer();
  RTCPeerConnection? _rtcPeerConnection;

  @override
  void initState() {
    super.initState();
    _initRenderer();
    _checkExistingConnection();
  }

  Future<void> _initRenderer() async {
    await _remoteRTCVideoRenderer.initialize();
  }

  Future<void> _setupPeerConnection() async {
    _rtcPeerConnection = await createPeerConnection({
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ]
    });

    _rtcPeerConnection!.onTrack = (event) {
      debugPrint("Received remote stream");
      _remoteRTCVideoRenderer.srcObject = event.streams[0];
      setState(() => _isConnected = true);
    };

    // Offer 생성
    final offer = await _rtcPeerConnection!.createOffer();
    await _rtcPeerConnection!.setLocalDescription(offer);

    // Firebase에 Offer 저장
    await _database.child('webrtc').child(_connectionCode!).set({
      'type': 'offer',
      'sdp': offer.sdp,
    });

    debugPrint('Offer created and saved to Firebase: ${_connectionCode}');

    // Answer 수신 대기
    _database.child('webrtc').child(_connectionCode!).onValue.listen((event) async {
      if (!event.snapshot.exists) return;
      final data = event.snapshot.value as Map;
      if (data['type'] == 'answer') {
        await _rtcPeerConnection!.setRemoteDescription(
          RTCSessionDescription(data['sdp'], 'answer'),
        );
      }
    });
  }

  // 기존 연결 확인
  Future<void> _checkExistingConnection() async {
    try {
      final snapshot = await _database.child('connection_codes').get();
      if (!snapshot.exists) return;

      final codes = snapshot.value as Map;
      for (var entry in codes.entries) {
        final data = entry.value as Map;
        if (data['isUsed'] == true && data['isStreaming'] == true) {
          setState(() {
            _connectionCode = entry.key;
            _isConnected = true;
          });
          _startConnectionMonitoring(entry.key);  // 연결 상태 모니터링 시작
          break;
        }
      }
    } catch (e) {
      debugPrint('Error checking existing connection: $e');
    }
  }

  Future<void> _handleAddDevice() async {
    try {
      final code = _generateCode();
      
      await _database.child('connection_codes').child(code).set({
        'createdAt': ServerValue.timestamp,
        'isUsed': false,
      });

      setState(() {
        _connectionCode = code;
      });

      // WebRTC 연결 설정
      await _setupPeerConnection();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('연결 코드'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('아래 코드를 카메라 기기에 입력하세요:'),
                const SizedBox(height: 16),
                Text(
                  code,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
        );

        // 연결 상태 모니터링 시작
        _startConnectionMonitoring(code);
      }
    } catch (e) {
      debugPrint('Error generating connection code: $e');
    }
  }

  void _startConnectionMonitoring(String code) {
    _database.child('streams').child(code).onValue.listen((event) async {
      if (!event.snapshot.exists) return;
      
      final data = event.snapshot.value as Map;
      if (data['status'] == 'streaming') {
        // Offer 생성 및 전송
        final offer = await _rtcPeerConnection!.createOffer();
        await _rtcPeerConnection!.setLocalDescription(offer);

        await _database.child('webrtc').child(code).set({
          'type': 'offer',
          'sdp': offer.toMap(),
        });

        // Answer 수신 대기
        _database.child('webrtc').child(code).onValue.listen((event) async {
          if (!event.snapshot.exists) return;
          
          final data = event.snapshot.value as Map;
          if (data['type'] == 'answer') {
            await _rtcPeerConnection!.setRemoteDescription(
              RTCSessionDescription(data['sdp'], data['type']),
            );
            setState(() => _isConnected = true);
          }
        });
      }
    });
  }

  // 6자리 랜덤 코드 생성
  String _generateCode() {
    final random = Random();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: !_isConnected
          ? Container(
              // 기존 Add Device UI
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _handleAddDevice,
                    child: const Icon(
                      Icons.add_circle_outline,
                      size: 50,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Add Mobile Device'),
                  const SizedBox(height: 8),
                  const Text(
                    'Register your mobile device\nfor live recording.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : RTCVideoView(
              _remoteRTCVideoRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            ),
    );
  }

  @override
  void dispose() {
    _remoteRTCVideoRenderer.dispose();
    _rtcPeerConnection?.dispose();
    super.dispose();
  }
} 