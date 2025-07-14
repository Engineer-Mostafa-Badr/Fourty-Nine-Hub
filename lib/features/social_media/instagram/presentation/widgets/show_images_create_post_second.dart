// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
// import 'package:wechat_assets_picker/wechat_assets_picker.dart';
//
// class ShowImagesCreatePostSecond extends StatelessWidget {
//   const ShowImagesCreatePostSecond({
//     super.key,
//     // required this.selectedImages,
//   });
//   // final List<Future<File?>> selectedImages;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.sizeOf(context).height * 0.35,
//       child: BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
//         builder: (context, state) {
//           print('state.selectedGalleryPost ${state.selectedGalleryPost.length}');
//           print('state.selectedGalleryReels ${state.selectedGalleryReels.length}');
//           if (state.selectedGalleryPost.isNotEmpty) {
//             return PageView.builder(
//               itemCount: state.selectedGalleryPost.length,
//               itemBuilder: (context, index) {
//                 return AssetEntityImage(
//                   state.selectedGalleryPost[index],
//                   fit: BoxFit.cover,
//                 );
//               },
//             );
//           }else if (state.selectedGalleryReels.isNotEmpty) {
//             return PageView.builder(
//               itemCount: state.selectedGalleryReels.length,
//               itemBuilder: (context, index) {
//                 return AssetEntityImage(
//                   state.selectedGalleryReels[index],
//                   thumbnailFormat: ThumbnailFormat.jpeg,
//                   isOriginal: false,
//                   fit: BoxFit.cover,
//                 );
//               },
//             );
//           }
//           return Container();
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ShowImagesCreatePostSecond extends StatefulWidget {
  const ShowImagesCreatePostSecond({
    super.key,
  });

  @override
  State<ShowImagesCreatePostSecond> createState() => _ShowImagesCreatePostSecondState();
}

class _ShowImagesCreatePostSecondState extends State<ShowImagesCreatePostSecond> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.35,
      child: BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
        builder: (context, state) {
          print('state.selectedGalleryPost ${state.selectedGalleryPost.length}');
          print('state.selectedGalleryReels ${state.selectedGalleryReels.length}');

          // تحديد البيانات المراد عرضها
          List<AssetEntity> itemsToShow = [];
          bool isReels = false;

          if (state.selectedGalleryPost.isNotEmpty) {
            itemsToShow = state.selectedGalleryPost;
            isReels = false;
          } else if (state.selectedGalleryReels.isNotEmpty) {
            itemsToShow = state.selectedGalleryReels;
            isReels = true;
          }

          if (itemsToShow.isEmpty) {
            return Container();
          }

          // إعادة تعيين الفهرس الحالي عند تغيير العناصر
          if (_currentIndex >= itemsToShow.length) {
            _currentIndex = itemsToShow.length - 1;
          }

          return Stack(
            children: [
              // PageView للصور/الفيديوهات
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: itemsToShow.length,
                itemBuilder: (context, index) {
                  return isReels
                      ? AssetEntityImage(
                    itemsToShow[index],
                    fit: BoxFit.cover,
                    thumbnailFormat: ThumbnailFormat.jpeg,
                    isOriginal: false,
                  )
                      : AssetEntityImage(
                    itemsToShow[index],
                    fit: BoxFit.cover,
                  );
                },
              ),

              // الإنديكيتور (فقط إذا كان هناك أكثر من عنصر واحد)
              if (itemsToShow.length > 1)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          itemsToShow.length,
                              (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // عداد الصور/الفيديوهات (في أعلى اليمين)
              if (itemsToShow.length > 1)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_currentIndex + 1}/${itemsToShow.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}