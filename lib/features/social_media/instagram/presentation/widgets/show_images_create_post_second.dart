import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ShowImagesCreatePostSecond extends StatelessWidget {
  const ShowImagesCreatePostSecond({
    super.key,
    // required this.selectedImages,
  });
  // final List<Future<File?>> selectedImages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.35,
      child: BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
        builder: (context, state) {
          return PageView.builder(
            itemCount: state.selectedGalleryPost.length,
            itemBuilder: (context, index) {
              return AssetEntityImage(
                state.selectedGalleryPost[index],
                fit: BoxFit.cover,
              );
              // return Image.file(state.selectedGalleryPost[index], fit: BoxFit.cover);
              // return FutureBuilder<File?>(
              //   future: state.selectedImages[index],
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       return Image.file(snapshot.data!);
              //     } else {
              //       return const CircularProgressIndicator();
              //     }
              //   },
              // );
            },
          );
        },
      ),
    );
  }
}
