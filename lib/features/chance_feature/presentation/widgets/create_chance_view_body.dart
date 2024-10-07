import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/add_image_widget.dart';
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
              decoration: BoxDecoration(
                  boxShadow: AppColors.SHADOW_LIGHT,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Text(
                    'Pay at least 1 EGP and publish your dream product you want to buy!!!',
                    textAlign: TextAlign.center,
                    style: Styles.headerText(
                      color: AppColors.SECONDARY_COLOR
                    ),
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
                    style: Styles.mediumText(
                      color: AppColors.CHECK_MARK_COLOR
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            const DropDownChance(),
            SizedBox(
              height: 20.h,
            ),
            const AddImageWidget(),
            SizedBox(
              height: 20.h,
            ),
            const Text(
              'Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.title),
                hintText: 'Enter title',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Handle change
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.description),
                hintText: 'Enter description',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const Text(
              'Price',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.attach_money),
                hintText: 'Enter price',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Handle change
              },
              keyboardType: TextInputType.number, // To show numeric keyboard
            ),
             SizedBox(height: 60.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 25.h),
                  backgroundColor: AppColors.PRIMARY_COLOR,
                ),
                child: Text(
                    'Create Chance',
                    style: Styles.mediumText(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontSize: 55.sp,
                        fontWeight: FontWeight.w400)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
