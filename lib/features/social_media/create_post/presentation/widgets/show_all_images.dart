import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/presentation/pages/image_gallary_viewer.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class ShowAllImages extends StatefulWidget {
  const ShowAllImages(
      {super.key, required this.images,this.imagesUrls, required this.onRemoveImage});
  final List<UploadFileEntity> images;
  final List<String>? imagesUrls;
  final Function onRemoveImage;

  @override
  State<ShowAllImages> createState() => _ShowAllImagesState();
}

class _ShowAllImagesState extends State<ShowAllImages> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
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
          itemCount:widget.imagesUrls!=null? (widget.imagesUrls?.length??0): widget.images.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              print("object");
              List<XFile> images = widget.images.map((e) => e.file).toList();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageGalleryPage(
                    images: widget.imagesUrls!=null?(widget.imagesUrls??[]):[],
                    files:widget.imagesUrls!=null?null: images,
                    initialIndex: index,
                  ),
                ),
              );
              // showDialog(
              //   context: context,
              //   builder: (context) => ImageDetailsScreen(
              //     image: widget.images[index].path,
              //     fromPost: true,
              //     isFile: true,
              //     onRemoveImage: () {
              //       context.pop();
              //       // images.remove(images[index]);
              //     },
              //   ),
              // );
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
                      image:widget.imagesUrls!=null?DecorationImage(image: NetworkImage(widget.imagesUrls?[index]??''),fit: BoxFit.fill): DecorationImage(
                          image:
                              FileImage(File(widget.images[index].file.path)),
                          fit: BoxFit.fill)),
                ),
                if(widget.imagesUrls==null)PositionedDirectional(
                  end: 5,
                  top: 5,
                  child: InkWell(
                    onTap: () async {
                      await widget.onRemoveImage(widget.images[index]);
                      widget.images.remove(widget.images[index]);
                      setState(() {});
                    },
                    child: Container(
                        height: 50.h,
                        width: 50,
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.all(5),
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
