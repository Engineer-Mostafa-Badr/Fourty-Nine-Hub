import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/add_image_widget.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/drop_down_widget.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class CreateChanceViewBody extends StatelessWidget {
    CreateChanceViewBody({super.key});
   var titleController = TextEditingController() ;

   var desController = TextEditingController() ;

   var priceController = TextEditingController() ;
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
                    LocaleKeys.payAtLeast1.localize,
                    textAlign: TextAlign.center,
                    style: Styles.headerText(
                      color: AppColors.SECONDARY_COLOR
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    LocaleKeys.oneUserWillR.localize,
                    textAlign: TextAlign.center,
                    style: Styles.mediumText(),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    LocaleKeys.moreSubscriptionMore.localize,
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
             Text(
              LocaleKeys.title.localize,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: titleController,
              decoration:  InputDecoration(
                prefixIcon: const Icon(Icons.title),
                hintText: LocaleKeys.enterTitle.localize,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
              },
            ),
            const SizedBox(height: 16),
             Text(
              LocaleKeys.desc.localize,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller:desController ,
              decoration:  InputDecoration(
                prefixIcon: const Icon(Icons.description),
                hintText: LocaleKeys.enterDescription.localize,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
             Text(
              LocaleKeys.price.localize,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: priceController,
              decoration:  InputDecoration(
                prefixIcon: const Icon(Icons.attach_money),
                hintText: LocaleKeys.enterPrice.localize,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
              },
              keyboardType: TextInputType.number, // To show numeric keyboard
            ),
             SizedBox(height: 60.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ()
                {

                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 25.h),
                  backgroundColor: AppColors.PRIMARY_COLOR,
                ),
                child: Text(
                    LocaleKeys.CreateChance.localize,
                    style: Styles.mediumText(
                        color:Colors.white,
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
