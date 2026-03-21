import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';
import '../services/ai_service.dart';

class DeckGeneratorScreen extends StatefulWidget {
  const DeckGeneratorScreen({super.key});

  @override
  State<DeckGeneratorScreen> createState() => _DeckGeneratorScreenState();
}

class _DeckGeneratorScreenState extends State<DeckGeneratorScreen> {
  final _startupController = TextEditingController();
  final _problemController = TextEditingController();
  final _marketController = TextEditingController();
  final _tractionController = TextEditingController();
  String _result = '';
  bool _loading = false;

  Future<void> _generate() async {
    if (_startupController.text.isEmpty || _problemController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in startup name and problem')));
      return;
    }
    setState(() { _loading = true; _result = ''; });
    final details = '''
Startup: ${_startupController.text}
Problem: ${_problemController.text}
Market: ${_marketController.text}
Traction: ${_tractionController.text}
''';
    final response = await AIService.generateDeck(details);
    setState(() { _result = response; _loading = false; });
    if (mounted) context.read<AppProvider>().addContent('deck', 'Deck - ${_startupController.text}', response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120e08),
      appBar: AppBar(
        title: Text('Deck Generator', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFf59e0b).withOpacity(0.1), borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFf59e0b).withOpacity(0.2)),
            ),
            child: Row(children: [
              Icon(Icons.dashboard_rounded, color: const Color(0xFFf59e0b)),
              const SizedBox(width: 12),
              Expanded(child: Text('Generate a complete investor-ready pitch deck outline with slide content.',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white70))),
            ]),
          ).animate().fadeIn().slideY(begin: 0.1),
          const SizedBox(height: 24),
          _label('Startup Name *'),
          const SizedBox(height: 8),
          TextField(controller: _startupController, style: GoogleFonts.inter(color: Colors.white),
            decoration: const InputDecoration(hintText: 'e.g., NovaPay')),
          const SizedBox(height: 20),
          _label('Problem You Solve *'),
          const SizedBox(height: 8),
          TextField(controller: _problemController, style: GoogleFonts.inter(color: Colors.white), maxLines: 3,
            decoration: const InputDecoration(hintText: 'What pain point does your startup address?')),
          const SizedBox(height: 20),
          _label('Target Market'),
          const SizedBox(height: 8),
          TextField(controller: _marketController, style: GoogleFonts.inter(color: Colors.white),
            decoration: const InputDecoration(hintText: 'e.g., SMBs in fintech, TAM \$50B')),
          const SizedBox(height: 20),
          _label('Traction / Metrics'),
          const SizedBox(height: 8),
          TextField(controller: _tractionController, style: GoogleFonts.inter(color: Colors.white), maxLines: 2,
            decoration: const InputDecoration(hintText: 'e.g., 10K users, \$50K MRR, 20% MoM growth')),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 56,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _generate,
              icon: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Icon(Icons.auto_awesome),
              label: Text(_loading ? 'Generating...' : 'Generate Pitch Deck'),
            ),
          ),
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _label('Pitch Deck Outline'),
              IconButton(onPressed: () => Share.share(_result), icon: const Icon(Icons.share_rounded, color: Color(0xFFf59e0b), size: 20)),
            ]),
            const SizedBox(height: 8),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF1e1810), borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFf59e0b).withOpacity(0.2))),
              child: SelectableText(_result, style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withOpacity(0.9), height: 1.6)),
            ).animate().fadeIn().slideY(begin: 0.05),
          ],
        ]),
      ),
    );
  }

  Widget _label(String t) => Text(t, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70));
}
