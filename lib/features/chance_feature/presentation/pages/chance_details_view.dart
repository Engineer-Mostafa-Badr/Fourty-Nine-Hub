import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../widgets/time_card.dart';

class ChanceDetailsView extends StatelessWidget {
   ChanceDetailsView({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: const BackAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Honor 90 Lite Dual Sided",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Container(
                height: 200.h,
                width: 200.w,
                decoration:  const BoxDecoration(
                  boxShadow:  AppColors.SHADOW_LIGHT,
                  color: Colors.white,
                ),
                child: Image.asset(
                  'assets/images/honor.png', // Replace with your image path
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Subscriber Completion Rate",
              style: TextStyle(
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 10.h),
            LinearProgressIndicator(
              value: 0.8,
              color: Colors.green,
              backgroundColor: Colors.grey.shade300,
            ),
            SizedBox(height: 20.h),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TimeCard(timeUnit: "Day", value: "13"),
                TimeCard(timeUnit: "Hour", value: "23"),
                TimeCard(timeUnit: "minute", value: "52"),
                TimeCard(timeUnit: "second", value: "58"),
              ],
            ),

            SizedBox(height: 20.h),
        ElevatedButton.icon(
          onPressed: () {
            _scaffoldKey.currentState!.showBottomSheet(
                  (context) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'شرح المنتج',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'هذا المنتج هو هاتف هونر 90 لايت ثنائي الشريحة يأتي بشاشة FHD وكاميرا خلفية بدقة عالية ومعالج قوي.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'يتميز الهاتف بتصميم أنيق وسعة تخزين كبيرة ودعم للاتصال السريع.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the sheet
                        },
                        child: const Text('إغلاق'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.arrow_drop_down),
          label: const Text(
            "توقيت تحول السحب الى مزاد",
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            backgroundColor: Colors.blue,
          )
        )
          ],
        ),
      ),
    );
  }
}

