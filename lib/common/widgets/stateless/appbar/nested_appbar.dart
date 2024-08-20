import 'package:flutter/material.dart';

class NestedAppbar extends StatelessWidget {
  final Widget body;
  final List<Widget> appBars;

  const NestedAppbar({
    super.key,
    required this.appBars,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return appBars;
        },
        body: body);
  }
}
