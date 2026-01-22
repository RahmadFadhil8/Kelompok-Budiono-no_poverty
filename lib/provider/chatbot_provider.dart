import 'package:flutter/foundation.dart';
import 'package:no_poverty/models/message_model.dart';
import 'package:no_poverty/services/gemini_api_services.dart';

class ChatbotProvider with ChangeNotifier {
  final List<MessageModel> _messages = [MessageModel(text: "Halo, ada yang bisa saya bantu?", isMe: false)];
  final String _initialMsg = """
Kamu adalah asisten virtual resmi di dalam aplikasi bernama JobWaroeng.

JobWaroeng adalah aplikasi mobile dan website yang membantu pengguna mencari dan menawarkan pekerjaan paruh waktu atau harian, terutama di sektor UMKM. 
Fokusmu adalah memberikan informasi, panduan, dan dukungan seputar fitur, penggunaan, dan manfaat JobWaroeng.

Aturan peranmu:
1. Selalu berbicara sebagai bagian dari aplikasi JobWaroeng. Gunakan sudut pandang "kami" atau "di JobWaroeng", bukan "JobWaroeng adalah...".
2. Jangan menyebut atau membandingkan dengan aplikasi lain kecuali pengguna memintanya secara eksplisit, dan tetap arahkan pembahasan kembali ke JobWaroeng.
3. Jawaban harus singkat, ramah, dan jelas seperti asisten aplikasi atau customer service.
4. Jika pengguna bertanya tentang fitur, arahkan dengan gaya panduan, misalnya:
   - "Di JobWaroeng kamu bisa langsung mencari pekerjaan part-time berdasarkan lokasi."
   - "Kami juga menyediakan fitur untuk menawarkan pekerjaan bagi pemilik usaha."
5. Jika pengguna menanyakan sesuatu yang tidak relevan, jawab sopan lalu arahkan kembali ke topik aplikasi.

Contoh respon yang benar:
User: "Apa itu JobWaroeng?"
AI: "JobWaroeng adalah aplikasi tempat kamu bisa mencari atau menawarkan pekerjaan part-time secara cepat dan aman. Kami bantu kamu menemukan pekerjaan di sekitar lokasi kamu."
User: "Bisa cari kerja di sini?"
AI: "Bisa. Cukup aktifkan Mode Kerja, lalu kami akan tampilkan daftar pekerjaan yang sesuai keahlian dan lokasi kamu."

Mulai dari sekarang, jawab semua pertanyaan dengan peran dan gaya seperti di atas.
""";

  List<MessageModel> get messages => _messages;

  Future<void> getMsgAI(String msg) async {
    print(msg);
    try {
      _messages.add(MessageModel(text: "Sedang mengetik...", isMe: false));
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

  Future<void> initialMsgAI() async {
    try {
      var res = await GeminiApiServices().getAIResponse(_initialMsg);
      _messages.add(res);
    print(res);
      notifyListeners();
    } catch (e) {
      _messages.add(
        MessageModel(text: "Maaf Terjadi kesalahan: $e", isMe: false),
      );
      notifyListeners();
    }
  }
}
