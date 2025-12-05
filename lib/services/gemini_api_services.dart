import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:no_poverty/models/message_model.dart';

class GeminiApiServices {
  final url = Uri.parse(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent",
  );
  final apiKey = "AIzaSyBO5ZqmW3ybK9EE67ChHWbf6WF2YYHgWzw";

  Future<MessageModel> getAIResponse(String msg) async {
    var payload = {
      "contents": [
        {
          "parts": [
            {"text": msg},
          ],
        },
      ],
    };

    try {
      var res = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-goog-api-key': apiKey,
        },
        body: jsonEncode(payload),
      );

      if (res.statusCode == 503) {
        return MessageModel(
          text: "The model is overloaded. Please try again later",
          isMe: false,
        );
      }

      var data = jsonDecode(res.body);
      var resMsg = MessageModel(
        text: data['candidates'][0]['content']['parts'][0]['text'],
        isMe: false,
      );
      return resMsg;
    } catch (e) {
      rethrow;
    }
  }
}
