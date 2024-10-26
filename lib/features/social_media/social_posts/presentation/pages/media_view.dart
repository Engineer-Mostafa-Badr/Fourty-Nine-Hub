import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      }, builder: (context, state) {
        final controller = context.read<InstagramCubit>();
        return PagedSliverGrid<int, PostEntity>(
          pagingController: controller.mediaPagingController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 1, mainAxisSpacing: 1),
          builderDelegate: PagedChildBuilderDelegate<PostEntity>(
              noItemsFoundIndicatorBuilder: (context) {
                print(controller.mediaPagingController.itemList?.length);
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
                return state.status == StateStatus.success
                    ? Container(
                        padding: const EdgeInsets.only(top: 2),
                        child: ClipRRect(
                          // borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            height: 300.h,
                            imageUrl: item.images?[0] ?? '',
                            fit: BoxFit.fill,
                            placeholder: (context, url) => const Center(
                              child: CupertinoActivityIndicator(radius: 25),
                            ),
                            errorWidget: (context, url, error) =>
                                const Center(child: Icon(Icons.error)),
                          ),
                        ),
                      )
                    : Center(
                        child: Label(
                            text: getFailureMessage(
                          state.failure ?? UnknownFailure(''),
                          context,
                        )),
                      );
              },
              noMoreItemsIndicatorBuilder: (context) => Container(),
              firstPageProgressIndicatorBuilder: (context) => Container(
                  margin: const EdgeInsets.only(top: 150),
                  child: const CupertinoActivityIndicator()),
              newPageProgressIndicatorBuilder: (context) =>
                  const CupertinoActivityIndicator()),
        );
      }),
    );
  }
}
