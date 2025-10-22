import 'package:flutter/foundation.dart';
import 'package:no_poverty/models/message_model.dart';
import 'package:no_poverty/services/gemini_api_services.dart';

class ChatbotProvider with ChangeNotifier {
  List<MessageModel> _messages = [MessageModel(text: "Halo", isMe: false)];

  List<MessageModel> get message => _messages;

  Future<void> getMsgAI(String msg) async {
    var res = await GeminiApiServices().getAIResponse(msg);
    _messages.addAll([res]);
    notifyListeners();
  }

  void saveChatFromMe(String msg) {
    _messages.add(MessageModel(text: msg, isMe: true));
    notifyListeners();
  }
}