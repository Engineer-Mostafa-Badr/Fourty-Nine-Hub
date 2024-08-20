import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/webview.dart';
import 'package:fourtyninehub/res/style/const.dart';

import '../../../../res/strings/labels.dart';

class QuraanView extends StatelessWidget {
  const QuraanView({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewScaffold(label: Labels.quraan, url: UIConst.quraanWeb);
  }
}
