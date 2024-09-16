import 'package:flutter/material.dart';

import '../../res/style/styles.dart';

class CustomError extends StatelessWidget {
  const CustomError({super.key, required this.errMessage});
  final String errMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errMessage,
        textAlign: TextAlign.center,
        style: Styles.mediumText(),
      ),
    );
  }
}
