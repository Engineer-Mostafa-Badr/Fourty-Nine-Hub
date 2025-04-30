import 'package:flutter/material.dart';
import '../../../captainshare/widget/tab_bar_content_widget.dart';


class CaptainShareBody extends StatefulWidget {
  const CaptainShareBody({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  _CaptainShareBodyState createState() => _CaptainShareBodyState();
}

class _CaptainShareBodyState extends State<CaptainShareBody> {

  @override
  Widget build(BuildContext context) {
    return TabBarContentWidget(tabController: widget._tabController);
  }
}
