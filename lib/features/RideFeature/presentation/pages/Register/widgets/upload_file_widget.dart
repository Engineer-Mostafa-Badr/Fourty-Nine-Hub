import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../../res/assets/assets.dart';

class UploadFileWidget extends StatelessWidget {
  const UploadFileWidget({super.key, this.onTap, required this.title,this.imageUrl});
  final GestureTapCallback? onTap;
  final String title;
  final XFile? imageUrl;
  @override
  Widget build(BuildContext context) {
    print("imgUrl $imageUrl");
    return ClickableWidget(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: context.isDarkMode?AppColors.GREY_DARK_COLOR:AppColors.GREYBG,
              image: imageUrl != null ? DecorationImage(image: FileImage(File(imageUrl?.path??'')),fit: BoxFit.cover):null
            ),
            height: 100,
            width: 100,
            padding: const EdgeInsets.all(35),
            child: imageUrl != null&&imageUrl?.path!='' ? const SizedBox.shrink(): Image.asset(
              Assets.uploadImageCamera,
              height: 30,
              width: 30,
              color:context.isDarkMode?Colors.white: AppColors.PRIMARY_COLOR,
            ),
          ),
          const Sizer(),
          Label(
            text: title,
            style: Styles.smallText(
              fontSize: 28,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.visible,
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

