import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dart:io' show Platform;
import 'screens/home_screen.dart';
import 'screens/career_explorer_screen.dart';
import 'screens/asvab_prep_screen.dart';
import 'screens/ai_tutor_screen.dart';
import 'screens/recruiter_finder_screen.dart';
import 'screens/pay_calculator_screen.dart';
import 'screens/profile_screen.dart';
import 'utils/theme.dart';

class MilitaryBuddyApp extends StatefulWidget {
  const MilitaryBuddyApp({Key? key}) : super(key: key);

  @override
  State<MilitaryBuddyApp> createState() => _MilitaryBuddyAppState();
}

class _MilitaryBuddyAppState extends State<MilitaryBuddyApp> with TickerProviderStateMixin {
  late AnimationController _splashController;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _splashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _splashController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _showSplash = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _splashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use platform-specific app container
    return Platform.isIOS 
        ? _buildCupertinoApp(context)
        : _buildMaterialApp(context);
  }
  
  Widget _buildMaterialApp(BuildContext context) {
    return MaterialApp(
      title: 'Military Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: MilitaryTheme.navy,
        scaffoldBackgroundColor: MilitaryTheme.offWhite,
        colorScheme: ColorScheme.fromSeed(
          seedColor: MilitaryTheme.navy,
          primary: MilitaryTheme.navy,
          secondary: MilitaryTheme.red,
          tertiary: MilitaryTheme.steelBlue,
          background: MilitaryTheme.offWhite,
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.copyWith(
                headlineLarge: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: MilitaryTheme.navy,
                ),
                headlineMedium: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: MilitaryTheme.navy,
                ),
                headlineSmall: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: MilitaryTheme.navy,
                ),
                bodyLarge: GoogleFonts.inter(),
                bodyMedium: GoogleFonts.inter(),
                bodySmall: GoogleFonts.inter(),
              ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: MilitaryTheme.navy,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: MilitaryTheme.navy,
          unselectedItemColor: MilitaryTheme.gray,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
        cardTheme: CardTheme(
          elevation: MilitaryTheme.cardElevation,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: MilitaryTheme.navy,
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MilitaryTheme.borderRadius),
            ),
            elevation: 2,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: MilitaryTheme.navy,
            side: const BorderSide(color: MilitaryTheme.navy, width: 1.5),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MilitaryTheme.borderRadius),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: MilitaryTheme.gray.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: MilitaryTheme.gray.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: MilitaryTheme.navy, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      home: _showSplash ? _buildSplashScreen() : const HomeScreen(),
      routes: {
        '/careers': (context) => const CareerExplorerScreen(),
        '/asvab': (context) => const ASVABPrepScreen(),
        '/tutor': (context) => const AITutorScreen(),
        '/recruiters': (context) => const RecruiterFinderScreen(),
        '/pay': (context) => const PayCalculatorScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
  
  // iOS-specific app implementation
  Widget _buildCupertinoApp(BuildContext context) {
    return CupertinoApp(
      title: 'Military Buddy',
      debugShowCheckedModeBanner: false,
      theme: MilitaryTheme.getCupertinoTheme(),
      home: _showSplash 
        ? _buildSplashScreen() 
        : _buildCupertinoHome(),
    );
  }
  
  // iOS-specific home container with tab navigation
  Widget _buildCupertinoHome() {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: MilitaryTheme.navy,
        inactiveColor: MilitaryTheme.gray,
        backgroundColor: Colors.white,
        border: Border(
          top: BorderSide(
            color: MilitaryTheme.gray.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.briefcase),
            label: 'Careers',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: 'ASVAB',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_text),
            label: 'Tutor',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) => const HomeScreen());
          case 1:
            return CupertinoTabView(builder: (context) => const CareerExplorerScreen());
          case 2:
            return CupertinoTabView(builder: (context) => const ASVABPrepScreen());
          case 3:
            return CupertinoTabView(builder: (context) => const AITutorScreen());
          case 4:
            return CupertinoTabView(builder: (context) => const ProfileScreen());
          default:
            return CupertinoTabView(builder: (context) => const HomeScreen());
        }
      },
    );
  }
  }
  
  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: MilitaryTheme.navy,
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: GridPattern(
                lineColor: Colors.white,
                lineWidth: 1,
                spacing: 20,
              ),
            ),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lottie animation and Logo
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Lottie animation behind the logo
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Lottie.asset(
                        'assets/animations/military_shield.json',
                        controller: _splashController,
                        onLoaded: (composition) {
                          _splashController.duration = composition.duration;
                        },
                      ),
                    ),
                    
                    // Logo with hero animation
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: Hero(
                          tag: 'app_logo',
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Image.asset('assets/images/Military Buddy Logo.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Animated text
                AnimatedBuilder(
                  animation: _splashController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _splashController.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 - (20 * _splashController.value)),
                        child: Text(
                          'MILITARY BUDDY',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                AnimatedBuilder(
                  animation: _splashController,
                  builder: (context, child) {
                    // Delayed appearance for the subtitle
                    final delayedValue = _splashController.value < 0.3 
                        ? 0.0 
                        : (_splashController.value - 0.3) / 0.7;
                    
                    return Opacity(
                      opacity: delayedValue,
                      child: Text(
                        'Your Military Career Guide',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 60),
                
                // Military branch icons with subtle animation
                AnimatedBuilder(
                  animation: _splashController,
                  builder: (context, child) {
                    final delayedValue = _splashController.value < 0.5 
                        ? 0.0 
                        : (_splashController.value - 0.5) / 0.5;
                        
                    return Opacity(
                      opacity: delayedValue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < 6; i++)
                            _buildBranchDot(i, delayedValue),
                        ],
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                
                // Loading indicator
                AnimatedBuilder(
                  animation: _splashController,
                  builder: (context, child) {
                    // Ensure opacity is between 0.0 and 1.0
                    final fadeValue = (_splashController.value >= 0.8) 
                        ? (1.0 - ((_splashController.value - 0.8) / 0.2)).clamp(0.0, 1.0)
                        : 1.0;
                    return Opacity(
                      opacity: fadeValue,
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBranchDot(int index, double baseAnimation) {
    // Create a staggered animation effect
    final delay = 0.1 * index;
    final staggeredAnimation = baseAnimation - delay < 0 
        ? 0.0 
        : (baseAnimation - delay).clamp(0.0, 1.0);
    
    final branchColors = [
      MilitaryTheme.army,
      MilitaryTheme.navyBlue,
      MilitaryTheme.marines,
      MilitaryTheme.airForce,
      MilitaryTheme.spaceForce,
      MilitaryTheme.coastGuard,
    ];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Transform.scale(
        scale: 0.7 + (0.3 * staggeredAnimation),
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: branchColors[index],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: branchColors[index].withOpacity(0.6),
                blurRadius: 6,
                spreadRadius: 2 * staggeredAnimation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Grid pattern background
class GridPattern extends StatelessWidget {
  final Color lineColor;
  final double lineWidth;
  final double spacing;

  const GridPattern({
    Key? key,
    required this.lineColor,
    required this.lineWidth,
    required this.spacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridPainter(
        lineColor: lineColor,
        lineWidth: lineWidth,
        spacing: spacing,
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Color lineColor;
  final double lineWidth;
  final double spacing;

  GridPainter({
    required this.lineColor,
    required this.lineWidth,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth;

    // Draw vertical lines
    for (double i = 0; i <= size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Draw horizontal lines
    for (double i = 0; i <= size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  
  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.spacing != spacing;
  }
}