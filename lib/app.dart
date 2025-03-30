import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/career_explorer_screen.dart';
import 'screens/asvab_prep_screen.dart';
import 'screens/ai_tutor_screen.dart';
import 'screens/recruiter_finder_screen.dart';
import 'screens/pay_calculator_screen.dart';
import 'screens/profile_screen.dart';
import 'utils/theme.dart';

class MilitaryBuddyApp extends StatelessWidget {
  const MilitaryBuddyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          elevation: 3,
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
              borderRadius: BorderRadius.circular(10),
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
              borderRadius: BorderRadius.circular(10),
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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/careers': (context) => const CareerExplorerScreen(),
        '/asvab': (context) => const ASVABPrepScreen(),
        '/tutor': (context) => const AITutorScreen(),
        '/recruiters': (context) => const RecruiterFinderScreen(),
        '/pay': (context) => const PayCalculatorScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}