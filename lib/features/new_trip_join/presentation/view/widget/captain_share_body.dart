import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_cubit/captain_share_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
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
    return BlocProvider(
        create: (context)=>serviceLocator<CaptainShareCubit>()..loadInitialAvailableData(context),
        child: TabBarContentWidget(tabController: widget._tabController));
  }
}
