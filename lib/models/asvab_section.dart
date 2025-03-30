class ASVABSection {
  final String id;
  final String name;
  final String description;
  final int timeInMinutes;
  final int questionCount;
  
  ASVABSection({
    required this.id,
    required this.name,
    required this.description,
    required this.timeInMinutes,
    required this.questionCount,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'timeInMinutes': timeInMinutes,
      'questionCount': questionCount,
    };
  }
  
  factory ASVABSection.fromJson(Map<String, dynamic> json) {
    return ASVABSection(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      timeInMinutes: json['timeInMinutes'],
      questionCount: json['questionCount'],
    );
  }
}