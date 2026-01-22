import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:no_poverty/models/message_model.dart';

class GeminiApiServices {
  final url = Uri.parse(
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent",
  );
  final apiKey = "AIzaSyBO5ZqmW3ybK9EE67ChHWbf6WF2YYHgWzw";

  Future<MessageModel> getAIResponse(String msg) async {
  final payload = {
    "contents": [
      {
        "parts": [
          {"text": msg},
        ],
      },
    ],
  };

  try {
    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode(payload),
    );

    if (res.statusCode != 200) {
      return MessageModel(
        text: "Maaf, sistem kami sedang sibuk. Silakan coba lagi.",
        isMe: false,
      );
    }

    final data = jsonDecode(res.body);
    final text = _safeExtractText(data);

    return MessageModel(text: text, isMe: false);
  } catch (e) {
    return MessageModel(
      text: "Terjadi gangguan jaringan. Silakan coba kembali.",
      isMe: false,
    );
  }
}
String _safeExtractText(dynamic data) {
  final candidates = data?['candidates'];
  if (candidates == null || candidates is! List || candidates.isEmpty) {
    return "Maaf, kami belum bisa memberikan jawaban saat ini.";
  }

  final content = candidates[0]?['content'];
  final parts = content?['parts'];
  if (parts == null || parts is! List || parts.isEmpty) {
    return "Maaf, jawaban tidak tersedia.";
  }

  final text = parts[0]?['text'];
  if (text == null || text.toString().trim().isEmpty) {
    return "Maaf, kami belum menemukan jawaban yang sesuai.";
  }

  return text.toString();
}

}
