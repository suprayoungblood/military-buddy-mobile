import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Temporarily disabled: import 'package:fl_chart/fl_chart.dart';
import '../services/asvab_service.dart';
import '../models/asvab_section.dart';
import '../models/asvab_score.dart';
import '../utils/theme.dart';
import '../widgets/asvab_section_card.dart';

class ASVABPrepScreen extends StatefulWidget {
  const ASVABPrepScreen({Key? key}) : super(key: key);

  @override
  State<ASVABPrepScreen> createState() => _ASVABPrepScreenState();
}

class _ASVABPrepScreenState extends State<ASVABPrepScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Initialize ASVAB data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ASVABService>(context, listen: false).initialize();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final asvabService = Provider.of<ASVABService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASVAB Preparation'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'SECTIONS'),
            Tab(text: 'SCORES'),
            Tab(text: 'TEST TIPS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Sections tab
          _buildSectionsTab(asvabService),
          
          // Scores tab
          _buildScoresTab(asvabService),
          
          // Test tips tab
          _buildTestTipsTab(),
        ],
      ),
    );
  }
  
  Widget _buildSectionsTab(ASVABService asvabService) {
    final sections = asvabService.sections;
    
    return Container(
      color: Colors.grey[100],
      child: sections.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                final score = asvabService.sectionScores[section.id];
                
                return ASVABSectionCard(
                  section: section,
                  score: score,
                  onTap: () {
                    _navigateToSectionDetail(context, section.id);
                  },
                );
              },
            ),
    );
  }
  
  Widget _buildScoresTab(ASVABService asvabService) {
    final sectionScores = asvabService.sectionScores;
    final overallScore = asvabService.overallScore;
    final afqtScore = asvabService.calculateAFQTScore();
    
    // No scores yet
    if (sectionScores.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.quiz,
              size: 72,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No scores yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Complete practice tests to see your scores here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tabController.animateTo(0); // Switch to sections tab
                });
              },
              child: const Text('Start Practicing'),
            ),
          ],
        ),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall score card
          if (overallScore != null)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overall ASVAB Score',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Stack(
                            children: [
                              Center(
                                child: SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: CircularProgressIndicator(
                                    value: overallScore.score / 100,
                                    strokeWidth: 8,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _getScoreColor(overallScore.score),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  '${overallScore.score}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Last updated:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${overallScore.date.month}/${overallScore.date.day}/${overallScore.date.year}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              if (afqtScore != null) ...[
                                const SizedBox(height: 8),
                                const Text(
                                  'Estimated AFQT:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '$afqtScore',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Section scores
          const Text(
            'Section Scores',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Simplified score visualization (replacing chart)
          Container(
            height: 220,
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: sectionScores.entries.map((entry) {
                final sectionId = entry.key;
                final score = entry.value.score;
                
                // Abbreviate section names
                String title = sectionId
                    .split('_')
                    .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
                    .join('');
                
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      score.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(score),
                      ),
                    ),
                    Container(
                      width: 20,
                      height: score.toDouble() * 1.5,
                      color: _getScoreColor(score),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Individual section scores
          Column(
            children: sectionScores.entries.map((entry) {
              final sectionId = entry.key;
              final score = entry.value;
              
              // Find full section info
              final section = asvabService.sections.firstWhere(
                (s) => s.id == sectionId,
                orElse: () => ASVABSection(
                  id: sectionId,
                  name: sectionId.split('_').map((word) => 
                      word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '').join(' '),
                  description: '',
                  timeInMinutes: 0,
                  questionCount: 0,
                ),
              );
              
              return ListTile(
                title: Text(section.name),
                subtitle: Text('Last updated: ${score.date.month}/${score.date.day}/${score.date.year}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${score.score}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(score.score),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        _navigateToSectionDetail(context, sectionId);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // Reset scores button
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Reset All Scores'),
              onPressed: () {
                _showResetConfirmation(context, asvabService);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTestTipsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ASVAB Test Tips',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildTipCard(
            title: 'General Test Preparation',
            tips: [
              'Start preparing at least 2-3 months before your test date',
              'Study consistently for 30-60 minutes daily',
              'Take practice tests to simulate real test conditions',
              'Identify your weak areas and focus on improving them',
              'Get plenty of rest the night before the test',
            ],
          ),
          
          _buildTipCard(
            title: 'Test-Taking Strategies',
            tips: [
              'Read instructions carefully before starting each section',
              'Budget your time - don\'t spend too long on any one question',
              'Skip difficult questions and return to them later',
              'Eliminate obviously incorrect answers to improve guessing odds',
              'Review your answers if time permits',
              'Answer every question - there\'s no penalty for guessing',
            ],
          ),
          
          _buildTipCard(
            title: 'Section-Specific Tips',
            tips: [
              'Word Knowledge: Study word roots, prefixes, and suffixes',
              'Paragraph Comprehension: Read questions before the passage',
              'Arithmetic Reasoning: Draw diagrams for word problems',
              'Mathematics Knowledge: Memorize formulas and properties',
              'General Science: Focus on basic principles across disciplines',
              'Electronics: Learn basic circuits and component functions',
              'Auto & Shop: Familiarize yourself with tools and their uses',
              'Mechanical Comprehension: Understand simple machines and physics',
            ],
          ),
          
          _buildTipCard(
            title: 'Understanding Your Scores',
            tips: [
              'AFQT score (0-99) determines eligibility for enlistment',
              'Line scores determine qualification for specific jobs',
              'Each branch has different minimum score requirements',
              'Higher scores mean more job options',
              'You can retake the ASVAB after a waiting period',
              'Scores are valid for 2 years',
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTipCard({required String title, required List<String> tips}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Text(tip)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
  
  void _navigateToSectionDetail(BuildContext context, String sectionId) {
    Navigator.pushNamed(
      context,
      '/asvab_section',
      arguments: sectionId,
    );
  }
  
  void _showResetConfirmation(BuildContext context, ASVABService asvabService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Scores?'),
        content: const Text('This will delete all your ASVAB practice scores. This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
            onPressed: () {
              asvabService.resetScores();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All scores have been reset')),
              );
            },
          ),
        ],
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