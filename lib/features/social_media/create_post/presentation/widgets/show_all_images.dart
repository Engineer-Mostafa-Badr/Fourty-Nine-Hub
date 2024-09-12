import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

class ShowAllImages extends StatefulWidget {
  const ShowAllImages(
      {super.key, required this.images, required this.onRemoveImage});
  final List<dynamic> images;
  final Function onRemoveImage;

  @override
  State<ShowAllImages> createState() => _ShowAllImagesState();
}

class _ShowAllImagesState extends State<ShowAllImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.DARK_BLUE_COLOR,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColors.DARK_BLUE_COLOR,
        child: ListView.builder(
          itemCount: widget.images.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              print("object");
              // context.push(Routes.TWITTER);

              showDialog(
                context: context,
                builder: (context) => ImageDetailsScreen(
                  image: widget.images[index].file.path,
                  fromPost: true,
                  isFile: true,
                  onRemoveImage: () {
                    context.pop();
                    // images.remove(images[index]);
                  },
                ),
              );
              // context.pop();
            },
            child: Stack(
              children: [
                Container(
                  height: 400.h,
                  margin: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.DARK_BLUE_COLOR,
                      image: DecorationImage(
                          image:
                              FileImage(File(widget.images[index].file.path)),
                          fit: BoxFit.fill)),
                ),
                PositionedDirectional(
                  end: 5,
                  top: 5,
                  child: InkWell(
                    onTap: () async {
                      await widget.onRemoveImage(widget.images[index]);
                      setState(() {});
                    },
                    child: Container(
                        height: 30.h,
                        width: 30,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
