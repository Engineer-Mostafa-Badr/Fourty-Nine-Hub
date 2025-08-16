// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
// import 'package:fourtyninehub/core/extensions/string_extension.dart';
// import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
// import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
// import 'package:fourtyninehub/res/assets/assets.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:wechat_assets_picker/wechat_assets_picker.dart';
//
// import '../../../../../service_locator/service_locator.dart';
//
// class ShowImageTagPeopleWidget extends StatefulWidget {
//   const ShowImageTagPeopleWidget({
//     super.key,
//     required this.onTap,
//   });
//
//   final void Function(Offset tapPosition, int imageIndex) onTap;
//
//   @override
//   State<ShowImageTagPeopleWidget> createState() =>
//       _ShowImageTagPeopleWidgetState();
// }
//
// class _ShowImageTagPeopleWidgetState extends State<ShowImageTagPeopleWidget> {
//   late final List<AssetEntity> images;
//   late PageController _pageController;
//   int currentImageIndex = 0;
//
//   @override
//   void initState() {
//     images = serviceLocator<CreatePostInstagramCubit>().state.selectedGalleryPost;
//     _pageController = PageController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   /// تقوم باستقبال موقع الضغط
//   void _handleTapDown(TapDownDetails details) {
//     print('Tap detected at: ${details.localPosition} on image: $currentImageIndex');
//     widget.onTap(details.localPosition, currentImageIndex);
//   }
//
//   /// تقوم بإنشاء ويدجت المؤشر للتاج
//   Widget _buildTagIndicator(Offset position, String username) {
//     return Positioned(
//       left: position.dx - 40,
//       top: position.dy - 30,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             decoration: BoxDecoration(
//               color: AppColors.PRIMARY_COLOR_DARK,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Label(
//               text: username,
//               style: Styles.mediumText(
//                 fontSize: 18,
//                 color: context.isDarkMode
//                     ? const Color(0xFF0D0D0D)
//                     : Colors.white,
//               ),
//             ),
//           ),
//           // مثلث صغير
//           Container(
//             width: 0,
//             height: 0,
//             decoration: BoxDecoration(
//               border: Border(
//                 left: BorderSide(
//                   width: 5,
//                   color: Colors.transparent,
//                 ),
//                 right: BorderSide(
//                   width: 5,
//                   color: Colors.transparent,
//                 ),
//                 top: BorderSide(
//                   width: 8,
//                   color: AppColors.PRIMARY_COLOR_DARK,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
//       buildWhen: (previous, current) => previous.usersTag != current.usersTag,
//       builder: (context, state) {
//         return PageView.builder(
//           controller: _pageController,
//           onPageChanged: (index) {
//             setState(() {
//               currentImageIndex = index;
//             });
//             print('Page changed to: $index');
//           },
//           itemCount: images.length,
//           itemBuilder: (context, index) {
//             // الحصول على التاجز الخاصة بهذه الصورة
//             final imageTagsForCurrentImage = state.usersTag
//                 .where((user) => user.imageIndex == index && user.position != null)
//                 .toList();
//
//             print('Image $index has ${imageTagsForCurrentImage.length} tags');
//
//             return Stack(
//               children: [
//                 GestureDetector(
//                   onTapDown: _handleTapDown,
//                   child: AssetEntityImage(
//                     images[index],
//                     fit: BoxFit.contain,
//                     width: double.infinity,
//                     height: double.infinity,
//                   ),
//                 ),
//                 // عرض التاجز الموجودة لهذه الصورة
//                 ...imageTagsForCurrentImage.map((user) {
//                   return _buildTagIndicator(
//                     Offset(user.position!.x, user.position!.y),
//                     user.username,
//                   );
//                 }).toList(),
//
//                 // مؤشر الصفحة إذا كان هناك أكثر من صورة
//                 if (images.length > 1)
//                   Positioned(
//                     bottom: 10,
//                     left: 0,
//                     right: 0,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: List.generate(
//                         images.length,
//                             (dotIndex) => Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 3),
//                           width: 8,
//                           height: 8,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: dotIndex == currentImageIndex
//                                 ? Colors.white
//                                 : Colors.white54,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../../../service_locator/service_locator.dart';

class ShowImageTagPeopleWidget extends StatefulWidget {
  const ShowImageTagPeopleWidget({
    super.key,
    required this.onTap,
  });

  final void Function(Offset tapPosition, int imageIndex) onTap;

  @override
  State<ShowImageTagPeopleWidget> createState() =>
      _ShowImageTagPeopleWidgetState();
}

class _ShowImageTagPeopleWidgetState extends State<ShowImageTagPeopleWidget> {
  late final List<AssetEntity> images;
  late PageController _pageController;
  int currentImageIndex = 0;

  // إضافة متغير لحفظ موقع النقر المؤقت
  Offset? temporaryTapPosition;

  @override
  void initState() {
    images = serviceLocator<CreatePostInstagramCubit>().state.selectedGalleryPost;
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.initState();
  }

  /// تقوم باستقبال موقع الضغط
  void _handleTapDown(TapDownDetails details) {
    print('Tap detected at: ${details.localPosition} on image: $currentImageIndex');

    // حفظ موقع النقر مؤقتاً وإظهار label "من هذا؟"
    setState(() {
      temporaryTapPosition = details.localPosition;
    });

    // إخفاء الـ label بعد 3 ثواني
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          temporaryTapPosition = null;
        });
      }
    });

    widget.onTap(details.localPosition, currentImageIndex);
  }

  /// تقوم بإنشاء ويدجت المؤشر للتاج
  Widget _buildTagIndicator(Offset position, String username) {
    return Positioned(
      left: position.dx - 40,
      top: position.dy - 30,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.PRIMARY_COLOR_DARK,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Label(
              text: username,
              style: Styles.mediumText(
                fontSize: 18,
                color: context.isDarkMode
                    ? const Color(0xFF0D0D0D)
                    : Colors.white,
              ),
            ),
          ),
          // مثلث صغير
          Container(
            width: 0,
            height: 0,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 5,
                  color: Colors.transparent,
                ),
                right: BorderSide(
                  width: 5,
                  color: Colors.transparent,
                ),
                top: BorderSide(
                  width: 8,
                  color: AppColors.PRIMARY_COLOR_DARK,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// إنشاء label "من هذا؟" مؤقت
  Widget _buildTemporaryTagLabel(Offset position) {
    return Positioned(
      left: position.dx - 50,
      top: position.dy - 35,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.PRIMARY_COLOR_DARK,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Label(
              text:context.isArabic? 'من هذا؟' : "Who is this?",
              style: Styles.mediumText(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          // مثلث صغير
          Container(
            width: 0,
            height: 0,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 6,
                  color: Colors.transparent,
                ),
                right: BorderSide(
                  width: 6,
                  color: Colors.transparent,
                ),
                top: BorderSide(
                  width: 10,
                  color: AppColors.PRIMARY_COLOR_DARK,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
      buildWhen: (previous, current) => previous.usersTag != current.usersTag,
      builder: (context, state) {
        return PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentImageIndex = index;
              // إخفاء الـ label المؤقت عند تغيير الصفحة
              temporaryTapPosition = null;
            });
            print('Page changed to: $index');
          },
          itemCount: images.length,
          itemBuilder: (context, index) {
            // الحصول على التاجز الخاصة بهذه الصورة
            final imageTagsForCurrentImage = state.usersTag
                .where((user) => user.imageIndex == index && user.position != null)
                .toList();

            print('Image $index has ${imageTagsForCurrentImage.length} tags');

            return Stack(
              children: [
                GestureDetector(
                  onTapDown: _handleTapDown,
                  child: AssetEntityImage(
                    images[index],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),

                // عرض التاجز الموجودة لهذه الصورة
                ...imageTagsForCurrentImage.map((user) {
                  return _buildTagIndicator(
                    Offset(user.position!.x, user.position!.y),
                    user.username,
                  );
                }).toList(),

                // عرض label "من هذا؟" المؤقت في مكان النقر
                if (temporaryTapPosition != null && index == currentImageIndex)
                  _buildTemporaryTagLabel(temporaryTapPosition!),

                // مؤشر الصفحة إذا كان هناك أكثر من صورة
                if (images.length > 1)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                            (dotIndex) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dotIndex == currentImageIndex
                                ? Colors.white
                                : Colors.white54,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}