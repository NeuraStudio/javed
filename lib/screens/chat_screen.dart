import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/app_drawer.dart';
import '../widgets/attachment_sheet.dart';
import 'live_session_screen.dart';
import 'browser_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _pendingAttachmentNote = '';

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final full = _pendingAttachmentNote.isEmpty ? text : '$text $_pendingAttachmentNote';
    context.read<ChatProvider>().sendMessage(full);
    _controller.clear();
    setState(() => _pendingAttachmentNote = '');
    _scrollToBottom();
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

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('NeuraAster'),
        actions: [
          IconButton(
            icon: const Icon(Icons.public),
            tooltip: 'Browser',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BrowserScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            tooltip: 'New chat',
            onPressed: () => chat.startNewChat(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chat.messages.isEmpty
                ? const Center(
                    child: Text('Start a conversation with NeuraAster', style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    itemCount: chat.messages.length,
                    itemBuilder: (context, i) => MessageBubble(message: chat.messages[i]),
                  ),
          ),
          if (chat.isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          if (_pendingAttachmentNote.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(_pendingAttachmentNote),
                  onDeleted: () => setState(() => _pendingAttachmentNote = ''),
                ),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      showAttachmentSheet(context, onPicked: (result) {
                        setState(() => _pendingAttachmentNote = result.description);
                      });
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Chat with NeuraAster...',
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic_none),
                    tooltip: 'Live session',
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveSessionScreen())),
                  ),
                  IconButton(icon: const Icon(Icons.send), onPressed: _send),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
