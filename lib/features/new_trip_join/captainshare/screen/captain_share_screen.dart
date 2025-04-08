import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../core/utils/handle_cashback.dart';
import '../../presentation/view/widget/captain_share_body.dart';
import '../../presentation/view/widget/route_button_widget.dart';

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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      key: _scaffoldKey,
      floatingActionButton: const RouteButtonWidget(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: HomeAppbar(
          isWithBackArrow: false,
          language: true,
          leading: IconButton(
            icon: const Icon(Icons.menu), // The menu icon
            onPressed: () {
              HandleCashback.setCount('drawerCount', context);
              _scaffoldKey.currentState?.openDrawer(); // Open the drawer
            },
          ),
        ),
      ),
      body: CaptainShareBody(tabController: _tabController),
    );
  }
}
