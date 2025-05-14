import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'dart:typed_data';

class AIService {
  static final AIService instance = AIService._internal();
  late final GenerativeModel _model;

  AIService._internal() {
    final generationConfig = GenerationConfig(
      maxOutputTokens: 100,
      temperature: 0.5,
      topP: 1,
    );

    _model = FirebaseVertexAI.instanceFor(location: 'us-central1').generativeModel(
      model: 'gemini-2.0-flash-lite-001',
      generationConfig: generationConfig
    );
  }

  Future<String> analyzeImage(Uint8List imageData) async {
    try {
      // 이미지 데이터를 Content로 변환
      final content = Content.multi([
        TextPart("Please determine if a face is detected in the image.\n\nexample:\nface : 0"),
        DataPart('image/jpeg', imageData)
      ]);
      
      // API 호출 - generateContent는 Content 타입 하나를 받음
      final response = await _model.generateContent([content]);
      return response.text ?? 'face : 1';
    } catch (e) {
      print('Error analyzing image: $e');
      return 'face : 1';
    }
  }
} 