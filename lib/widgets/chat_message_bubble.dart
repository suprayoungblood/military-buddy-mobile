import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../utils/theme.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showAvatar;
  
  const ChatMessageBubble({
    Key? key,
    required this.message,
    this.showAvatar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          // AI Avatar
          if (!message.isUser && showAvatar)
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                color: MilitaryTheme.navy,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 20,
              ),
            )
          else if (!message.isUser && !showAvatar)
            const SizedBox(width: 44),
          
          // Message bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? MilitaryTheme.navy
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(16.0).copyWith(
                  bottomLeft: message.isUser 
                      ? const Radius.circular(16.0)
                      : const Radius.circular(4.0),
                  bottomRight: message.isUser 
                      ? const Radius.circular(4.0)
                      : const Radius.circular(16.0),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          
          // User Avatar
          if (message.isUser && showAvatar)
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(left: 8.0),
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            )
          else if (message.isUser && !showAvatar)
            const SizedBox(width: 44),
        ],
      ),
    );
  }
}