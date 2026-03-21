import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';
import '../services/ai_service.dart';

class InvestorEmailScreen extends StatefulWidget {
  const InvestorEmailScreen({super.key});

  @override
  State<InvestorEmailScreen> createState() => _InvestorEmailScreenState();
}

class _InvestorEmailScreenState extends State<InvestorEmailScreen> {
  final _startupController = TextEditingController();
  final _investorController = TextEditingController();
  final _tractionController = TextEditingController();
  final _askController = TextEditingController();
  String _result = '';
  bool _loading = false;

  Future<void> _generate() async {
    if (_startupController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please describe your startup')));
      return;
    }
    setState(() { _loading = true; _result = ''; });
    final details = '''
Startup: ${_startupController.text}
Investor/Fund: ${_investorController.text}
Traction: ${_tractionController.text}
Ask: ${_askController.text.isNotEmpty ? _askController.text : 'Seed round meeting request'}
''';
    final response = await AIService.generateInvestorEmail(details);
    setState(() { _result = response; _loading = false; });
    if (mounted) context.read<AppProvider>().addContent('email', 'Email - ${_investorController.text}', response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120e08),
      appBar: AppBar(
        title: Text('Investor Email', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
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
              Icon(Icons.email_rounded, color: const Color(0xFFf59e0b)),
              const SizedBox(width: 12),
              Expanded(child: Text('Craft compelling investor outreach emails that get meetings.',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white70))),
            ]),
          ).animate().fadeIn().slideY(begin: 0.1),
          const SizedBox(height: 24),
          _label('Your Startup *'),
          const SizedBox(height: 8),
          TextField(controller: _startupController, style: GoogleFonts.inter(color: Colors.white), maxLines: 2,
            decoration: const InputDecoration(hintText: 'Name, what you do, and your unique value prop')),
          const SizedBox(height: 20),
          _label('Target Investor / Fund'),
          const SizedBox(height: 8),
          TextField(controller: _investorController, style: GoogleFonts.inter(color: Colors.white),
            decoration: const InputDecoration(hintText: 'e.g., Sarah at Sequoia Capital')),
          const SizedBox(height: 20),
          _label('Key Traction'),
          const SizedBox(height: 8),
          TextField(controller: _tractionController, style: GoogleFonts.inter(color: Colors.white), maxLines: 2,
            decoration: const InputDecoration(hintText: 'e.g., \$50K MRR, 10K users, 3x growth')),
          const SizedBox(height: 20),
          _label('Your Ask'),
          const SizedBox(height: 8),
          TextField(controller: _askController, style: GoogleFonts.inter(color: Colors.white),
            decoration: const InputDecoration(hintText: 'e.g., Raising \$2M seed, requesting 30-min call')),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 56,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _generate,
              icon: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Icon(Icons.auto_awesome),
              label: Text(_loading ? 'Crafting...' : 'Generate Email'),
            ),
          ),
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _label('Investor Email'),
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
