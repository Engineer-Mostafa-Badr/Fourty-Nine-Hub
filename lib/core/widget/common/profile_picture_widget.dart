import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_gradient_border.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({super.key, this.width,this.isMale=true, this.height,this.hasStories=true, this.isViewed, this.segments, this.firstChar, this.image, this.rating, this.isVerified});
  final double? width;
  final int? rating;
  final double? height;
  final bool? isViewed;
  final bool? isMale;
  final bool? isVerified;
  final bool? hasStories;
  final int? segments;
  final String? firstChar;
  final String? image;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GradientProfileBorder(
            imageUrl:  image??"",
            imageWidth: 46,
            fullWidth: 54,
            isMale:isMale,
            hasStories: hasStories,
            isViewed: isViewed??false,
            segments: segments??1,
            firstChar: firstChar??'M'),
        if(isVerified==true)PositionedDirectional(
          end: 0,
          bottom: 0,
          child: Icon(Icons.verified,color: Colors.blueAccent,size: 16,),
        ),
        if((rating??0)>0)PositionedDirectional(
          start: 0,
          top: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColors.GREY_DARK_COLOR
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.star,color: Colors.yellowAccent,size: 12,),
                  SizedBox(width: 3,),
                  Text('2',style: Styles.mediumText(color: Colors.white,fontSize: 20),)
                ],
              )),
        ),
      ],
    );
  }
}
