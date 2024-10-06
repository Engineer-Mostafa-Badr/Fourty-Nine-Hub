import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import '../widgets/chance_details_body.dart';

class ChanceDetailsView extends StatelessWidget {
  const ChanceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BackAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ChanceDetailsBody(),
      ),
    );
  }
}

