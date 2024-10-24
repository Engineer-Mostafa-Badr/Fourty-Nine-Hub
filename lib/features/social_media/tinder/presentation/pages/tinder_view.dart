//
// import 'dart:developer';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
// import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_card_stack.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
//
// const kToolbarHeightFactor = 0.80;
// const kDefaultPadding = 8.0;
//
// class TinderView extends StatelessWidget {
//   const TinderView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     log('TinderView built');
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => serviceLocator<TinderViewCubit>()),
//         BlocProvider(create: (_) => serviceLocator<ChatRoomCubit>()),
//         BlocProvider(create: (_) => serviceLocator<UserCubit>()),
//         BlocProvider(create: (_) => serviceLocator<ChatsCubit>()),
//       ],
//       child: const TinderScreen(),
//     );
//   }
// }
//
// class TinderScreen extends StatefulWidget {
//   const TinderScreen({super.key});
//
//   @override
//   State<TinderScreen> createState() => _TinderScreenState();
// }
//
// class _TinderScreenState extends State<TinderScreen> {
//   late ScrollController _scrollController;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//
//     _initializeTinderData();
//   }
//
//   void _initializeTinderData() {
//     final tinderCubit = context.read<TinderViewCubit>();
//     tinderCubit
//       ..fetchUserData(gender: 'female')
//       ..fetchSubCategoryData()
//       ..fetchFavorites()
//       ..fetchMainCategoryById('62c8b5b09332225799fe335e');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     log('TinderScreen built');
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 4,
//         title: Label(
//           text: LocaleKeys.tinder_find.tr(),
//           style: Styles.headerText(
//             fontSize: MediaQuery.of(context).size.width * 0.1,
//           ),
//         ),
//       ),
//       body: BlocConsumer<TinderViewCubit, TinderViewState>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           if (state.userData.isEmpty &&
//               state.subCategoryData.isEmpty &&
//               state.mainCategoryResponse == null) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (!serviceLocator<UserCubit>().isLoggedIn) {
//             return pleaseLoginWidget(context);
//           }
//           return _buildLoggedInContent(context, state);
//         },
//       ),
//     );
//   }
//
//   Widget _buildLoggedInContent(BuildContext context, TinderViewState state) {
//     return Container(
// //000000000000
//       color: Theme.of(context).scaffoldBackgroundColor,
//       child: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             const Sizer(),
//             // _buildHeader(),
//             state.userData.isNotEmpty
//                 ? const TinderCardStack()
//                 : Container(
//                     height: 0.55.sh,
//                     child: const Center(
//                       child: Text('Empty User List'),
//                     ),
//                   ),
//             if (state.userData.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0, bottom: 2),
//                 child: Divider(
//                   color: Colors.grey,
//                   height: 1.h,
//                   thickness: 1.h,
//                 ),
//               ),
//             _buildSubCategoryList(state),
//             SizedBox(height: 50.h),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
//       child: Align(
//         alignment: context.isArabic ? Alignment.topRight : Alignment.topLeft,
//         child: Label(
//           text: LocaleKeys.tinder_find.tr(),
//           style: Styles.headerText(
//             fontSize: MediaQuery.of(context).size.width * 0.1,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSubCategoryList(TinderViewState state) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 4.0),
//           child: InkWell(
//             onTap: () {
//               // Scroll to a specific pixel position
//               _scrollController.animateTo(
//                 context.isArabic
//                     ? _scrollController.position.pixels - 0.8.sw
//                     : _scrollController.position.pixels + 0.8.sw,
//                 // Pixel offset to scroll to
//                 duration: const Duration(seconds: 1),
//                 curve: Curves.easeInOut,
//               );
//             },
//             child: Row(
//               children: [
//                 const Spacer(),
//                 Text(
//                   context.isArabic ? 'عرض المزيد' : 'More',
//                   style: const TextStyle(
//                       color: AppColors.PRIMARY_COLOR_DARK,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   color: AppColors.PRIMARY_COLOR_DARK,
//                   size: 0.06.sw,
//                 ),
//                 const Sizer()
//               ],
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 0.3.sh,
//           child: ListView.separated(
//             controller: _scrollController,
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             scrollDirection: Axis.horizontal,
//             reverse: context.isArabic ? true : false,
//             itemCount: state.subCategoryData.length,
//             separatorBuilder: (context, index) => const SizedBox(width: 0),
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.all(2.0),
//                 child: TinderSubCategoryCard(
//                   subCategoryCardData: state.subCategoryData[index],
//                   index: index,
//                   mainCategory: state.mainCategoryResponse!.data.mainCategory,
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// // Widget _buildSubCategoryList(TinderViewState state) {
// //   return SizedBox(
// //     height: 380.h,
// //     child: ListView.separated(
// //       padding: const EdgeInsets.symmetric(horizontal: 4),
// //       scrollDirection: Axis.horizontal,
// //       itemCount: state.subCategoryData.length,
// //       separatorBuilder: (context, index) => const SizedBox(width: 0),
// //       itemBuilder: (context, index) {
// //         return Padding(
// //           padding: const EdgeInsets.all(2.0),
// //           child: TinderSubCategoryCard(
// //             subCategoryCardData: state.subCategoryData[index],
// //             index: index,
// //             mainCategory: state.mainCategoryResponse!.data.mainCategory,
// //           ),
// //         );
// //       },
// //     ),
// //   );
// // }
// }
// //00000000

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_card_stack.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class TinderView extends StatelessWidget {
  const TinderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('TinderView built');
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<TinderViewCubit>()),
        BlocProvider(create: (_) => serviceLocator<ChatRoomCubit>()),
        BlocProvider(create: (_) => serviceLocator<UserCubit>()),
        BlocProvider(create: (_) => serviceLocator<ChatsCubit>()),
      ],
      child: const TinderScreen(),
    );
  }
}

class TinderScreen extends StatefulWidget {
  const TinderScreen({Key? key}) : super(key: key);

  @override
  State<TinderScreen> createState() => _TinderScreenState();
}

class _TinderScreenState extends State<TinderScreen> {
  late final ScrollController _scrollController;

  @override
  void didChangeDependencies() {
    _scrollController = ScrollController();
    _initializeTinderData();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeTinderData() {
    final tinderCubit = context.read<TinderViewCubit>();
    tinderCubit
      ..fetchUserData(gender: 'female')
      ..fetchSubCategoryData()
      ..fetchFavorites()
      ..fetchMainCategoryById(context,'62c8b5b09332225799fe335e');
  }

  @override
  Widget build(BuildContext context) {
    log('TinderScreen built');
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 4,
      //   title: Text(
      //     LocaleKeys.tinder_find.tr(),
      //     style: Styles.headerText(),
      //   ),
      // ),
      appBar: BackAppBar(
        label: LocaleKeys.tinder_find.tr(),
      ),
      body: BlocConsumer<TinderViewCubit, TinderViewState>(
        listener: (context, state) {
          // Handle any state changes if necessary
        },
        builder: (context, state) {
          // if (!context.read<UserCubit>().isLoggedIn) {
          //   // Prompt user to log in if not authenticated
          //   return _buildPleaseLoginWidget(context);
          // }

          return _buildLoggedInContent(context, state);
        },
      ),
    );
  }

  Widget _buildLoggedInContent(BuildContext context, TinderViewState state) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // _buildHeader(),
            state.userData!.isNotEmpty
                ? const TinderCardStack()
                : SizedBox(
                    height: 0.55.sh,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100]!,
                      highlightColor: Colors.white24,
                      child: Container(
                        // height: MediaQuery.sizeOf(context).height * 0.08,
                        decoration: BoxDecoration(
                          color: AppColors.AUTH_CONTAINER_COLOR,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
            if (state.userData!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 2),
                child: Divider(
                  color: Colors.grey,
                  height: 1.h,
                  thickness: 1.h,
                ),
              ),
            state.subCategoryData!.isNotEmpty
                ? _buildSubCategoryList(context, state)
                : SizedBox(
                    height: 0.3.sh,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[100]!,
                      highlightColor: Colors.white24,
                      child: Container(
                        // height: MediaQuery.sizeOf(context).height * 0.08,
                        decoration: BoxDecoration(
                          color: AppColors.AUTH_CONTAINER_COLOR,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Align(
        alignment: context.isArabic ? Alignment.topRight : Alignment.topLeft,
        child: Text(
          LocaleKeys.tinder_find.tr(),
          style: Styles.headerText(),
        ),
      ),
    );
  }

  Widget _buildSubCategoryList(BuildContext context, TinderViewState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: InkWell(
            onTap: () {
              // Scroll to the next set of subcategories
              final offset = context.isArabic
                  ? _scrollController.position.pixels - 0.8.sw
                  : _scrollController.position.pixels + 0.8.sw;
              _scrollController.animateTo(
                offset,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              );
            },
            child: Row(
              children: [
                const Spacer(),
                Text(
                  LocaleKeys.more.tr(),
                  style: const TextStyle(
                    color: AppColors.PRIMARY_COLOR_DARK,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.PRIMARY_COLOR_DARK,
                  size: 0.06.sw,
                ),
                const SizedBox(width: 8.0),
              ],
            ),
          ),
        ),
        BlocBuilder<TinderViewCubit, TinderViewState>(
          builder: (context, state) {
            return SizedBox(
              height: 0.3.sh,
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                scrollDirection: Axis.horizontal,
                reverse: context.isArabic,
                itemCount: state.subCategoryData!.length,
                separatorBuilder: (context, index) => const SizedBox(width: 0),
                itemBuilder: (context, index) {
                  final subCategory = state.subCategoryData![index];

                  return state.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: TinderSubCategoryCard(
                            subCategoryCardData: subCategory,
                            index: index,
                            mainCategory: state.mainCategoryResponse!,
                          ),
                        );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPleaseLoginWidget(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          context.push(Routes.LOGIN);
        },
        child: Text(
          LocaleKeys.pleaseLoginRegisterToEnjoyTheApp.tr(),
          style: Styles.headerText(),
        ),
      ),
    );
  }
}
