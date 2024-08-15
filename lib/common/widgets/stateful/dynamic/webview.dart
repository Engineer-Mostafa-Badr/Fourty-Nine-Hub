import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScaffold extends StatefulWidget {
  final String url;
  final String label;
  const WebViewScaffold({super.key, required this.label, required this.url});

  @override
  State<WebViewScaffold> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewScaffold> {
  late WebViewController controller;
  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackAppBar(label: widget.label),
        body: WebViewWidget(controller: controller));
  }
}
