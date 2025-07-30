import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';

import '../core/widget/custom_circular_progress_indicator.dart';

class MarkdownViewer extends StatelessWidget {
  final String markdownFilePath;
  const MarkdownViewer({super.key, required this.markdownFilePath});

  Future<String> _loadMarkdown() async {
    return await rootBundle.loadString(markdownFilePath);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadMarkdown(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Markdown(data: snapshot.data ?? '');
        } else {
          return const Center(child: CustomCircularProgressIndicator());
        }
      },
    );
  }
}
