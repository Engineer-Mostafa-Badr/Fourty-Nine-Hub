import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../../res/style/const.dart';

class ImageFromInternet extends StatelessWidget {
  const ImageFromInternet(
      {super.key,
      required this.image,
      this.width,
      this.height,
      this.borderRadius,
      this.fromFile = false,
      this.isCircle = false,
      });
  final String image;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool? fromFile;
  final bool? isCircle;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image??UIConst.profilePlaceHolder,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          shape: isCircle==true?BoxShape.circle:BoxShape.rectangle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
          ),

        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          shape: isCircle==true?BoxShape.circle:BoxShape.rectangle,
          color: AppColors.PRIMARY_COLOR,
          image: fromFile == true
              ? DecorationImage(
                  image: FileImage(File(image)),
                  fit: BoxFit.contain,
                )
              : const DecorationImage(
                  image: NetworkImage(UIConst.profilePlaceHolder),
                  fit: BoxFit.contain,
                ),
        ),
      ),
      placeholder: (context, url) => Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: AppColors.PRIMARY_COLOR,
          shape: isCircle==true?BoxShape.circle:BoxShape.rectangle,
          image: DecorationImage(
            image: AssetImage(Assets.logo),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
