import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'users_widget.dart';

class UsersContentWidget extends StatelessWidget {
  const UsersContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => Column(
              children: [
                SizedBox(height: 16.h),
                const UsersWidget(),
              ],
            ),
            itemCount: 20,
          ),
        ],
      ),
    );
  }
}
