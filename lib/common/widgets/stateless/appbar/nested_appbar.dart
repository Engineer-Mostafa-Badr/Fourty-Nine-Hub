import 'package:flutter/material.dart';

class NestedAppbar extends StatelessWidget {
  final Widget body;
  final List<Widget> appBars;
  final ScrollController scrollController;
  const NestedAppbar({
    super.key,
    required this.appBars,
    required this.scrollController,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return appBars;

        },
        body: body);
  }
}
