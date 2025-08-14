import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/custom_error.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/debouncer.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/tag_users_cubit/tag_users_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/tag_user_view_body.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../../../service_locator/service_locator.dart';

class TagUserView extends StatefulWidget {
  const TagUserView({super.key});

  @override
  State<TagUserView> createState() => _TagUserViewState();
}

class _TagUserViewState extends State<TagUserView> {
  late ScrollController _scrollController;
  late final TextEditingController searchController;
  late final FocusNode _focusNode;
  final Debouncer _debouncer = Debouncer();

  // متغيرات لحفظ معلومات الضغط
  Offset? pendingTapPosition;
  int? pendingImageIndex;
  bool isSearchClicked = false;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);
    searchController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      serviceLocator<TagUsersCubit>().searchUsersTag(searchController.text);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    searchController.dispose();
    super.dispose();
  }

  void _handleTextFieldChange(String value) {
    _debouncer.run(() {
      serviceLocator<TagUsersCubit>().loadInitialData(value);
    });
  }

  // دالة لحفظ معلومات الضغط
  void _handleImageTap(Offset tapPosition, int imageIndex) {
    setState(() {
      pendingTapPosition = tapPosition;
      pendingImageIndex = imageIndex;
      isSearchClicked = true;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagUsersCubit, TagUsersState>(
      builder: (context, state) {
        return CustomScaffold(
          body: SafeArea(
            child: Column(
              children: [
                isSearchClicked
                    ? Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextField(
                    controller: searchController,
                    focusNode: _focusNode,
                    onChanged: (value) {
                      _handleTextFieldChange(value);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: context.isDarkMode
                          ? const Color(0xFF1B1B1B)
                          : const Color(0xffF0F0F0),
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 11),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      prefixIcon: SizedBox(
                        width: 16,
                        height: 16,
                        child: Center(
                          child: SvgPicture.asset(context.isDarkMode
                              ? Assets.instagramSearchIconDark
                              : Assets.instagramSearchIcon),
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          isSearchClicked = false;
                          _focusNode.unfocus();
                          searchController.clear();
                          // إعادة تعيين معلومات الضغط
                          pendingTapPosition = null;
                          pendingImageIndex = null;
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.close,
                          color: context.isDarkMode
                              ? const Color(0x80FFFFFF)
                              : const Color(0x80000000),
                        ),
                      ),
                      hintText: LocaleKeys.searchForAUser.localize,
                      hintStyle: Styles.mediumText(
                        color: context.isDarkMode
                            ? const Color(0x80FFFFFF)
                            : const Color(0x80000000),
                      ),
                    ),
                  ),
                )
                    : Row(
                  children: [
                    const SizedBox(width: 5),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                    const SizedBox(width: 24),
                    Label(
                      text: LocaleKeys.tagPeople.localize,
                      style: Styles.headerText(),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.check,
                        color: Color(0xffFF3308),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                searchController.text.isNotEmpty
                    ? Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state.status.isLoading ||
                          state.status.isInitial) {
                        return const CustomLoading();
                      }
                      if (state.status.isError) {
                        return CustomError(
                          errMessage:
                          getFailureMessage(state.failure!, context),
                        );
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: serviceLocator<TagUsersCubit>()
                            .users
                            .length +
                            (serviceLocator<TagUsersCubit>().isLoadingMore
                                ? 1
                                : 0),
                        itemBuilder: (context, index) {
                          if (index ==
                              serviceLocator<TagUsersCubit>()
                                  .users
                                  .length) {
                            return const Center(
                                child: CustomCircularProgressIndicator());
                          }
                          final user =
                          serviceLocator<TagUsersCubit>().users[index];
                          return BlocBuilder<CreatePostInstagramCubit,
                              CreatePostInstagramState>(
                            buildWhen: (previous, current) =>
                            previous.usersTag != current.usersTag,
                            builder: (context, state) {
                              return ListTile(
                                leading: ImageFromInternet(
                                  image: user.imageUrl,
                                  isCircle: true,
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                ),
                                title: Label(
                                  text: user.username,
                                  style: Styles.mediumText(
                                    fontWeight: FontWeight.w500,
                                    height: 1.29,
                                  ),
                                ),
                                trailing: serviceLocator<CreatePostInstagramCubit>()
                                    .state
                                    .usersTag
                                    .any((u) => u.id == user.id)
                                    ? const Icon(
                                  Icons
                                      .check_circle_outline_rounded,
                                  color: Colors.green,
                                )
                                    : null,
                                onTap: () {
                                  // إضافة المستخدم مع معلومات الضغط المحفوظة
                                  print('Adding user tag:');
                                  print('User ID: ${user.id}');
                                  print('Position: $pendingTapPosition');
                                  print('Image Index: $pendingImageIndex');

                                  serviceLocator<CreatePostInstagramCubit>()
                                      .addUserTag(
                                    user,
                                    position: pendingTapPosition,
                                    imageIndex: pendingImageIndex,
                                  );

                                  // العودة للشاشة السابقة
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                )
                    : Expanded(
                  child: TagUserViewBody(
                    onSearchTap: _handleImageTap,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}