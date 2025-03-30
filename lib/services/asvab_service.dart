import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/asvab_question.dart';
import '../models/asvab_section.dart';
import '../models/asvab_score.dart';

class ASVABService with ChangeNotifier {
  List<ASVABSection> _sections = [];
  Map<String, ASVABScore> _sectionScores = {};
  ASVABScore? _overallScore;
  
  // Getters
  List<ASVABSection> get sections => _sections;
  Map<String, ASVABScore> get sectionScores => _sectionScores;
  ASVABScore? get overallScore => _overallScore;
  
  // Initialize ASVAB data
  Future<void> initialize() async {
    await loadMockData();
    await loadScores();
  }
  
  // Load mock ASVAB section data
  Future<void> loadMockData() async {
    // Mock ASVAB sections
    _sections = [
      ASVABSection(
        id: 'word_knowledge',
        name: 'Word Knowledge',
        description: 'Tests your ability to understand the meaning of words through synonyms.',
        timeInMinutes: 11,
        questionCount: 35,
      ),
      ASVABSection(
        id: 'paragraph_comprehension',
        name: 'Paragraph Comprehension',
        description: 'Measures your ability to understand what you read.',
        timeInMinutes: 13,
        questionCount: 15,
      ),
      ASVABSection(
        id: 'arithmetic_reasoning',
        name: 'Arithmetic Reasoning',
        description: 'Measures your ability to solve basic arithmetic word problems.',
        timeInMinutes: 39,
        questionCount: 30,
      ),
      ASVABSection(
        id: 'mathematics_knowledge',
        name: 'Mathematics Knowledge',
        description: 'Tests your knowledge of mathematical concepts and principles.',
        timeInMinutes: 24,
        questionCount: 25,
      ),
      ASVABSection(
        id: 'general_science',
        name: 'General Science',
        description: 'Measures your knowledge of physical and biological sciences.',
        timeInMinutes: 11,
        questionCount: 25,
      ),
      ASVABSection(
        id: 'electronics_information',
        name: 'Electronics Information',
        description: 'Tests your knowledge of electricity and electronics.',
        timeInMinutes: 9,
        questionCount: 20,
      ),
      ASVABSection(
        id: 'auto_information',
        name: 'Auto Information',
        description: 'Tests your knowledge of automobile technology.',
        timeInMinutes: 7,
        questionCount: 25,
      ),
      ASVABSection(
        id: 'shop_information',
        name: 'Shop Information',
        description: 'Tests your knowledge of tools, shop practices, and procedures.',
        timeInMinutes: 6,
        questionCount: 25,
      ),
      ASVABSection(
        id: 'mechanical_comprehension',
        name: 'Mechanical Comprehension',
        description: 'Tests your knowledge of mechanical and physical principles.',
        timeInMinutes: 19,
        questionCount: 25,
      ),
    ];
    
    notifyListeners();
  }
  
  // Load user scores from local storage
  Future<void> loadScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load section scores
      for (final section in _sections) {
        final scoreKey = 'asvab_score_${section.id}';
        final scoreValue = prefs.getInt(scoreKey);
        
        if (scoreValue != null) {
          _sectionScores[section.id] = ASVABScore(
            sectionId: section.id,
            score: scoreValue,
            date: DateTime.fromMillisecondsSinceEpoch(
              prefs.getInt('asvab_score_date_${section.id}') ?? 
              DateTime.now().millisecondsSinceEpoch
            ),
          );
        }
      }
      
      // Load overall score
      final overallScoreValue = prefs.getInt('asvab_score_overall');
      if (overallScoreValue != null) {
        _overallScore = ASVABScore(
          sectionId: 'overall',
          score: overallScoreValue,
          date: DateTime.fromMillisecondsSinceEpoch(
            prefs.getInt('asvab_score_date_overall') ?? 
            DateTime.now().millisecondsSinceEpoch
          ),
        );
      }
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading ASVAB scores: $e');
      }
    }
  }
  
  // Save scores to local storage
  Future<void> saveScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save section scores
      _sectionScores.forEach((sectionId, score) {
        prefs.setInt('asvab_score_$sectionId', score.score);
        prefs.setInt('asvab_score_date_$sectionId', score.date.millisecondsSinceEpoch);
      });
      
      // Save overall score
      if (_overallScore != null) {
        prefs.setInt('asvab_score_overall', _overallScore!.score);
        prefs.setInt('asvab_score_date_overall', _overallScore!.date.millisecondsSinceEpoch);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving ASVAB scores: $e');
      }
    }
  }
  
  // Get mock questions for a specific section
  Future<List<ASVABQuestion>> getQuestionsForSection(String sectionId, {int limit = 10, String difficulty = 'medium'}) async {
    // Mock questions - to be replaced with data from backend
    List<ASVABQuestion> questions = [];
    
    if (sectionId == 'word_knowledge') {
      questions = [
        ASVABQuestion(
          id: 'wk_1',
          text: 'TRIVIAL most nearly means:',
          options: ['unimportant', 'level', 'common', 'curious'],
          correctOptionIndex: 0,
          explanation: 'Trivial means of little value or importance.',
          difficulty: 'easy',
          sectionId: 'word_knowledge',
        ),
        ASVABQuestion(
          id: 'wk_2',
          text: 'PERSEVERE most nearly means:',
          options: ['preserve', 'persist', 'permeate', 'penetrate'],
          correctOptionIndex: 1,
          explanation: 'Persevere means to continue in a course of action despite difficulty.',
          difficulty: 'medium',
          sectionId: 'word_knowledge',
        ),
        // Add more mock questions as needed
      ];
    } else if (sectionId == 'arithmetic_reasoning') {
      questions = [
        ASVABQuestion(
          id: 'ar_1',
          text: 'If a car travels at 60 miles per hour, how far will it travel in 2.5 hours?',
          options: ['120 miles', '150 miles', '180 miles', '200 miles'],
          correctOptionIndex: 1,
          explanation: 'Distance = Speed × Time = 60 miles/hour × 2.5 hours = 150 miles',
          difficulty: 'easy',
          sectionId: 'arithmetic_reasoning',
        ),
        ASVABQuestion(
          id: 'ar_2',
          text: 'A military convoy consists of 5 trucks. Each truck can carry 12 soldiers. How many trips are needed to transport 240 soldiers?',
          options: ['3', '4', '5', '6'],
          correctOptionIndex: 1,
          explanation: 'Total capacity per trip = 5 trucks × 12 soldiers = 60 soldiers. Number of trips = 240 ÷ 60 = 4 trips',
          difficulty: 'medium',
          sectionId: 'arithmetic_reasoning',
        ),
        // Add more mock questions as needed
      ];
    }
    
    // Filter by difficulty
    questions = questions.where((q) => q.difficulty == difficulty).toList();
    
    // Limit the number of questions
    if (questions.length > limit) {
      questions = questions.sublist(0, limit);
    }
    
    return questions;
  }
  
  // Submit answers and calculate score
  Future<ASVABScore> submitAnswers(String sectionId, Map<String, int> answers) async {
    // Mock scoring - in real app this would be calculated properly
    final correctCount = answers.length ~/ 2; // Mock assuming half are correct
    final totalQuestions = answers.length;
    
    // Calculate score (0-100)
    final score = (correctCount / totalQuestions * 100).round();
    
    // Update section score
    final sectionScore = ASVABScore(
      sectionId: sectionId,
      score: score,
      date: DateTime.now(),
    );
    
    _sectionScores[sectionId] = sectionScore;
    
    // Recalculate overall score
    if (_sectionScores.isNotEmpty) {
      final totalScore = _sectionScores.values.fold(0, (sum, score) => sum + score.score);
      final avgScore = totalScore ~/ _sectionScores.length;
      
      _overallScore = ASVABScore(
        sectionId: 'overall',
        score: avgScore,
        date: DateTime.now(),
      );
    }
    
    await saveScores();
    notifyListeners();
    
    return sectionScore;
  }
  
  // Calculate AFQT score from section scores
  int? calculateAFQTScore() {
    // AFQT = Word Knowledge + Paragraph Comprehension + Arithmetic Reasoning + Mathematics Knowledge
    if (_sectionScores.containsKey('word_knowledge') &&
        _sectionScores.containsKey('paragraph_comprehension') &&
        _sectionScores.containsKey('arithmetic_reasoning') &&
        _sectionScores.containsKey('mathematics_knowledge')) {
      
      final wk = _sectionScores['word_knowledge']!.score;
      final pc = _sectionScores['paragraph_comprehension']!.score;
      final ar = _sectionScores['arithmetic_reasoning']!.score;
      final mk = _sectionScores['mathematics_knowledge']!.score;
      
      // This is just a simple estimation - the real AFQT is a percentile
      return ((wk + pc + ar + mk) / 4).round();
    }
    
    return null;
  }
  
  // Reset all scores
  Future<void> resetScores() async {
    _sectionScores.clear();
    _overallScore = null;
    
    final prefs = await SharedPreferences.getInstance();
    for (final section in _sections) {
      prefs.remove('asvab_score_${section.id}');
      prefs.remove('asvab_score_date_${section.id}');
    }
    prefs.remove('asvab_score_overall');
    prefs.remove('asvab_score_date_overall');
    
    notifyListeners();
  }
}