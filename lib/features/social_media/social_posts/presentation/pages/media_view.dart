import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../instagram/presentation/cubit/instagram_cubit.dart';
import '../../../instagram/presentation/widgets/instagram_profile_posts_view.dart';
import '../../domain/entities/post_entity.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../service_locator/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../helpers/manage_vibration.dart' as manageVibration;

class MediaView extends StatefulWidget {
  const MediaView({super.key, required this.userId});
  final String userId;

  @override
  State<MediaView> createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstagramCubit>(
      create: (_) => serviceLocator()..loadMedia(widget.userId),
      child: BlocConsumer<InstagramCubit, InstagramState>(
        listener: (context, state) {
          if (state.status == StateStatus.error) {
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure ?? UnknownFailure(''),
                context,
              ),
            );
          }
        },
        builder: (context, state) {
          final controller = context.read<InstagramCubit>();
          return PagedSliverGrid<int, PostEntity>(
            pagingController: controller.mediaPagingController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
            builderDelegate: PagedChildBuilderDelegate<PostEntity>(
              noItemsFoundIndicatorBuilder: (context) {
                return Center(
                  child: Text(
                    LocaleKeys.noMedia.localize,
                    style: TextStyle(
                      color: context.isDarkMode
                          ? AppColors.LIGHT_COLOR
                          : AppColors.DARK_BLUE_COLOR,
                      fontSize: 36.sp,
                    ),
                  ),
                );
              },
              itemBuilder: (context, item, index) {
                final sortedPosts = controller.mediaPagingController.itemList
                  ?..sort(
                    (a, b) => b.createdAt!.compareTo(a.createdAt!),
                  );

                final sortedItem = sortedPosts![index];

                return state.status == StateStatus.success
                    ? Container(
                        padding: EdgeInsets.only(top: 5.h, left: 5.w),
                        child: GestureDetector(
                          onTap: () {
      manageVibration.ManageVibration.vibrate();
                            // Pass the selected image and the sorted list to the next screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InstagramProfilePostsView(
                                  initialImage: sortedItem,
                                  posts: sortedPosts,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              height: 300.h,
                              imageUrl: sortedItem.images[0] ?? '',
                              fit: BoxFit.fill,
                              placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator(radius: 25),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Label(
                          text: getFailureMessage(
                            state.failure ?? UnknownFailure(''),
                            context,
                          ),
                        ),
                      );
              },
              noMoreItemsIndicatorBuilder: (context) => Container(),
              firstPageProgressIndicatorBuilder: (context) => Container(
                margin: const EdgeInsets.only(top: 150),
                child: const CupertinoActivityIndicator(),
              ),
              newPageProgressIndicatorBuilder: (context) =>
                  const CupertinoActivityIndicator(),
            ),
          );
        },
      ),
    );
  }
}