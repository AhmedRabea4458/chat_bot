import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class ChatViewModel extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;

  static const String _apiUrl = 'http://127.0.0.1:5000/chat';

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(ChatMessage(text: text.trim(), isUser: true));
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': text.trim()}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        final message = ChatMessage.fromJson(json);

        _messages.add(message);
      } else {
        _addErrorMessage('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ChatViewModel error: $e');
      _addErrorMessage('Could not connect. Please try again.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _addErrorMessage(String msg) {
    _messages.add(ChatMessage(text: msg, isUser: false));
  }
}
