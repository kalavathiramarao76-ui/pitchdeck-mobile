import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';
import '../services/ai_service.dart';

class SlideWriterScreen extends StatefulWidget {
  const SlideWriterScreen({super.key});

  @override
  State<SlideWriterScreen> createState() => _SlideWriterScreenState();
}

class _SlideWriterScreenState extends State<SlideWriterScreen> {
  final _topicController = TextEditingController();
  final _contextController = TextEditingController();
  String _selectedType = 'Problem';
  String _result = '';
  bool _loading = false;

  final List<String> _slideTypes = [
    'Problem', 'Solution', 'Market Size', 'Business Model', 'Traction',
    'Team', 'Competition', 'Financials', 'The Ask', 'Vision',
  ];

  Future<void> _generate() async {
    if (_topicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please describe the slide topic')));
      return;
    }
    setState(() { _loading = true; _result = ''; });
    final details = '''
Slide Type: $_selectedType
Topic: ${_topicController.text}
Context: ${_contextController.text}
''';
    final response = await AIService.generateSlide(details);
    setState(() { _result = response; _loading = false; });
    if (mounted) context.read<AppProvider>().addContent('slide', 'Slide - $_selectedType', response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120e08),
      appBar: AppBar(
        title: Text('Slide Writer', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
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
              Icon(Icons.slideshow_rounded, color: const Color(0xFFf59e0b)),
              const SizedBox(width: 12),
              Expanded(child: Text('Generate compelling content for individual pitch deck slides.',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white70))),
            ]),
          ).animate().fadeIn().slideY(begin: 0.1),
          const SizedBox(height: 24),
          _label('Slide Type'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _slideTypes.map((type) => ChoiceChip(
              label: Text(type),
              selected: _selectedType == type,
              onSelected: (sel) => setState(() => _selectedType = type),
              selectedColor: const Color(0xFFf59e0b),
              labelStyle: TextStyle(
                color: _selectedType == type ? Colors.black : Colors.white70,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: const Color(0xFF1e1810),
              side: BorderSide(color: const Color(0xFFf59e0b).withOpacity(0.2)),
            )).toList(),
          ),
          const SizedBox(height: 20),
          _label('Slide Topic / Content *'),
          const SizedBox(height: 8),
          TextField(controller: _topicController, style: GoogleFonts.inter(color: Colors.white), maxLines: 3,
            decoration: const InputDecoration(hintText: 'What should this slide communicate?')),
          const SizedBox(height: 20),
          _label('Additional Context'),
          const SizedBox(height: 8),
          TextField(controller: _contextController, style: GoogleFonts.inter(color: Colors.white), maxLines: 2,
            decoration: const InputDecoration(hintText: 'Data points, specifics, audience...')),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 56,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _generate,
              icon: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Icon(Icons.auto_awesome),
              label: Text(_loading ? 'Writing...' : 'Generate Slide'),
            ),
          ),
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _label('Slide Content'),
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
