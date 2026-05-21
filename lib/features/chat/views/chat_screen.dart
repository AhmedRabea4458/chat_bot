import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../viewmodels/chat_view_model.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();
    final vm = context.read<ChatViewModel>();
    await vm.sendMessage(text);
    _scrollToBottom();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatViewModel>(
              builder: (context, vm, _) {
                // Build the display list: real messages + optional loading bubble
                final List<ChatMessage> display = [
                  ...vm.messages,
                  if (vm.isLoading)
                    ChatMessage(text: '', isUser: false, isLoading: true),
                ];

                if (display.isEmpty) return const _EmptyState();

                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _scrollToBottom(),
                );

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  itemCount: display.length,
                  itemBuilder: (_, i) => MessageBubble(message: display[i]),
                );
              },
            ),
          ),
          _InputBar(controller: _inputController, onSend: _handleSend),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0D0D1A),
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BrainRot AI',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                'Analytics Assistant',
                style: GoogleFonts.outfit(fontSize: 11, color: Colors.white38),
              ),
            ],
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7C3AED), Colors.transparent],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7C3AED).withOpacity(0.1),
              border: Border.all(
                color: const Color(0xFF7C3AED).withOpacity(0.25),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              color: Color(0xFF7C3AED),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Ask me anything',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'I can analyze your data and show insights.',
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.white38),
          ),
        ],
      ),
    );
  }
}

// ─── Input Bar ─────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF7C3AED).withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF7C3AED).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: controller,
                style: GoogleFonts.outfit(fontSize: 14, color: Colors.white),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: GoogleFonts.outfit(
                    color: Colors.white24,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Consumer<ChatViewModel>(
            builder:
                (_, vm, __) => GestureDetector(
                  onTap: vm.isLoading ? null : onSend,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient:
                          vm.isLoading
                              ? const LinearGradient(
                                colors: [Color(0xFF3B3B5C), Color(0xFF2A2A44)],
                              )
                              : const LinearGradient(
                                colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                      boxShadow:
                          vm.isLoading
                              ? []
                              : [
                                BoxShadow(
                                  color: const Color(
                                    0xFF7C3AED,
                                  ).withOpacity(0.5),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                    ),
                    child: Icon(
                      vm.isLoading
                          ? Icons.hourglass_empty_rounded
                          : Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
