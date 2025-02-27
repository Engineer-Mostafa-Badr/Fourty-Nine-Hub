import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class ImageGalleryPage extends StatelessWidget {
  final List<String> images;
  final List<XFile>? files;
  final int initialIndex;
  final PageController pageController;

  ImageGalleryPage({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.files,
  }) : pageController = PageController(initialPage: initialIndex);

  @override
  Widget build(BuildContext context) {
    print("objectIndex$initialIndex");
    print("objectIndexFiles$files");
    return CustomScaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.w),
              child: InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => context.pop(),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 60.w,
                  shadows: context.isDarkMode
                      ? [
                          const Shadow(
                            color: Colors.black,
                            blurRadius: 5,
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ]
                      : [],
                ),
              ),
            ),
            Expanded(
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                itemCount: files!=null?files?.length??0:images.length,
                builder: (BuildContext context, int index) {
                  if(files != null){
                    return PhotoViewGalleryPageOptions(
                      imageProvider: FileImage(File(files?[index].path??'')),
                      initialScale: PhotoViewComputedScale.contained,
                      heroAttributes: PhotoViewHeroAttributes(tag: files![index]),
                    );
                  }else{
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(images[index]),
                      initialScale: PhotoViewComputedScale.contained,
                      heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
                    );
                  }
                },
                pageController: pageController,
                onPageChanged: (index) {},
                loadingBuilder: (context, event) => Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
