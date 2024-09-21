import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

class PolicyView extends StatefulWidget {
  @override
  _PolicyViewState createState() => _PolicyViewState();
}

class _PolicyViewState extends State<PolicyView> {
  bool _isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    // Do not call loadDocument() here because it depends on context.
  }

  // Moved loadDocument logic to didChangeDependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadDocument();
  }

  Future<void> loadDocument() async {
    // Avoid loading the document multiple times
    if (!_isLoading) return;

    document = context.locale.languageCode == 'en'
        ? await PDFDocument.fromAsset('assets/pdf/who_we_are_en.pdf')
        : await PDFDocument.fromAsset('assets/pdf/who_we_are_ar.pdf');

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> changePDF(int value) async {
    setState(() {
      _isLoading = true;
    });

    document = context.locale.languageCode == 'en'
        ? await PDFDocument.fromAsset('assets/pdf/who_we_are_en.pdf')
        : await PDFDocument.fromAsset('assets/pdf/who_we_are_ar.pdf');

    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context); // Close the drawer after changing the document
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.policies.localize, // Use tr() for translation
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : PDFViewer(
          document: document,
          zoomSteps: 2,
          showNavigation: false, // Hide bottom navigation
          showPicker: false, // Hide page picker
          lazyLoad: false, // Set this to true if you want to load pages lazily
          scrollDirection: Axis.vertical, // Vertical scrolling
        ),
      ),
    );
  }
}
