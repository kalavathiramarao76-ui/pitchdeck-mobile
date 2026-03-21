import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final provider = context.read<AppProvider>();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => provider.onboardingComplete ? const HomeScreen() : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120e08),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFf59e0b), Color(0xFFd97706)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: const Color(0xFFf59e0b).withOpacity(0.4), blurRadius: 40, spreadRadius: 5),
                ],
              ),
              child: const Icon(Icons.rocket_launch_rounded, size: 60, color: Colors.white),
            ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
            const SizedBox(height: 32),
            Text('PitchDeck',
              style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1),
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.3),
            const SizedBox(height: 8),
            Text('AI Pitch Toolkit',
              style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFFf59e0b).withOpacity(0.8), fontWeight: FontWeight.w500),
            ).animate().fadeIn(delay: 700.ms, duration: 600.ms),
            const SizedBox(height: 48),
            SizedBox(width: 32, height: 32,
              child: CircularProgressIndicator(strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFf59e0b).withOpacity(0.6))),
            ).animate().fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}
