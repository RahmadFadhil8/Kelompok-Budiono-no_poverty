import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:no_poverty/models/message_model.dart';
import 'package:no_poverty/services/gemini_api_services.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final messages = [
    MessageModel(
      text:
          "Halo! Saya RBA Assistant, asisten virtual Anda. Bagaimana saya bisa membantu Anda hari ini?",
      isMe: false,
    ),
    MessageModel(text: "Bagaimana cara membuat job?", isMe: true),
    MessageModel(
      text: '''
Untuk membuat job, ikuti langkah berikut:

1. Klik tombol **"Buat Job"** di halaman beranda
2. Pilih kategori pekerjaan
3. Isi detail pekerjaan (judul, deskripsi, lokasi)
4. Tentukan budget dan jadwal

_Apakah ada yang perlu saya bantu lebih lanjut?_
''',
      isMe: false,
    ),
    MessageModel(
      text: '''
Untuk membuat job, ikuti langkah berikut:

1. Klik tombol **"Buat Job"** di halaman beranda
2. Pilih kategori pekerjaan
3. Isi detail pekerjaan (judul, deskripsi, lokasi)
4. Tentukan budget dan jadwal

_Apakah ada yang perlu saya bantu lebih lanjut?_
''',
      isMe: true,
    ),
    MessageModel(text: '''Untuk membuat job''', isMe: false),
  ];

  @override
  void initState() {
    getAi();
    // TODO: implement initState
    super.initState();
  }

  Future<void> getAi() async {
    print("jalankan");
    await GeminiApiServices().getAIResponse("halo");
    print("selesai");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RBA Assistant"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];

          return Align(
            alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: msg.isMe ? Colors.blue[300] : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft:
                        msg.isMe
                            ? const Radius.circular(12)
                            : const Radius.circular(0),
                    bottomRight:
                        msg.isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(12),
                  ),
                ),
                child: MarkdownBody(
                  data: msg.text,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16, height: 1.5),
                    listBullet: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Ketik pesan...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              suffixIcon: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
