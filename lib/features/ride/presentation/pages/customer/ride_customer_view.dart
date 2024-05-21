import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../widgets/customer/createOrder/map_picker.dart';
import '../../widgets/customer/createOrder/options_bottom_sheet.dart';

class RideCustomerView extends StatelessWidget {
  const RideCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: MapPicker()),
          RideOptionsBottomSheet(),
        ],
      ),
    );
  }
}
