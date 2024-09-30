import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class AllPickMeFloatingActionButton extends StatelessWidget {
  const AllPickMeFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.directional(
      bottom: 10,
      end: 10,
      textDirection: context.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: FloatingActionButton(
        onPressed: () {
          // context.push(Routes.TRIP_JOIN);
        },
        backgroundColor: AppColors.PRIMARY_COLOR,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
