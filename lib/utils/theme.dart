import 'package:flutter/material.dart';

class MilitaryTheme {
  // Primary colors
  static const Color navy = Color(0xFF0A1E3C);
  static const Color gray = Color(0xFF6B7A8F);
  static const Color red = Color(0xFFC8102E);
  static const Color gold = Color(0xFFFFD700);
  static const Color steelBlue = Color(0xFF4682B4);
  
  // Secondary colors
  static const Color lightBlue = Color(0xFF5D8AA8);
  static const Color deepBlue = Color(0xFF051C38);
  static const Color offWhite = Color(0xFFF8F9FA);
  static const Color lightGray = Color(0xFFEEF2F5);

  // Branch colors
  static const Color army = Color(0xFF4B5320);
  static const Color navyBlue = Color(0xFF003B4F);
  static const Color marines = Color(0xFF8B0000);
  static const Color airForce = Color(0xFF00308F);
  static const Color coastGuard = Color(0xFFE35205);
  static const Color spaceForce = Color(0xFF1D2951);

  // Gradients
  static const LinearGradient navyGradient = LinearGradient(
    colors: [navy, Color(0xFF1A2E4C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient armyGradient = LinearGradient(
    colors: [army, Color(0xFF5B6330)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient marinesGradient = LinearGradient(
    colors: [marines, Color(0xFF9B1010)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient airForceGradient = LinearGradient(
    colors: [airForce, Color(0xFF10409F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coastGuardGradient = LinearGradient(
    colors: [coastGuard, Color(0xFFF36215)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient spaceForceGradient = LinearGradient(
    colors: [spaceForce, Color(0xFF2D3961)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text styles
  static TextStyle headingLarge = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: navy,
  );

  static TextStyle headingMedium = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: navy,
  );

  static TextStyle headingSmall = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: navy,
  );

  static TextStyle militaryText = const TextStyle(
    fontFamily: 'Roboto Condensed',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Card decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 12,
        spreadRadius: 1,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  static BoxDecoration featuredCardDecoration = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [navy, deepBlue],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: navy.withOpacity(0.3),
        blurRadius: 12,
        spreadRadius: 1,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Button styling
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: navy,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: navy,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: navy),
    ),
  );

  // Branch-specific button styles
  static ButtonStyle armyButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: army,
    foregroundColor: Colors.white,
  );

  static ButtonStyle navyButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: navyBlue,
    foregroundColor: Colors.white,
  );

  static ButtonStyle marinesButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: marines,
    foregroundColor: Colors.white,
  );

  static ButtonStyle airForceButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: airForce,
    foregroundColor: Colors.white,
  );

  static ButtonStyle coastGuardButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: coastGuard,
    foregroundColor: Colors.white,
  );

  static ButtonStyle spaceForceButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: spaceForce,
    foregroundColor: Colors.white,
  );
}