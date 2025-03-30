import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ai_tutor_service.dart';
import '../models/chat_message.dart';
import '../utils/theme.dart';
import '../widgets/chat_message_bubble.dart';

class AITutorScreen extends StatefulWidget {
  const AITutorScreen({Key? key}) : super(key: key);

  @override
  State<AITutorScreen> createState() => _AITutorScreenState();
}

class _AITutorScreenState extends State<AITutorScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showSuggestions = true;
  
  final List<String> _suggestions = [
    'Help me prepare for the ASVAB',
    'What careers are available in the Army?',
    'How much does a military officer make?',
    'What is the AFQT score?',
    'Tell me about joining the Air Force',
  ];
  
  @override
  void initState() {
    super.initState();
    // Initialize chat history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AITutorService>(context, listen: false).initialize();
    });
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    
    final tutorService = Provider.of<AITutorService>(context, listen: false);
    tutorService.sendMessage(text);
    
    _messageController.clear();
    setState(() {
      _showSuggestions = false;
    });
    
    // Scroll to bottom after message is sent
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
  }
  
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final tutorService = Provider.of<AITutorService>(context);
    final messages = tutorService.messages;
    
    // Auto-scroll when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messages.isNotEmpty) {
        _scrollToBottom();
      }
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Military Tutor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showClearChatConfirmation(context, tutorService);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Welcome message
          if (messages.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: MilitaryTheme.navy.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.smart_toy,
                            color: MilitaryTheme.navy,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Military Buddy AI Tutor',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: MilitaryTheme.navy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Hello! I can help you with:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('• ASVAB test preparation'),
                      const Text('• Military career information'),
                      const Text('• Understanding military benefits'),
                      const Text('• Advice on military life and training'),
                      const Text('• Answering questions about enlisting'),
                      const SizedBox(height: 12),
                      const Text(
                        'Type your question below or tap one of the suggestions to get started.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Chat messages
          Expanded(
            child: messages.isEmpty
                ? _buildSuggestions()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ChatMessageBubble(
                        message: message,
                        showAvatar: index == 0 || 
                                   messages[index - 1].isUser != message.isUser,
                      );
                    },
                  ),
          ),
          
          // Typing indicator
          if (tutorService.isProcessing)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: MilitaryTheme.navy,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'AI Tutor is typing...',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          
          // Quick suggestions after messages
          if (messages.isNotEmpty && !tutorService.isProcessing && _showSuggestions)
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Chip(
                      backgroundColor: Colors.grey[200],
                      label: Text(_suggestions[index]),
                      onDeleted: () {
                        _messageController.text = _suggestions[index];
                        _sendMessage();
                      },
                      deleteIcon: const Icon(
                        Icons.send,
                        size: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
          
          // Message input
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                // Voice input button (placeholder)
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Voice input coming soon!')),
                    );
                  },
                ),
                // Text input field
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (text) {
                      setState(() {
                        _showSuggestions = false;
                      });
                    },
                    onTap: () {
                      setState(() {
                        _showSuggestions = false;
                      });
                    },
                    onSubmitted: (text) {
                      _sendMessage();
                    },
                  ),
                ),
                // Send button
                IconButton(
                  icon: const Icon(Icons.send),
                  color: MilitaryTheme.navy,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Try asking about:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    _messageController.text = _suggestions[index];
                    _sendMessage();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        _suggestions[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  void _showClearChatConfirmation(BuildContext context, AITutorService tutorService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History?'),
        content: const Text('This will delete all messages. This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
            onPressed: () {
              tutorService.clearChatHistory();
              Navigator.of(context).pop();
              setState(() {
                _showSuggestions = true;
              });
            },
          ),
        ],
      ),
    );
  }
}