import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _baseUrl = 'https://sai.sharedllm.com/v1/chat/completions';
  static const String _model = 'gpt-oss:120b';

  static Future<String> generate(String systemPrompt, String userPrompt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userPrompt},
          ],
          'temperature': 0.7,
          'max_tokens': 4096,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? 'No response generated.';
      } else {
        return 'Error: Server returned status ${response.statusCode}. Please try again.';
      }
    } catch (e) {
      return 'Error: Could not connect to AI service. Please check your connection and try again.';
    }
  }

  static Future<String> generateDeck(String details) async {
    return generate(
      'You are an expert startup pitch deck consultant. Create compelling pitch deck outlines with slide-by-slide content including: title slide, problem, solution, market size, business model, traction, team, competition, financials, and ask. Make it investor-ready with data-driven narratives.',
      'Create a pitch deck outline for:\n\n$details',
    );
  }

  static Future<String> generateSlide(String details) async {
    return generate(
      'You are an expert presentation slide writer. Create detailed, compelling slide content with headline, key bullet points, speaker notes, and visual suggestions. Make each slide impactful and concise.',
      'Write slide content for:\n\n$details',
    );
  }

  static Future<String> generateInvestorEmail(String details) async {
    return generate(
      'You are an expert at writing investor outreach emails. Create compelling, concise emails that get meetings. Include subject line, personalized opening, value proposition, traction highlights, and clear CTA. Keep it under 200 words.',
      'Write an investor outreach email for:\n\n$details',
    );
  }

  static Future<String> generatePitchScript(String details) async {
    return generate(
      'You are an expert pitch coach. Create engaging pitch scripts with timing notes, key talking points, emotional beats, and transitions. Include hooks, storytelling elements, and a strong close. Format with clear sections and stage directions.',
      'Write a pitch script for:\n\n$details',
    );
  }
}
