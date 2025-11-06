import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:no_poverty/provider/chatbot_provider.dart';
import 'package:provider/provider.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _msgCtr = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? msgInpt;

  @override
  void dispose() {
    _msgCtr.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(ChatbotProvider chatProvider) {
    if (msgInpt == null || msgInpt!.trim().isEmpty) return;
    chatProvider.saveChatFromMe(msgInpt!.trim());
    chatProvider.getMsgAI(msgInpt!.trim());
    _msgCtr.clear();
    msgInpt = '';
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatbotProvider>(context);
    final messages = chatProvider.messages;
    return Scaffold(
      appBar: AppBar(
        title: const Text("JobWaroeng Assistant"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body:Column(
  children: [
    Expanded(
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: messages.map((msg) {
              return Align(
                alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: msg.isMe ? Colors.blue[300] : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: msg.isMe
                            ? const Radius.circular(12)
                            : const Radius.circular(0),
                        bottomRight: msg.isMe
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
            }).toList(),
          ),
        ),
      ),
    ),
    SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _msgCtr,
                cursorColor: Colors.blueAccent,
                cursorWidth: 2.2,
                cursorRadius: const Radius.circular(2),
                onChanged: (value) {
                  setState(() {
                    msgInpt = value;
                  });
                },
                onSubmitted: (_) => _sendMessage(chatProvider),
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 24,
              backgroundColor: (msgInpt != null && msgInpt!.trim().isNotEmpty)
                  ? Colors.blue
                  : Colors.grey,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: (msgInpt != null && msgInpt!.trim().isNotEmpty)
                    ? () => _sendMessage(chatProvider)
                    : null,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),
resizeToAvoidBottomInset: true,

    );
  }
}
