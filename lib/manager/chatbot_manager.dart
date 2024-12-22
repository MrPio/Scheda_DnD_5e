import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

enum HuggingModel {
  qwen72b('Qwen/Qwen2.5-72B-Instruct'),
  llama3b('meta-llama/Llama-3.2-3B-Instruct'),
  llama70b('meta-llama/Llama-3.3-70B-Instruct');

  final String name;

  const HuggingModel(this.name);
}

class ChatbotManager {
  static final ChatbotManager _instance = ChatbotManager._();

  factory ChatbotManager() => _instance;

  ChatbotManager._();

  static const String _apiUrl = 'https://api-inference.huggingface.co/models/';
  static const _hfToken = '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';

  Future<String?> ask(HuggingModel model, String query) async {
    final response = await http.post(
      Uri.parse('$_apiUrl${model.name}'),
      headers: {
        'Authorization': 'Bearer $_hfToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({/*'temperature': 0.5,*/ 'inputs': query}),
    );

    if (response.statusCode == 200) {
      String answer = jsonDecode(response.body)[0]['generated_text'];
      if (answer.contains(query)) answer = answer.split(query)[1];
      return answer;
    } else {
      print('⛔ ${response.body}');
      throw HttpException('HTTP error: ${response.statusCode}');
    }
  }
}
