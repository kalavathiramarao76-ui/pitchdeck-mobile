import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';
import '../services/ai_service.dart';

class PitchScriptsScreen extends StatefulWidget {
  const PitchScriptsScreen({super.key});

  @override
  State<PitchScriptsScreen> createState() => _PitchScriptsScreenState();
}

class _PitchScriptsScreenState extends State<PitchScriptsScreen> {
  final _startupController = TextEditingController();
  final _audienceController = TextEditingController();
  final _durationController = TextEditingController();
  String _selectedFormat = '5-minute pitch';
  String _result = '';
  bool _loading = false;

  final List<String> _formats = ['Elevator pitch (60s)', '5-minute pitch', '10-minute pitch', 'Demo day pitch', 'Investor meeting'];

  Future<void> _generate() async {
    if (_startupController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please describe your startup')));
      return;
    }
    setState(() { _loading = true; _result = ''; });
    final details = '''
Startup: ${_startupController.text}
Format: $_selectedFormat
Audience: ${_audienceController.text.isNotEmpty ? _audienceController.text : 'VCs and angel investors'}
Duration: ${_durationController.text.isNotEmpty ? _durationController.text : _selectedFormat}
''';
    final response = await AIService.generatePitchScript(details);
    setState(() { _result = response; _loading = false; });
    if (mounted) context.read<AppProvider>().addContent('script', 'Script - $_selectedFormat', response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120e08),
      appBar: AppBar(
        title: Text('Pitch Scripts', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
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
              Icon(Icons.mic_rounded, color: const Color(0xFFf59e0b)),
              const SizedBox(width: 12),
              Expanded(child: Text('Get pitch scripts with timing, talking points, and emotional beats.',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white70))),
            ]),
          ).animate().fadeIn().slideY(begin: 0.1),
          const SizedBox(height: 24),
          _label('Pitch Format'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _formats.map((f) => ChoiceChip(
              label: Text(f, style: TextStyle(fontSize: 13)),
              selected: _selectedFormat == f,
              onSelected: (sel) => setState(() => _selectedFormat = f),
              selectedColor: const Color(0xFFf59e0b),
              labelStyle: TextStyle(color: _selectedFormat == f ? Colors.black : Colors.white70, fontWeight: FontWeight.w600),
              backgroundColor: const Color(0xFF1e1810),
              side: BorderSide(color: const Color(0xFFf59e0b).withOpacity(0.2)),
            )).toList(),
          ),
          const SizedBox(height: 20),
          _label('Your Startup *'),
          const SizedBox(height: 8),
          TextField(controller: _startupController, style: GoogleFonts.inter(color: Colors.white), maxLines: 3,
            decoration: const InputDecoration(hintText: 'Describe your startup, problem, solution, traction...')),
          const SizedBox(height: 20),
          _label('Target Audience'),
          const SizedBox(height: 8),
          TextField(controller: _audienceController, style: GoogleFonts.inter(color: Colors.white),
            decoration: const InputDecoration(hintText: 'e.g., Series A VCs, angel investors, demo day judges')),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 56,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _generate,
              icon: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Icon(Icons.auto_awesome),
              label: Text(_loading ? 'Writing...' : 'Generate Script'),
            ),
          ),
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _label('Pitch Script'),
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
