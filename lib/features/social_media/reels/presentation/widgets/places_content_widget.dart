import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'places_widget.dart';

class PlacesContentWidget extends StatelessWidget {
  const PlacesContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => Column(
              children: [
                SizedBox(height: 16.h),
                const PlacesWidget(),
              ],
            ),
            itemCount: 20,
          ),
        ],
      ),
    );
  }
}
