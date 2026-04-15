import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = 'AIzaSyCL1lOTlhp3DXX0KjPAQEVK3CNETjC1UTg';

  // Use the ACTUAL available models from your key (discovered via listModels)
  final List<String> _models = [
    'gemini-2.5-flash',
    'gemini-2.0-flash-lite',
    'gemini-2.0-flash-001',
    'gemini-2.0-flash',
    'gemini-2.5-pro',
    'gemini-pro-latest',
    'gemini-flash-latest',
  ];

  Future<Map<String, dynamic>> getDirectFairDecision(String scenario) async {
    final requestBody = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {
              "text": """You are a fair decision assistant for BiasGuard. You make decisions based ONLY on merit and contextually relevant factors. You must EXPLICITLY IGNORE caste, surname, gender, religion, region, language, and any other protected attributes. Every decision must be transparent, explainable, and free of bias.

Make a fair recommendation for this scenario:
$scenario

Respond ONLY with valid JSON in this exact format:
{
  "recommendation": "APPROVE or REJECT or REVIEW",
  "confidence": 85,
  "factors_considered": ["list of merit-based factors you used"],
  "factors_explicitly_ignored": ["list of bias-prone factors you ignored"],
  "explanation_en": "Clear explanation of the recommendation in 2-3 sentences",
  "explanation_hi": "Same explanation in Hindi",
  "fairness_note": "One sentence on how this decision upholds fairness principles"
}"""
            }
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.2
      }
    };

    for (final model in _models) {
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey');

      print('DEBUG: Trying v1beta/$model...');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );

        print('DEBUG: $model returned status ${response.statusCode}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          var text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '{}';

          int startIndex = text.indexOf('{');
          int endIndex = text.lastIndexOf('}');

          if (startIndex != -1 && endIndex != -1) {
            text = text.substring(startIndex, endIndex + 1);
          }

          print('DEBUG: SUCCESS with $model!');
          return jsonDecode(text) as Map<String, dynamic>;
        }

        // Log failure reason and try next
        final snippet = response.body.length > 150
            ? response.body.substring(0, 150)
            : response.body;
        print('DEBUG: $model failed: $snippet');
        continue;
      } catch (e) {
        print('DEBUG: $model exception: $e');
        continue;
      }
    }

    return {
      "recommendation": "ERROR",
      "explanation_en": "All models exhausted. Please check billing at console.cloud.google.com",
      "factors_considered": ["Tried all available models"],
      "factors_explicitly_ignored": _models,
    };
  }
}

final geminiService = GeminiService();
