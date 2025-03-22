import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

import '../../../../res/style/styles.dart';
import '../labels/label.dart';

class SocialImageViewer extends StatelessWidget {
  final double? height, width;
  final String image;
  final int length, index;
  final Function? onDoubleTap;
  const SocialImageViewer(
      {super.key,
      this.height,
      this.width,
      this.onDoubleTap,
      required this.image,
      required this.length,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      // onTap: () => showDialog(
      //   context: context,
      //   builder: (context) => ImageDetailsScreen(
      //     image: image,
      //     fromPost: true,
      //     isFile: false,
      //     onRemoveImage: () {
      //       context.pop();
      //     },
      //   ),
      // ),
      onDoubleTap: () => onDoubleTap != null ? onDoubleTap!() : null,
      child: SizedBox(
          height: height ?? kToolbarHeight * 3,
          width: width ?? double.infinity,
          child: Stack(
            children: [
              // Positioned.fill(
              //   child: Image(
              //     fit: BoxFit.fill,
              //     image: Image.network(image).image,
              //   ),
              // ),
              ImageFromInternet(image: image),
              if (length > 1)
                Positioned(
                    top: 20.h,
                    right: 20.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      // height: kToolbarHeight * .5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black54,
                      ),
                      child: Label(
                          text: '$index/$length',
                          style: Styles.mediumText(color: Colors.white)),
                    ))
            ],
          )),
    );
  }
}
