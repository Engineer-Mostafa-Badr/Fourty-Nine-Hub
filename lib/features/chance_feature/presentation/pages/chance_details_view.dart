import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../widgets/card_details_widget_of_details_view.dart';
import '../widgets/subscribe_button_widget.dart';

class ChanceDetailsView extends StatelessWidget {
  const ChanceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CardDetails(),
            SizedBox(height: 20.h),
            Text(
                'Subscribe',
                style: Styles.mediumText(
                    color: Theme.of(context).primaryColor,
                    fontSize: 70.sp,
                    fontWeight: FontWeight.bold
                )),
            SizedBox(height: 10.h),
            Text(
                'Type the value you want to participation',
                style: Styles.mediumText(
                    color: Theme.of(context).primaryColor,
                    fontSize: 50.sp,

                )),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding:  EdgeInsets.symmetric(
                        horizontal: 15.w, vertical: 20.h,
                      ),
                      backgroundColor: AppColors.PRIMARY_COLOR,
                    ),
                    child: Icon(
                      Icons.remove,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    )),
                const Spacer(),
                Container(
                  width: context.screenWidth / 1.7,
                  height: 70.h,
                  padding:
                  EdgeInsets.only(top: 3.h, bottom: 3.h, left: 2.w, right: 25.w),
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {},
                      ),
                      const Spacer(),
                      Text('0',
                          style: Styles.mediumText(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontSize: 80.sp,
                          )),
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding:  EdgeInsets.symmetric(
                        horizontal: 15.w, vertical: 20.h,
                      ),
                      backgroundColor: AppColors.PRIMARY_COLOR,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ))
              ],
            ),
            const Spacer(),
            const SubscribeButtonWidget(),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }
}

