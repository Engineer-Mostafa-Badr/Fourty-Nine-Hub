import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/maps/map_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';

import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../widgets/customer/createOrder/options_bottom_sheet.dart';

class RideRequestView extends StatelessWidget {
  const RideRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: Column(
        children: [
          Expanded(
              child: MapPicker(
            lat: 30.9050401,
            lng: 31.031774,
          )),
          RideOptionsBottomSheet(),
        ],
      ),
    );
  }
}
