import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  String _termsText = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTerms();
  }

  Future<void> _loadTerms() async {
    final terms = await rootBundle.loadString('assets/terms_and_conditions.txt');
    setState(() {
      _termsText = terms;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Markdown(
                data: _termsText,
                styleSheet: MarkdownStyleSheet(
                  h1: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  h3: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  p: const TextStyle(fontSize: 16, height: 1.5),
                  listBullet: const TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}