import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_card_stack.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:shimmer/shimmer.dart';

class TinderView extends StatelessWidget {
  const TinderView({super.key});

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
      child: TinderScreen(
        isMaleSelected: context.read<UserCubit>().state.data?.gender == 'male'
            ? false
            : true,
      ),
    );
  }
}

class TinderScreen extends StatefulWidget {
  const TinderScreen({super.key, required this.isMaleSelected});
  final bool isMaleSelected; // Default state

  @override
  State<TinderScreen> createState() => _TinderScreenState();
}

class _TinderScreenState extends State<TinderScreen> {
  late final ScrollController _scrollController;

  bool? isMaleSelected;
  @override
  initState() {
    super.initState();
    isMaleSelected = widget.isMaleSelected;
  }

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
      ..fetchUserData(gender: isMaleSelected! ? 'female' : 'male', isLoggedIn: context.isUserLoggedIn, userId: context.isUserLoggedIn ? context.read<UserCubit>().state.data!.id : "")
      // ..fetchSubCategoryData()
      ..fetchFavorites();
    // ..fetchMainCategoryById(context,'62c8b5b09332225799fe335e');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.tinder_find.tr(),
        actions: [
          // The text behind the icon
          Text(
            isMaleSelected!
                ? context.isArabic
                    ? "ذكر"
                    : 'Male'
                : context.isArabic
                    ? "انثى"
                    : 'Female',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isMaleSelected!
                  ? AppColors.PRIMARY_COLOR
                  : AppColors.PRIMARY_COLOR_DARK, // Subtle background color
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isMaleSelected = !isMaleSelected!; // Toggle the state
                final tinderCubit = context.read<TinderViewCubit>();
                tinderCubit
                  ..fetchUserData(gender: isMaleSelected! ? 'female' : 'male', isLoggedIn: context.isUserLoggedIn, userId: context.isUserLoggedIn ? context.read<UserCubit>().state.data!.id : "")
                  // ..fetchSubCategoryData()
                  ..fetchFavorites();
              });
            },
            icon: Icon(
              isMaleSelected! ? Icons.male : Icons.female,
              size: 28,
              color: isMaleSelected!
                  ? AppColors.PRIMARY_COLOR
                  : AppColors.PRIMARY_COLOR_DARK, // Optional styling
            ),
            tooltip: isMaleSelected!
                ? 'Male'
                : 'Female', // Tooltip for accessibility
          ),
        ],
      ),
      body: BlocBuilder<TinderViewCubit, TinderViewState>(
        builder: (context, state) {
          if (state.status == TinderStates.success) {
            return _buildLoggedInContent(context, state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildLoggedInContent(BuildContext context, TinderViewState state) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            if (state.userData0 != null && state.userData0!.isNotEmpty)
              const TinderCardStack()
            else
              SizedBox(
                height: 1.sh,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[100]!,
                  highlightColor: Colors.white24,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.AUTH_CONTAINER_COLOR,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            // if (state.userData0 != null && state.userData0!.isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 8.0, bottom: 2),
            //     child: Divider(
            //       color: Colors.grey,
            //       height: 1.h,
            //       thickness: 1.h,
            //     ),
            //   ),
            // BlocBuilder<TinderViewCubit, TinderViewState>(
            //   builder: (context, state) {
            //     final controller = context.read<TinderViewCubit>();
            //     if(state.subCategoryData !=null && state.mainCategoryResponse !=null) {
            //       return Padding(
            //       padding: EdgeInsets.all(8.0.w),
            //       child: GridView.builder(
            //         physics: const NeverScrollableScrollPhysics(),
            //         shrinkWrap: true,
            //         itemCount: state.subCategoryData?.length ?? 0,
            //         controller: _scrollController,
            //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //           crossAxisCount: 3,
            //           childAspectRatio: 1,
            //         ),
            //         itemBuilder: (context, index) => SubcategoryCardTinder(
            //           mainCategory: state.mainCategoryResponse!,
            //           item: state.subCategoryData![index],
            //           onFav: () async {
            //             var result = await controller.toggleSubCategoryToFavorites(
            //               state.subCategoryData![index].id,
            //             );
            //             return result;
            //           },
            //         ),
            //       ),
            //     );
            //     }
            //     return const Center(child: CircularProgressIndicator());
            //   },
            // ),
            // SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
