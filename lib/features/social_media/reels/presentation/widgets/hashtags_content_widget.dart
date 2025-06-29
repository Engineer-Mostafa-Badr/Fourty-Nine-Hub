import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'hashtags_widget.dart';

class HashtagsContentWidget extends StatelessWidget {
  const HashtagsContentWidget({super.key});

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
                SizedBox(height: 8),
                const HashtagsWidget(),
              ],
            ),
            itemCount: 20,
          ),
        ],
      ),
    );
  }
}
