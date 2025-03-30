import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../utils/theme.dart';
import '../widgets/feature_card.dart';
import '../widgets/branch_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _selectedBranch = '';
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onBranchSelected(String branch) {
    setState(() {
      _selectedBranch = branch;
    });
    // Here you could filter content based on selected branch
    if (branch.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selected branch: $branch'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  
  // Helper method to create staggered delay effect
  double _staggeredDelay(int index, double baseValue) {
    // Each item will start after a short delay compared to the previous one
    final itemDelay = 0.1 * index;
    final adjustedValue = baseValue - itemDelay;
    
    // Ensure we don't return negative values
    if (adjustedValue <= 0) return 0;
    
    // Ensure we don't exceed 1.0
    if (adjustedValue >= 1) return 1.0;
    
    return adjustedValue;
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Custom App Bar with gradient background
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    MilitaryTheme.navy,
                    MilitaryTheme.deepBlue,
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                title: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.shield,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    Text(
                      'Military Buddy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                background: Stack(
                  children: [
                    // Abstract background patterns
                    Positioned(
                      right: -50,
                      top: -20,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -10,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.03),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          
          // Main content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo and welcome message with hero animation from splash
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      // Add a slide-in animation effect
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - _animationController.value)),
                        child: Opacity(
                          opacity: _animationController.value,
                          child: Row(
                            children: [
                              Hero(
                                tag: 'app_logo',
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: MilitaryTheme.navy.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'assets/images/Military Buddy Logo.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome${userService.username != null ? ', ${userService.username}' : ''}',
                                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: MilitaryTheme.navy,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Your journey to military success starts here',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Streak indicator with improved design
                  if (userService.streakDays > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade400,
                            Colors.deepOrange.shade600,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const Icon(
                                Icons.local_fire_department,
                                color: Colors.white,
                                size: 32,
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userService.streakDays} day streak!',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'You\'re on fire! Keep the momentum going',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 30),
                  
                  // Branch selector with staggered animation
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final delayedValue = _animationController.value < 0.3 
                          ? 0.0 
                          : (_animationController.value - 0.3) / 0.7;
                      
                      return Opacity(
                        opacity: delayedValue,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - delayedValue)),
                          child: BranchSelector(
                            onBranchSelected: _onBranchSelected,
                          ),
                        ),
                      );
                    }
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Featured card with animation
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final delayedValue = _animationController.value < 0.4 
                          ? 0.0 
                          : (_animationController.value - 0.4) / 0.6;
                      
                      return Opacity(
                        opacity: delayedValue,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - delayedValue)),
                          child: FeatureCard(
                            title: 'ASVAB Preparation',
                            subtitle: 'Practice tests and study materials to boost your score',
                            icon: Icons.quiz_outlined,
                            color: MilitaryTheme.red,
                            featured: true,
                            onTap: () {
                              Navigator.pushNamed(context, '/asvab');
                            },
                          ),
                        ),
                      );
                    }
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Section title
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 16),
                    child: Text(
                      'Explore Features',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MilitaryTheme.navy,
                      ),
                    ),
                  ),
                  
                  // Grid of feature cards with staggered animations
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final delayedValue = _animationController.value < 0.5 
                          ? 0.0 
                          : (_animationController.value - 0.5) / 0.5;
                      
                      return Opacity(
                        opacity: delayedValue,
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.6,
                          children: [
                            // Career Explorer with staggered delay
                            Transform.translate(
                              offset: Offset(0, 15 * (1 - _staggeredDelay(0, delayedValue))),
                              child: Opacity(
                                opacity: _staggeredDelay(0, delayedValue),
                                child: FeatureCard(
                                  title: 'Careers',
                                  subtitle: 'Explore military jobs',
                                  icon: Icons.work_outline,
                                  color: MilitaryTheme.navy,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/careers');
                                  },
                                ),
                              ),
                            ),
                            
                            // AI Tutor with staggered delay
                            Transform.translate(
                              offset: Offset(0, 15 * (1 - _staggeredDelay(1, delayedValue))),
                              child: Opacity(
                                opacity: _staggeredDelay(1, delayedValue),
                                child: FeatureCard(
                                  title: 'AI Tutor',
                                  subtitle: 'Get personalized help',
                                  icon: Icons.smart_toy_outlined,
                                  color: MilitaryTheme.steelBlue,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/tutor');
                                  },
                                ),
                              ),
                            ),
                            
                            // Recruiter Finder with staggered delay
                            Transform.translate(
                              offset: Offset(0, 15 * (1 - _staggeredDelay(2, delayedValue))),
                              child: Opacity(
                                opacity: _staggeredDelay(2, delayedValue),
                                child: FeatureCard(
                                  title: 'Recruiters',
                                  subtitle: 'Find local offices',
                                  icon: Icons.place_outlined,
                                  color: MilitaryTheme.gray,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/recruiters');
                                  },
                                ),
                              ),
                            ),
                            
                            // Pay Calculator with staggered delay
                            Transform.translate(
                              offset: Offset(0, 15 * (1 - _staggeredDelay(3, delayedValue))),
                              child: Opacity(
                                opacity: _staggeredDelay(3, delayedValue),
                                child: FeatureCard(
                                  title: 'Pay Calculator',
                                  subtitle: 'Estimate your salary',
                                  icon: Icons.attach_money,
                                  color: Colors.green.shade700,
                                  onTap: () {
                                    Navigator.pushNamed(context, '/pay');
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Help & Support card with animation
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final delayedValue = _animationController.value < 0.6 
                          ? 0.0 
                          : (_animationController.value - 0.6) / 0.4;
                      
                      return Opacity(
                        opacity: delayedValue,
                        child: Transform.translate(
                          offset: Offset(0, 15 * (1 - delayedValue)),
                          child: Card(
                            elevation: 0,
                            color: MilitaryTheme.lightGray,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InkWell(
                              onTap: () {
                                _showHelpDialog(context);
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.help_outline,
                                        color: MilitaryTheme.navy,
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Need Help?',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: MilitaryTheme.navy,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Check our guide and FAQ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey[400],
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: MilitaryTheme.navy,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
  
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MilitaryTheme.navy.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.help_outline,
                        color: MilitaryTheme.navy,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Help & Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MilitaryTheme.navy,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: Colors.grey[400],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Main content
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Military Buddy helps you explore military careers and prepare for service.',
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        SizedBox(height: 16),
                        HelpFeatureItem(
                          icon: Icons.work_outline,
                          title: 'Career Explorer',
                          description: 'Browse and search military jobs by branch',
                          color: MilitaryTheme.navy,
                        ),
                        HelpFeatureItem(
                          icon: Icons.quiz_outlined,
                          title: 'ASVAB Prep',
                          description: 'Study materials and practice tests for the entrance exam',
                          color: MilitaryTheme.red,
                        ),
                        HelpFeatureItem(
                          icon: Icons.smart_toy_outlined,
                          title: 'AI Tutor',
                          description: 'Get personalized help with military questions',
                          color: MilitaryTheme.steelBlue,
                        ),
                        HelpFeatureItem(
                          icon: Icons.place_outlined,
                          title: 'Recruiter Finder',
                          description: 'Locate recruiters and offices near you',
                          color: MilitaryTheme.gray,
                        ),
                        HelpFeatureItem(
                          icon: Icons.attach_money,
                          title: 'Pay Calculator',
                          description: 'Estimate military pay and benefits',
                          color: Colors.green,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'This app is for informational purposes only and is not affiliated with the U.S. Military.',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MilitaryTheme.navy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Got it',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Help feature item widget
class HelpFeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const HelpFeatureItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}