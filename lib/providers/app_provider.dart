import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  bool _onboardingComplete = false;
  bool _isLoading = false;
  String _generatedContent = '';
  List<Map<String, String>> _savedContent = [];
  String _startupName = '';
  String _founderName = '';

  bool get onboardingComplete => _onboardingComplete;
  bool get isLoading => _isLoading;
  String get generatedContent => _generatedContent;
  List<Map<String, String>> get savedContent => _savedContent;
  String get startupName => _startupName;
  String get founderName => _founderName;

  AppProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    _startupName = prefs.getString('startup_name') ?? '';
    _founderName = prefs.getString('founder_name') ?? '';
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    _onboardingComplete = true;
    notifyListeners();
  }

  Future<void> updateProfile(String startup, String founder) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('startup_name', startup);
    await prefs.setString('founder_name', founder);
    _startupName = startup;
    _founderName = founder;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void addContent(String type, String title, String content) {
    _savedContent.insert(0, {
      'type': type,
      'title': title,
      'content': content,
      'date': DateTime.now().toIso8601String(),
    });
    notifyListeners();
  }
}
