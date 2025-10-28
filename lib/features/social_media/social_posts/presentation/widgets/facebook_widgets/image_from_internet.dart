import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/app_colors.dart';

import '../../../../../../res/style/const.dart';

class ImageFromInternet extends StatelessWidget {
  const ImageFromInternet({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.borderRadius,
    this.fromFile = false,
    this.isCircle = false,
    this.defaultLogo = false,
    this.isSvg = false,
    this.fit,
    this.border,
    this.firstChar,
    this.charPadding = 10,
    this.isMale = true,
  });
  final String image;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool? fromFile;
  final bool? isCircle;
  final bool? isSvg;
  final bool? defaultLogo;
  final BoxFit? fit;
  final Border? border;
  final bool isMale;
  final String? firstChar;
  final double? charPadding;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      imageBuilder: (context, imageProvider) => isSvg == true
          ? SvgPicture.network(
              image,
              height: height,
              width: width,
              fit: fit ?? BoxFit.fill,
            )
          : Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit ?? BoxFit.fill,
                ),
                border: border,
              ),
            ),
      errorWidget: (context, url, error) => SizedBox(
        height: height,
        width: width,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
                color: Colors.transparent,
                border: Border.all(color: AppColors.LIGHT_GRAY_COLOR),
                image: fromFile == true
                    ? DecorationImage(
                        image: FileImage(File(image)),
                        fit: BoxFit.fill,
                      )
                    : defaultLogo == true
                        ? DecorationImage(
                            image: AssetImage(Assets.logo),
                            fit: BoxFit.fill,
                          )
                        : isMale
                            ? DecorationImage(
                                image: AssetImage(Assets.manIcon),
                                fit: BoxFit.fill,
                              )
                            : DecorationImage(
                                image: AssetImage(Assets.womanIcon),
                                fit: BoxFit.fill,
                              ),
              ),
            ),
            if (firstChar != null && (firstChar?.isNotEmpty ?? false))
              PositionedDirectional(
                bottom: 0,
                // end: 0,
                child: Container(
                  width: 60,
                  padding: EdgeInsets.all(charPadding ?? 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 0.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    firstChar ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.PRIMARY_COLOR,
                        fontSize: 8),
                  ),
                ),
              )
          ],
        ),
      ),
      placeholder: (context, url) => Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Colors.transparent,
          border: border,
          shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
          image: DecorationImage(
            image: AssetImage(Assets.logo),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
