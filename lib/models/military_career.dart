class MilitaryCareer {
  final String id;
  final String title;
  final String branchId;
  final String branchName;
  final String code;
  final String description;
  final List<String> duties;
  final Map<String, dynamic> requirements;
  final String trainingLocation;
  final String trainingDuration;
  final String advancement;
  final List<String> relatedCivilianJobs;
  
  MilitaryCareer({
    required this.id,
    required this.title,
    required this.branchId,
    required this.branchName,
    required this.code,
    required this.description,
    required this.duties,
    required this.requirements,
    required this.trainingLocation,
    required this.trainingDuration,
    required this.advancement,
    required this.relatedCivilianJobs,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'branchId': branchId,
      'branchName': branchName,
      'code': code,
      'description': description,
      'duties': duties,
      'requirements': requirements,
      'trainingLocation': trainingLocation,
      'trainingDuration': trainingDuration,
      'advancement': advancement,
      'relatedCivilianJobs': relatedCivilianJobs,
    };
  }
  
  factory MilitaryCareer.fromJson(Map<String, dynamic> json) {
    return MilitaryCareer(
      id: json['id'],
      title: json['title'],
      branchId: json['branchId'],
      branchName: json['branchName'],
      code: json['code'],
      description: json['description'],
      duties: List<String>.from(json['duties']),
      requirements: json['requirements'],
      trainingLocation: json['trainingLocation'],
      trainingDuration: json['trainingDuration'],
      advancement: json['advancement'],
      relatedCivilianJobs: List<String>.from(json['relatedCivilianJobs']),
    );
  }
  
  // Empty constructor for use in error cases
  factory MilitaryCareer.empty() {
    return MilitaryCareer(
      id: '',
      title: '',
      branchId: '',
      branchName: '',
      code: '',
      description: '',
      duties: [],
      requirements: {},
      trainingLocation: '',
      trainingDuration: '',
      advancement: '',
      relatedCivilianJobs: [],
    );
  }
}