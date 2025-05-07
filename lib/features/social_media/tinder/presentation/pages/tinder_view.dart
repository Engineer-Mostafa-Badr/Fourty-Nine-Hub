import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_card_stack.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class TinderView extends StatelessWidget {
  const TinderView({super.key});

  @override
  Widget build(BuildContext context) {
    log('TinderView built');
    return TinderScreen1(
      isMaleSelected:
          context.read<UserCubit>().state.data?.gender == 'male' ? false : true,
    );
    //   MultiBlocProvider(
    //   providers: [
    //     BlocProvider(create: (_) => serviceLocator<TinderViewCubit>()),
    //     BlocProvider(create: (_) => serviceLocator<ChatRoomCubit>()),
    //     BlocProvider(create: (_) => serviceLocator<UserCubit>()),
    //     BlocProvider(create: (_) => serviceLocator<ChatsCubit>()),
    //   ],
    //   child: TinderScreen1(
    //     isMaleSelected: context.read<UserCubit>().state.data?.gender == 'male'
    //         ? false
    //         : true,
    //   ),
    // );
  }
}

class TinderScreen1 extends StatefulWidget {
  const TinderScreen1({super.key, required this.isMaleSelected});

  final bool isMaleSelected; // Default state

  @override
  State<TinderScreen1> createState() => _TinderScreen1State();
}

class _TinderScreen1State extends State<TinderScreen1> {
  late final ScrollController _scrollController;

  bool? isMaleSelected;

  @override
  initState() {
    super.initState();
    isMaleSelected = widget.isMaleSelected;
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    // _initializeTinderData();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //
  // void _initializeTinderData() {
  //   final tinderCubit = context.read<TinderViewCubit>();
  //   tinderCubit
  //     ..fetchUserData(gender: isMaleSelected! ? 'female' : 'male', isLoggedIn: context.isUserLoggedIn, userId: context.isUserLoggedIn ? context.read<UserCubit>().state.data!.id : "")
  //     // ..fetchSubCategoryData()
  //     ..fetchFavorites();
  //   // ..fetchMainCategoryById(context,'62c8b5b09332225799fe335e');
  // }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(35),
          child: AppBar(
            leadingWidth: 200.w,
            leading: Row(
              children: [
                IconButton(
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -4),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back)),
                // const Sizer(),
                Text(
                  LocaleKeys.searchFind.tr(),
                  style: Styles.headerText(),
                ),
              ],
            ),
            title: ClickableWidget(
              onTap: ()=>context.push(Routes.FindMyProfileScreen),
                child: Image.asset(
              Assets.male_profile,
              width: 70.w,
            )),
            centerTitle: true,
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
                  color: context.isDarkMode
                      ? AppColors.whiteColor
                      : Colors.red, // Subtle background color
                ),
              ),
              IconButton(
                onPressed: () {
                  // setState(() {
                  //   isMaleSelected = !isMaleSelected!; // Toggle the state
                  //   final tinderCubit = context.read<TinderViewCubit>();
                  //   tinderCubit
                  //     ..fetchUserData(gender: isMaleSelected! ? 'female' : 'male', isLoggedIn: context.isUserLoggedIn, userId: context.isUserLoggedIn ? context.read<UserCubit>().state.data!.id : "")
                  //     // ..fetchSubCategoryData()
                  //     ..fetchFavorites();
                  // });
                },
                icon: Icon(
                  isMaleSelected!
                      ? FontAwesomeIcons.person
                      : FontAwesomeIcons.personDress,

                  color: context.isDarkMode
                      ? Colors.white
                      : Colors.red, // Optional styling
                ),
                visualDensity: const VisualDensity(
                    horizontal: -4, vertical: -4), // Tooltip for accessibility
              ),
            ],
          ),
        ),
        body: _buildLoggedInContent(
          context,
        )
        // BlocBuilder<TinderViewCubit, TinderViewState>(
        //   builder: (context, state) {
        //     if (state.status == TinderStates.success) {
        //       return _buildLoggedInContent(context, state);
        //     }
        //     return const Center(child: CircularProgressIndicator());
        //   },
        // ),
        );
  }

  Widget _buildLoggedInContent(
    BuildContext context,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: const Column(
          children: [
            const Sizer(),
            TinderCardStack()
            // if (state.userData0 != null && state.userData0!.isNotEmpty)
            //   const TinderCardStack()
            // else
            //   SizedBox(
            //     height: 1.sh,
            //     child: Shimmer.fromColors(
            //       baseColor: Colors.grey[100]!,
            //       highlightColor: Colors.white24,
            //       child: Container(
            //         decoration: BoxDecoration(
            //           color: AppColors.AUTH_CONTAINER_COLOR,
            //           borderRadius: BorderRadius.circular(5),
            //           border: Border.all(color: Colors.grey),
            //         ),
            //       ),
            //     ),
            //   ),
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
