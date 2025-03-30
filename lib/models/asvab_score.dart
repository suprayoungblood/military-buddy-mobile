class ASVABScore {
  final String sectionId;
  final int score;
  final DateTime date;
  
  ASVABScore({
    required this.sectionId,
    required this.score,
    required this.date,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'sectionId': sectionId,
      'score': score,
      'date': date.toIso8601String(),
    };
  }
  
  factory ASVABScore.fromJson(Map<String, dynamic> json) {
    return ASVABScore(
      sectionId: json['sectionId'],
      score: json['score'],
      date: DateTime.parse(json['date']),
    );
  }
}