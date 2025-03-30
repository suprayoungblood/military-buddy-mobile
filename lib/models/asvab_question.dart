class ASVABQuestion {
  final String id;
  final String text;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String difficulty; // 'easy', 'medium', 'hard'
  final String sectionId;
  
  ASVABQuestion({
    required this.id,
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.difficulty,
    required this.sectionId,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
      'difficulty': difficulty,
      'sectionId': sectionId,
    };
  }
  
  factory ASVABQuestion.fromJson(Map<String, dynamic> json) {
    return ASVABQuestion(
      id: json['id'],
      text: json['text'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctOptionIndex'],
      explanation: json['explanation'],
      difficulty: json['difficulty'],
      sectionId: json['sectionId'],
    );
  }
}