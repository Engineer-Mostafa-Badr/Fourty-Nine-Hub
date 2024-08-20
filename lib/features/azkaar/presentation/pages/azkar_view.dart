import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/webview.dart';
import 'package:fourtyninehub/res/style/const.dart';

import '../../../../res/strings/labels.dart';

class AzkarView extends StatelessWidget {
  const AzkarView({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewScaffold(label: Labels.azkar, url: UIConst.azkar);
  }
}
