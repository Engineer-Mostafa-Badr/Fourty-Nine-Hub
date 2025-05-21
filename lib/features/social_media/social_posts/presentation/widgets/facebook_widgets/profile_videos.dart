import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ProfileVideos extends StatelessWidget {
  const ProfileVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
              padding:const EdgeInsets.symmetric(horizontal: 8,),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 32,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 3.0, // spacing between rows
                crossAxisSpacing: 3.0, // spacing between columns
                childAspectRatio: .55,
              ),
              itemBuilder: (context, index) =>_profileVideo(context,UIConst.socialImagePlaceHolder)),
        ],
      ),
    );
  }
  Widget _profileVideo(BuildContext context ,String image) {
    return ClickableWidget(
      onTap: () {},
      child: AspectRatio(
        aspectRatio: 1 / 3,
        child: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: ImageFromInternet(
                  image: image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )),
            PositionedDirectional(
              start:10,
              bottom: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4,vertical: 1),
                decoration:BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color:  AppColors.getTextColor(context).withOpacity(0.4),
                ) ,
                child: Row(
                  children: [
                    Icon(Icons.remove_red_eye_outlined,color: AppColors.getReversedTextColor(context),size: 15,),
                    const Sizer(width: 4,),
                    Label(text: '${600}'.toArabicNumbers(context),style: Styles.smallText(color: AppColors.getReversedTextColor(context)),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
