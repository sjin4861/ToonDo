// lib/services/gpt_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class GptService {
  Future<Map<String, dynamic>> analyzePlannerImage(String base64Image) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.apiKey}',
        },
        body: jsonEncode({
          "model": "gpt-4o",
          "messages": [
            {
              "role": "system",
              "content": [
                {
                  "type": "text",
                  "text": Constants.GODLIFE
                }
              ]
            },
            {
              "role": "user",
              "content": [
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
                }
              ]
            }
          ],
          "temperature": 0.7,
          "max_tokens": 150,
          "top_p": 1,
          "frequency_penalty": 0,
          "presence_penalty": 0
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception(
            'Failed to load data: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw e;
    }
  }
}