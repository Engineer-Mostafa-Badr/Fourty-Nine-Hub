import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/error/custom_error.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/loading/custom_loading.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/utils/debouncer.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../cubit/create_post_instagram_cubit/create_post_instagram_cubit.dart';
import '../cubit/tag_users_cubit/tag_users_cubit.dart';
import 'tag_user_view_body.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../../helpers/manage_vibration.dart';

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
      context.read<TagUsersCubit>().searchUsersTag(searchController.text);
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
      context.read<TagUsersCubit>().loadInitialData(value);
    });
  }

  bool isSearchClicked = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagUsersCubit, TagUsersState>(
      builder: (context, state) {
        return CustomScaffold(
          // appBar: AppBar(
          //   title: isSearchClicked
          //       ? Container(
          //           height: 40,
          //           decoration: BoxDecoration(
          //             color: const Color(0xffF0F0F0),
          //             borderRadius: BorderRadius.circular(6),
          //           ),
          //           child: TextField(
          //             controller: searchController,
          //             focusNode: _focusNode,
          //             onChanged: (value) {
          //               _handleTextFieldChange(value);
          //             },
          //             decoration: InputDecoration(
          //               contentPadding:
          //                   const EdgeInsets.fromLTRB(16, 20, 16, 12),
          //               border: InputBorder.none,
          //               focusedBorder: InputBorder.none,
          //               enabledBorder: InputBorder.none,
          //               disabledBorder: InputBorder.none,
          //               errorBorder: InputBorder.none,
          //               focusedErrorBorder: InputBorder.none,
          //               prefixIcon: const Icon(
          //                 Icons.search_rounded,
          //                 color: Color(0x80000000),
          //               ),
          //               suffixIcon: IconButton(
          //                   onPressed: () {
          //                     isSearchClicked = false;
          //                     _focusNode.unfocus();
          //                     setState(() {});
          //                   },
          //                   icon: const Icon(Icons.close)),
          //               hintText: LocaleKeys.searchForAUser.localize,
          //               hintStyle: Styles.mediumText(
          //                 color: Colors.black.withValues(alpha: 128),
          //                 fontSize: 32,
          //               ),
          //             ),
          //           ),
          //         )
          //       : Label(
          //           text: LocaleKeys.tagPeople.localize,
          //           style: Styles.headerText(),
          //         ),
          //   leading: isSearchClicked
          //       ? Container()
          //       : IconButton(
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //           icon: const Icon(Icons.close_rounded),
          //         ),
          //   actions: isSearchClicked
          //       ? null
          //       : [
          //           IconButton(
          //             onPressed: () {},
          //             icon: const Icon(
          //               Icons.check,
          //               color: Color(0xffFF3308),
          //             ),
          //           ),
          //         ],
          // ),
          body: SafeArea(
            child: Column(
              children: [
                isSearchClicked
                    ? Container(
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        // decoration: BoxDecoration(
                        //   color: context.isDarkMode
                        //       ? Colors.grey[700]
                        //       : const Color(0xffF0F0F0),
                        //   borderRadius: BorderRadius.circular(6),
                        // ),
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
                            // contentPadding:
                            //     const EdgeInsets.fromLTRB(16, 20, 16, 12),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 11),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            // prefixIcon: const Icon(
                            //   Icons.search_rounded,
                            //   color: Color(0x80000000),
                            // ),
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
      ManageVibration.vibrate();
                                isSearchClicked = false;
                                _focusNode.unfocus();
                                searchController.clear();
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
                            // hintStyle: Styles.mediumText(
                            //   color: Colors.black.withValues(alpha: 128),
                            //   fontSize: 32,
                            // ),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            onPressed: () {
      ManageVibration.vibrate();
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          Label(
                            text: LocaleKeys.tagPeople.localize,
                            style: Styles.headerText(),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {

      ManageVibration.vibrate();
                            },
                            icon: const Icon(
                              Icons.check,
                              color: Color(0xffFF3308),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 12,
                ),
                searchController.text.isNotEmpty
                    ? Expanded(
                        child: Builder(
                          builder: (context) {
                            // if (state.status.isInitial) {
                            //   return Container();
                            // }
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
                              itemCount: context
                                      .read<TagUsersCubit>()
                                      .users
                                      .length +
                                  (context.read<TagUsersCubit>().isLoadingMore
                                      ? 1
                                      : 0),
                              itemBuilder: (context, index) {
                                if (index ==
                                    context
                                        .read<TagUsersCubit>()
                                        .users
                                        .length) {
                                  return const Center(
                                      child: CustomCircularProgressIndicator());
                                }
                                final user =
                                    context.read<TagUsersCubit>().users[index];
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
                                      trailing: context
                                              .read<CreatePostInstagramCubit>()
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
      ManageVibration.vibrate();
                                        context
                                            .read<CreatePostInstagramCubit>()
                                            .addUserTag(user);
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
                          onTap: () {
      ManageVibration.vibrate();
                            _focusNode.requestFocus();
                            isSearchClicked = true;
                            setState(() {});
                          },
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