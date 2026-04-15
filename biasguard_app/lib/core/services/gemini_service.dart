import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class GeminiService {
  // Cloud Function CF4 endpoint for Secure Direct Fair Decisions
  // We move logic to the backend to protect the API key.
  static const String _cf4Url = 'https://us-central1-biasguard-2026.cloudfunctions.net/getDirectFairDecision';

  Future<Map<String, dynamic>> getDirectFairDecision(String scenario) async {
    try {
      final uid = AuthService().currentUid ?? 'anonymous-user';
      
      final response = await http.post(
        Uri.parse(_cf4Url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': uid,
          'scenario': scenario,
          'save_to_firestore': true,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        // Handle error response from backend
        String errorMsg = 'Unknown Error';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['error'] ?? errorData['detail'] ?? 'Backend Failure';
        } catch (_) {}

        return {
          'recommendation': 'ERROR',
          'explanation_en': 'Backend Error: $errorMsg',
          'factors_considered': ['BiasGuard Cloud Service'],
          'factors_explicitly_ignored': [],
        };
      }
    } catch (e) {
      return {
        'recommendation': 'ERROR',
        'explanation_en': 'Connection Failure: Ensure you are online and the backend is live.',
        'factors_considered': ['Network layer'],
        'factors_explicitly_ignored': [],
      };
    }
  }
}

final geminiService = GeminiService();
