import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';

class AITutorService with ChangeNotifier {
  List<ChatMessage> _messages = [];
  bool _isProcessing = false;
  Timer? _typingTimer;
  
  // Getters
  List<ChatMessage> get messages => _messages;
  bool get isProcessing => _isProcessing;
  
  // Initialize chat history
  Future<void> initialize() async {
    await loadChatHistory();
  }
  
  // Load chat history from local storage
  Future<void> loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = prefs.getString('ai_tutor_messages');
      
      if (messagesJson != null) {
        final List<dynamic> decoded = jsonDecode(messagesJson);
        _messages = decoded.map((item) => ChatMessage.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading chat history: $e');
      }
    }
  }
  
  // Save chat history to local storage
  Future<void> saveChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = jsonEncode(_messages.map((msg) => msg.toJson()).toList());
      prefs.setString('ai_tutor_messages', messagesJson);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving chat history: $e');
      }
    }
  }
  
  // Add user message
  void addUserMessage(String text) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    _messages.add(message);
    saveChatHistory();
    notifyListeners();
  }
  
  // Send message to AI tutor (mock for now)
  Future<void> sendMessage(String text) async {
    addUserMessage(text);
    
    _isProcessing = true;
    notifyListeners();
    
    try {
      // Simulate AI typing delay (1-3 seconds)
      final delay = 1000 + (text.length * 30).clamp(0, 2000);
      
      _typingTimer = Timer(Duration(milliseconds: delay), () async {
        // Mock AI response - to be replaced with OpenAI API call
        String response;
        
        if (text.toLowerCase().contains('asvab')) {
          response = "The ASVAB (Armed Services Vocational Aptitude Battery) is a series of tests that measures your strengths and potential for success in military training. It has 9 sections: Word Knowledge, Paragraph Comprehension, Arithmetic Reasoning, Mathematics Knowledge, General Science, Electronics Information, Auto Information, Shop Information, and Mechanical Comprehension. Your scores help determine which military jobs you qualify for. Would you like me to help you prepare for a specific section?";
        } else if (text.toLowerCase().contains('army') || 
                  text.toLowerCase().contains('navy') || 
                  text.toLowerCase().contains('air force') || 
                  text.toLowerCase().contains('marines') || 
                  text.toLowerCase().contains('coast guard') || 
                  text.toLowerCase().contains('space force')) {
          response = "Each military branch offers unique opportunities and career paths. The Army is the largest branch and offers over 200 job opportunities. The Navy operates at sea and specializes in naval and amphibious operations. The Air Force focuses on air operations, technology, and cybersecurity. The Marines are an elite fighting force specializing in expeditionary warfare. The Coast Guard protects U.S. waterways and performs search and rescue. The Space Force is the newest branch, focusing on space operations and technology. Which branch are you most interested in learning more about?";
        } else if (text.toLowerCase().contains('pay') || text.toLowerCase().contains('salary') || text.toLowerCase().contains('money')) {
          response = "Military pay consists of several components: Basic Pay (based on rank and years of service), Basic Allowance for Housing (BAH - depends on location, rank, and dependents), Basic Allowance for Subsistence (BAS - food allowance), and various special pays and bonuses. For example, an E-3 with 2 years of service earns about \$2,400/month in basic pay, plus BAH and BAS. Would you like to know more about specific ranks or benefits?";
        } else if (text.toLowerCase().contains('hi') || 
                  text.toLowerCase().contains('hello') || 
                  text.toLowerCase().contains('hey') || 
                  text.toLowerCase().contains('start')) {
          response = "Hello! I'm your Military Buddy AI Tutor. I can help you learn about military careers, prepare for the ASVAB test, understand military pay and benefits, or answer questions about military life. What would you like to know about today?";
        } else {
          response = "I'm here to help with military-related questions about careers, ASVAB preparation, military life, benefits, and more. Could you please provide more details about what you'd like to learn?";
        }
        
        final aiMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        );
        
        _messages.add(aiMessage);
        _isProcessing = false;
        saveChatHistory();
        notifyListeners();
      });
    } catch (e) {
      _isProcessing = false;
      notifyListeners();
      
      if (kDebugMode) {
        print('Error sending message: $e');
      }
      
      // Add error message
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: "Sorry, I'm having trouble connecting right now. Please try again later.",
        isUser: false,
        timestamp: DateTime.now(),
      );
      
      _messages.add(errorMessage);
      saveChatHistory();
      notifyListeners();
    }
  }
  
  // Clear chat history
  Future<void> clearChatHistory() async {
    _messages.clear();
    
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('ai_tutor_messages');
    
    notifyListeners();
  }
  
  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }
}