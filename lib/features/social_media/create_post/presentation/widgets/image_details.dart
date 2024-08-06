import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class ImageDetailsScreen extends StatelessWidget {
  const ImageDetailsScreen({super.key, required this.image, required this.onRemoveImage, this.fromPost=false, this.isFile=false});
  final String image;
  final bool? fromPost;
  final bool? isFile;
  final Function onRemoveImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.DARK_BLUE_COLOR,
        leading: IconButton(
          onPressed: () {
            onRemoveImage();
          },
          icon: fromPost==true? const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ): const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.DARK_BLUE_COLOR,
        ),
        child:(fromPost==false||isFile==true)?Container(
          decoration:BoxDecoration(
            image: DecorationImage(
                image:FileImage(
                  File(image),
                )
            )
          ),
      ):Container(
          decoration:BoxDecoration(
              image: DecorationImage(
                  image:NetworkImage(
                    image,
                  )
              )
          ),
        ),
    ));
  }
}
