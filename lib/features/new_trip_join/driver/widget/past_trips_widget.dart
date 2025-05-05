import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/routes.dart';
import 'available_ride_mode_widget.dart';

class PastTripsWidget extends StatelessWidget {
  final List<String> content;
  const PastTripsWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return content.isEmpty
        ? _emptyMessage()
        : SingleChildScrollView(
            child: Column(
              children: [
                AvailableRideModeWidget(
                  onTap: () {
                    context.push(Routes.captainRideDetails);
                  },
                  cancelButton: false,
                  statusDriver: context.isArabic?'منتهي':"Expired",
                  requestType: context.isArabic?'عادي':'Regular',
                ),
                AvailableRideModeWidget(
                  onTap: () {},
                  statusDriver: context.isArabic?'منتهي':"Expired",
                  requestType: context.isArabic?'عادي':'Regular',
                ),
              ],
            ),
          );
  }
}

Widget _emptyMessage() {
  return Center(
    child: Text(
      LocaleKeys.thereIsNoTripsInThisList.localize,
      style: const TextStyle(fontSize: 16, color: Colors.grey),
    ),
  );
}
