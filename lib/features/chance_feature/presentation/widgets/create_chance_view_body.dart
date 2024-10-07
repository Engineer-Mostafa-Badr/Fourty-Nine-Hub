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
            SizedBox(height: 20.h,),
            const AddImageWidget(),
            SizedBox(height: 20.h,),

            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
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
