import 'package:flutter/material.dart';
import '../models/asvab_section.dart';
import '../models/asvab_score.dart';
import '../utils/theme.dart';

class ASVABSectionCard extends StatelessWidget {
  final ASVABSection section;
  final ASVABScore? score;
  final VoidCallback onTap;
  
  const ASVABSectionCard({
    Key? key,
    required this.section,
    this.score,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with score
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${section.questionCount} questions • ${section.timeInMinutes} minutes',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (score != null)
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _getScoreColor(score!.score).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${score!.score}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getScoreColor(score!.score),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Description
              Text(
                section.description,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Progress bar (if score exists)
              if (score != null) ...[
                LinearProgressIndicator(
                  value: score!.score / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(score!.score)),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Score: ${score!.score}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(score!.score),
                      ),
                    ),
                    Text(
                      'Last Practice: ${score!.date.month}/${score!.date.day}/${score!.date.year}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
              
              // Practice buttons
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MilitaryTheme.navy,
                        side: BorderSide(color: MilitaryTheme.navy),
                      ),
                      child: const Text('Study'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MilitaryTheme.navy,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Practice Test'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.amber;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }
}