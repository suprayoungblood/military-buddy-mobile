import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService with ChangeNotifier {
  String? _userId;
  String? _username;
  String? _email;
  int _streakDays = 0;
  Map<String, int> _achievements = {};
  
  // Getters
  String? get userId => _userId;
  String? get username => _username;
  String? get email => _email;
  int get streakDays => _streakDays;
  Map<String, int> get achievements => _achievements;
  
  // Initialize user data
  Future<void> initialize() async {
    await loadUserData();
  }
  
  // Load user data from local storage (mock for now)
  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _userId = prefs.getString('userId');
      _username = prefs.getString('username');
      _email = prefs.getString('email');
      _streakDays = prefs.getInt('streakDays') ?? 0;
      
      // Mock achievements data for now
      _achievements = {
        'asvab_questions': prefs.getInt('achievement_asvab_questions') ?? 0,
        'careers_viewed': prefs.getInt('achievement_careers_viewed') ?? 0,
        'tutor_sessions': prefs.getInt('achievement_tutor_sessions') ?? 0,
      };
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
    }
  }
  
  // Save user data to local storage
  Future<void> saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_userId != null) prefs.setString('userId', _userId!);
      if (_username != null) prefs.setString('username', _username!);
      if (_email != null) prefs.setString('email', _email!);
      prefs.setInt('streakDays', _streakDays);
      
      // Save achievements
      _achievements.forEach((key, value) {
        prefs.setInt('achievement_$key', value);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user data: $e');
      }
    }
  }
  
  // Update user profile
  Future<void> updateProfile({String? username, String? email}) async {
    if (username != null) _username = username;
    if (email != null) _email = email;
    
    await saveUserData();
    notifyListeners();
  }
  
  // Update streak
  Future<void> updateStreak() async {
    _streakDays++;
    await saveUserData();
    notifyListeners();
  }
  
  // Update achievement
  Future<void> updateAchievement(String achievementKey, int value) async {
    _achievements[achievementKey] = value;
    await saveUserData();
    notifyListeners();
  }
  
  // Mock sign in (to be replaced with AWS Cognito)
  Future<bool> signIn(String email, String password) async {
    try {
      // Mock successful sign-in
      _userId = 'user-${DateTime.now().millisecondsSinceEpoch}';
      _username = email.split('@').first;
      _email = email;
      
      await saveUserData();
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in: $e');
      }
      return false;
    }
  }
  
  // Mock sign out
  Future<void> signOut() async {
    try {
      _userId = null;
      _username = null;
      _email = null;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      await prefs.remove('username');
      await prefs.remove('email');
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
    }
  }
}