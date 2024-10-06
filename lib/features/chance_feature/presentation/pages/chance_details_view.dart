import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../widgets/card_details_widget_of_details_view.dart';

class ChanceDetailsView extends StatelessWidget {
  const ChanceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardDetails(),
              Text(
                'participation  with wallet balance (pounds)',
                textAlign: TextAlign.center,
                style: Styles.mediumText(),
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding:  EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 25.h,
                        ),
                        backgroundColor: AppColors.PRIMARY_COLOR,
                      ),
                      child: Icon(
                        Icons.remove,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      )),
                  const Spacer(),
                  Container(
                    width: context.screenWidth / 2,
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
                              fontSize: 100.sp,
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
                          horizontal: 20.w, vertical: 25.h,
                        ),
                        backgroundColor: AppColors.PRIMARY_COLOR,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ))
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 25.h),
                      backgroundColor: AppColors.SECONDARY_COLOR,
                    ),
                    child: Text('Subscribe to the product',
                        style: Styles.mediumText(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontSize: 50.sp)),
                  ),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding:  EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 25.h),
                        backgroundColor: AppColors.SECONDARY_COLOR,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

