import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../res/style/app_colors.dart';

class ReportWidget extends StatelessWidget {
   const ReportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ابلاغ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.report,
                  color: Colors.red,
                ),
              ],
            ),
            Row(
              children: [
                 Expanded(
                  child: Text(
                    'غير لائق / عري',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                Checkbox(
                  value: false,
                  onChanged: (v) {},
                ),
              ],
            ),
             const Divider(),
            Row(
              children: [
                 Expanded(
                  child: Text(
                    'محتوي احتيالي',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                Checkbox(value: false, onChanged: (v) {}),
              ],
            ),
             const Divider(),
            Row(
              children: [
                 Expanded(
                  child: Text(
                    'وهمي',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                Checkbox(value: false, onChanged: (v) {}),
              ],
            ),
             const Divider(),
            Row(
              children: [
                 Expanded(
                  child: Text(
                    'إيذاء / إرهاب / عنف',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                Checkbox(value: false, onChanged: (v) {}),
              ],
            ),
             const Divider(),
            Row(
              children: [
                 Expanded(
                  child: Text(
                    'حض على الكراهية',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                Checkbox(value: false, onChanged: (v) {}),
              ],
            ),
             const Divider(),
            Row(
              children: [
                 Expanded(
                  child: Text(
                    'سلع غير مصرح بها / غير قانونية',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                Checkbox(value: false, onChanged: (v) {}),
              ],
            ),
             const Divider(),
            Row(
              children: [
                 Expanded(
                  child: Text(
                    'سبب اخر',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
                Checkbox(value: false, onChanged: (v) {}),
              ],
            ),
             const Divider(),
            DecoratedBox(
              decoration: BoxDecoration(
                color:  const Color(0xfff3f3f3),
                borderRadius: BorderRadius.circular(5),
              ),
              child:  TextField(
                maxLines: 2,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xfff3f3f3),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xfff3f3f3),
                    ),
                  ),
                  hintText: 'اكتب سبب الإبلاغ',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.PRIMARY_COLOR),
              child:  const Text('إبلاغ'),
            ),
          ],
        ),
      ),
    );
  }
}
