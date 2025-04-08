import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

import '../../../../../core/widget/custom_scaffold.dart';

class PolicyView extends StatefulWidget {
  const PolicyView({super.key, this.fromTerms});
  final bool? fromTerms;

  @override
  _PolicyViewState createState() => _PolicyViewState();
}

class _PolicyViewState extends State<PolicyView> {
  bool _isLoading = true;
  String? _filePath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadDocument();
  }

  Future<void> loadDocument() async {
    try {
      // Load the PDF file from assets based on the current locale
      final pdfAssetPath = context.locale.languageCode == 'en'
          ? 'assets/pdf/who_we_are_en.pdf'
          : 'assets/pdf/who_we_are_ar.pdf';

      // Get the path to the app's documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/policy.pdf';

      // Write the PDF asset to a file in the app's documents directory
      final pdfData = await rootBundle.load(pdfAssetPath);
      final file = File(filePath);
      await file.writeAsBytes(pdfData.buffer.asUint8List());

      setState(() {
        _filePath = filePath;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading the document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: widget.fromTerms==true?LocaleKeys.conditions.localize:LocaleKeys.policies.localize,
        ),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _filePath != null
                ? PDFView(
                    filePath: _filePath!,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: false,
                    pageFling: false,
                    onError: (error) {
                      print(error.toString());
                    },
                    onPageError: (page, error) {
                      print('$page: ${error.toString()}');
                    },
                  )
                : const Text('Failed to load the PDF.'),
      ),
    );
  }
}
