import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ProfilePhotos extends StatelessWidget {
  const ProfilePhotos({super.key, this.name});
final String? name;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Label(
              text:
                  context.isArabic ? name==null?'صورك و فيديوهاتك':'صور و فيديوهات $name' : '${name??'Your'} Photos and Videos',
              style: Styles.headerText(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Sizer(),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                children: [
                  _photoCategory(context,UIConst.socialImagePlaceHolder,context.isArabic?'صور مُشارة اليك':'Tagged Photos'),
                  _photoCategory(context,UIConst.socialImagePlaceHolder,context.isArabic?'صور':'Photos'),
                  _photoCategory(context,UIConst.socialImagePlaceHolder,context.isArabic?'ألبومات':'Albums'),
                  _photoCategory(context,UIConst.socialImagePlaceHolder,context.isArabic?'فيديوهات':'Videos'),
                ],
              ),
            ),
          ),
          const Sizer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Label(
              text:
              context.isArabic ? 'صورك' : 'Your Photos',
              style: Styles.headerText(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Sizer(height: 20,),
          GridView.builder(
            padding:const EdgeInsets.symmetric(horizontal: 8),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 32,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2.0, // spacing between rows
                crossAxisSpacing: 2.0, // spacing between columns
              ),
              itemBuilder: (context, index) =>_profilePhoto(UIConst.socialImagePlaceHolder)),
        ],
      ),
    );
  }
  Widget _photoCategory(BuildContext context,String image,String label){
    return ClickableWidget(
      onTap: (){},
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Stack(
            children: [
              Container(
                width: 330.w,
                height:260.h ,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(
                   image,
                  ),fit: BoxFit.cover,),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Container(
                width: 330.w,
                height:260.h ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.transparent
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.05,0.3]
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.0.h),
            child: Label(text: label,style: Styles.mediumText(color: Colors.white,fontWeight: FontWeight.bold),),
          )
        ],
      ),
    );
  }

  Widget _profilePhoto(String image) {
    return ClickableWidget(
      onTap: () {},
      child: AspectRatio(
        aspectRatio: 4 / 4,
        child: Container(
          // width: 230.w,
          // height: 260.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: ImageFromInternet(
              image: image,
              fit: BoxFit.cover,
              width: double.infinity,
            )),
      ),
    );
  }

}
