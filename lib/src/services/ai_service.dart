import 'package:firebase_vertexai/firebase_vertexai.dart';

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

  Future<String> analyzeImage(imageFile) async {
    final prompt = TextPart("Please determine if a face is detected in the image.\n\nexample:\nface : 0");
    final response = await _model.generateContent([Content.multi([prompt, ...imageFile])]);
    return response.text;
  }
} 