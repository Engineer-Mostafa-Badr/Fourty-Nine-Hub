
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import '../../../../../res/assets/assets.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../../../helpers/manage_vibration.dart';

class ShowImageCreatePostInstagramWidget extends StatefulWidget {
  const ShowImageCreatePostInstagramWidget({
    super.key,
  });

  @override
  State<ShowImageCreatePostInstagramWidget> createState() =>
      _ShowImageCreatePostInstagramWidgetState();
}

class _ShowImageCreatePostInstagramWidgetState
    extends State<ShowImageCreatePostInstagramWidget> {
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
    return BlocBuilder<CreatePostInstagramCubit, CreatePostInstagramState>(
      buildWhen: (previous, current) =>
      previous.selectedGalleryPost != current.selectedGalleryPost ||
          previous.isImageCover != current.isImageCover,
      builder: (context, state) {
        // Reset current index when images change
        if (state.selectedGalleryPost.isEmpty) {
          _currentIndex = 0;
        } else if (_currentIndex >= state.selectedGalleryPost.length) {
          _currentIndex = state.selectedGalleryPost.length - 1;
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: double.infinity,
          height: state.selectedGalleryPost.isEmpty
              ? 0
              : MediaQuery.of(context).size.height * 0.35,
          child: state.selectedGalleryPost.isEmpty
              ? const SizedBox()
              : Stack(
            children: [
              // الصور كسلايدر
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.45,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: state.selectedGalleryPost.length,
                  itemBuilder: (context, index) {
                    return InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(20),
                      minScale: 1.0,
                      maxScale: 6.0,
                      scaleEnabled: true,
                      child: AssetEntityImage(
                        state.selectedGalleryPost[index],
                        fit: state.isImageCover
                            ? BoxFit.cover
                            : BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),

              // أسهم التنقل (فقط إذا كان هناك أكثر من صورة)
              if (state.selectedGalleryPost.length > 1) ...[
                // السهم الأيسر
                Positioned(
                  left: 10,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
      ManageVibration.vibrate();
                        if (_currentIndex > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                // السهم الأيمن
                Positioned(
                  right: 10,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
      ManageVibration.vibrate();
                        if (_currentIndex < state.selectedGalleryPost.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              // الإنديكيتور (فقط إذا كان هناك أكثر من صورة)
              if (state.selectedGalleryPost.length > 1)
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
                          state.selectedGalleryPost.length,
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

              // زر تغيير نوع العرض
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
      ManageVibration.vibrate();
                    context
                        .read<CreatePostInstagramCubit>()
                        .changeCoverImage();
                  },
                  child: Container(
                    width: 37,
                    height: 37,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(3),
                    decoration: const ShapeDecoration(
                      color: Color(0xFFD9D9D9),
                      shape: OvalBorder(),
                    ),
                    child: SvgPicture.asset(
                      state.isImageCover
                          ? Assets.narrowIcon
                          : Assets.expandIcon,
                    ),
                  ),
                ),
              ),

              // عداد الصور (في أعلى اليمين)
              if (state.selectedGalleryPost.length > 1)
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
                      '${_currentIndex + 1}/${state.selectedGalleryPost.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}