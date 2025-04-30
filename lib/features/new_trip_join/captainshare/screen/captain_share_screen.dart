import 'package:flutter/material.dart';
import '../../presentation/view/widget/captain_share_body.dart';

class CaptainShareScreen extends StatefulWidget {
  const CaptainShareScreen({super.key});

  @override
  State<CaptainShareScreen> createState() => _CaptainShareScreenState();
}

class _CaptainShareScreenState extends State<CaptainShareScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return CaptainShareBody(tabController:_tabController ,);
  }
}
