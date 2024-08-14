import 'package:flutter/material.dart';
import '../../../../../res/style/app_colors.dart';

class ReportWidget extends StatelessWidget {
  const ReportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ابلاغ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.report,
                  color: Colors.red,
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'غير لائق / عري',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
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
                const Expanded(
                  child: Text(
                    'محتوي احتيالي',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                Checkbox(value: false, onChanged: (v) {}),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'وهمي',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                Checkbox(value: false, onChanged: (v) {}),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'إيذاء / إرهاب / عنف',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                Checkbox(value: false, onChanged: (v) {}),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'حض على الكراهية',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                Checkbox(value: false, onChanged: (v) {}),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'سلع غير مصرح بها / غير قانونية',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                Checkbox(value: false, onChanged: (v) {}),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'سبب اخر',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                Checkbox(value: false, onChanged: (v) {}),
              ],
            ),
            const Divider(),
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xfff3f3f3),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const TextField(
                maxLines: 2,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xfff3f3f3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xfff3f3f3),
                    ),
                  ),
                  hintText: 'اكتب سبب الإبلاغ',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.PRIMARY_COLOR),
              child: const Text('إبلاغ'),
            ),
          ],
        ),
      ),
    );
  }
}
