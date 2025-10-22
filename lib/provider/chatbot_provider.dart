import 'package:flutter/foundation.dart';
import 'package:no_poverty/models/message_model.dart';
import 'package:no_poverty/services/gemini_api_services.dart';

class ChatbotProvider with ChangeNotifier {
  List<MessageModel> _messages = [
    MessageModel(text: "Halo! Ada yang bisa saya bantu?", isMe: false),
  ];

  List<MessageModel> get messages => _messages;

  Future<void> getMsgAI(String msg) async {
    try {
      saveChatFromMe(msg);
      _messages.add(MessageModel(text: "Sedang mengetik...", isMe: false));
      notifyListeners();
      var res = await GeminiApiServices().getAIResponse(msg);
      _messages.removeLast();
      _messages.add(res);
      notifyListeners();
    } catch (e) {
      if (_messages.isNotEmpty && _messages.last.text == "Sedang mengetik...") {
        _messages.removeLast();
      }
      _messages.add(
        MessageModel(text: "Maaf Terjadi kesalahan: $e", isMe: false),
      );
      notifyListeners();
    }
  }

  void saveChatFromMe(String msg) {
    _messages.add(MessageModel(text: msg, isMe: true));
    notifyListeners();
  }
}
