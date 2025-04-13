import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/widget/custom_scaffold.dart';
import '../banners/back_appbar.dart';

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
  void didChangeDependencies() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(context.theme.scaffoldBackgroundColor)
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
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: BackAppBar(label: widget.label),
        ),
        body: WebViewWidget(controller: controller));
  }
}
