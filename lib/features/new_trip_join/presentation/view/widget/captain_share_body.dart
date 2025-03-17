import 'package:flutter/material.dart';

import '../../../../../res/assets/assets.dart';
import 'header_text_widget.dart';
import 'taps/tab_bar_content_widget.dart';
import 'taps/tab_bar_row_widget.dart';
import 'trip_option_widget.dart';

class CaptainShareBody extends StatelessWidget {
  const CaptainShareBody({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TripOptionWidget(
              borderColor: Colors.red,
              containerColor: Colors.white,
              iconColor: Color(0xffF33D49),
              textColor: Color(0xffF33D49),
              imagePath: Assets.locationTripIcon,
              title: 'Captain\nShare',
              onTap: () {},
            ),
            TripOptionWidget(
              imagePath: Assets.locationTripIcon,
              title: 'Pick me',
              onTap: () {},
            ),
            TripOptionWidget(
              imagePath: Assets.locationTripIcon,
              title: 'Trip Join',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        const HeaderTextWidget(),
        const SizedBox(height: 20),
        TabBarRowWidget(tabController: _tabController),
        Expanded(
          child: TabBarContentWidget(tabController: _tabController),
        ),
      ],
    );
  }
}
