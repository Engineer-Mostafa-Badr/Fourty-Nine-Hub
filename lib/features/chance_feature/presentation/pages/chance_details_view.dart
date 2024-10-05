import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';


class ChanceDetailsView extends StatelessWidget {
  const ChanceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: "details",
      ),

    );
  }
}
