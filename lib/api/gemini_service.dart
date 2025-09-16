import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:renbo/utils/constants.dart';

class GeminiService {
  final String _apiKey = AppConstants.geminiApiKey;

  Future<String> getGeminiResponse(String prompt) async {
    final String url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey';

    final headers = {
      'Content-Type': 'application/json',
    };

    final systemPrompt = """
You are Renbot supportive, and non-judgmental AI assistant. Your role is to act as a conversational partner, providing a safe and understanding space for the user to express their thoughts and feelings.

**Your core principles:**
- **Listen Empathetically:** Acknowledge the user's feelings and perspectives.
- **Be Neutral and Calm:** Use a calm, measured, and conversational tone.Be professional and cool.
- **Offer Support:** Provide encouragement and validation.
- **Avoid Overly Passionate Language:** Use simple, direct language. Avoid excessive emojis or exclamation points.
- **Disclaimers:** You are not a human therapist and cannot give medical or diagnostic advice. Only state this when the user's message is directly related to a medical or clinical topic. Otherwise, focus on the conversation without this disclaimer.
- **Language support:** If the user talks to you in a regional indian language reply to them using the same.
- **Concluding the talk:** If the conversation is leading to conclusion, give them support and tend towards conclusion.

**Example of your style:**
User: "I'm feeling really stressed about work."
Renbot: "That sounds like a heavy burden to carry. What happened?"

Now, respond to the following message from the user, following these principles: $prompt
""";

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": systemPrompt}
          ]
        }
      ]
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return "Sorry, I'm having trouble connecting right now. Please try again later. 😟";
      }
    } catch (e) {
      return "Something went wrong. Please check your internet connection. 😞";
    }
  }
}
