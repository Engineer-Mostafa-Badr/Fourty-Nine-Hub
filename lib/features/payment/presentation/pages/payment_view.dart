import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';

import '../../../../common/widgets/stateless/labels/label.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Payment',
      ),
      body: Center(
          child: Label(
        text: 'Pending',
      )),
    );
  }
}
