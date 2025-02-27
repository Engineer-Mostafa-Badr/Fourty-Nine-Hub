import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/widgets/image_details.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class ShowPostsImages extends StatefulWidget {
  const ShowPostsImages(
      {super.key, required this.images, required this.onRemoveImage});
  final List<String> images;
  final Function onRemoveImage;

  @override
  State<ShowPostsImages> createState() => _ShowPostsImagesState();
}

class _ShowPostsImagesState extends State<ShowPostsImages> {
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
          itemCount: widget.images.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              print("object");
              // context.push(Routes.TWITTER);

              showDialog(
                context: context,
                builder: (context) => ImageDetailsScreen(
                  image: widget.images[index],
                  fromPost: true,
                  onRemoveImage: () {
                    context.pop();
                    // images.remove(images[index]);
                  },
                ),
              );
              // context.pop();
            },
            child: Container(
              height: 400.h,
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.DARK_BLUE_COLOR,
                  image: DecorationImage(
                      image: NetworkImage(widget.images[index]),
                      fit: BoxFit.fill)),
            ),
          ),
        ),
      ),
    );
  }
}
