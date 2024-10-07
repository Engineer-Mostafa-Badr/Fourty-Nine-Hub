import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/drop_down_widget.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';


class CreateChanceViewBody extends StatelessWidget {
  const CreateChanceViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration:  BoxDecoration(
                boxShadow: AppColors.SHADOW_LIGHT,
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16)
              ),
              child: Column(
                children: [
                  Text(
                    'Pay at least 1 EGP and publish your dream product you want to buy!!!',
                    textAlign: TextAlign.center,
                    style: Styles.headerText(),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'One User will win randomly every month cycle',
                    textAlign: TextAlign.center,
                    style: Styles.mediumText(),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'More subscription more chance!',
                    textAlign: TextAlign.center,
                    style:  Styles.mediumText(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h,),
            const DropDownChance(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Icon indicating image upload
                Icon(
                  Icons.image,
                  size: 100,
                  color: Colors.blueAccent,
                ),
                SizedBox(height: 20),
                // Add Images Button
                ElevatedButton(
                  onPressed: () {
                    // أضف الإجراء الذي تريد تنفيذه عند الضغط على الزر
                    print("Add Images button pressed!");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // لون الزر
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Add Images',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                // Text showing file size limit
                Text(
                  '5MB maximum file size accepted in the following formats:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              maxLines:3, // Allow for multiple lines
              decoration: const InputDecoration(
                hintText: 'Enter description',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const Text(
              'Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter title',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Handle change
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Price',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter price',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Handle change
              },
              keyboardType: TextInputType.number, // To show numeric keyboard
            ),

          ],
        ),
      ),
    );
  }
}
