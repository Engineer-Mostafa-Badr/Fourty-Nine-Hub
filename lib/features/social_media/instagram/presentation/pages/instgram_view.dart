import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/posts_instagram_cubit/posts_instagram_cubit.dart';
import '../cubit/reel_instagram_cubit/reel_instagram_cubit.dart';
import '../cubit/suggest_follow_cubit/suggest_follow_cubit.dart';
import '../widgets/instagram_view_body.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../../helpers/manage_vibration.dart';

class InstagramView extends StatelessWidget {
  final bool hideAppBar;

  const InstagramView(
      {super.key, this.hideAppBar = false}); // Default: show AppBar

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PostsInstagramCubit(
              serviceLocator(),
            )..loadPosts(context, refresh: true),
          ),
          BlocProvider(
            create: (context) =>
                serviceLocator<ReelInstagramCubit>()..getReels(),
          ),
          BlocProvider(
            create: (context) =>
                serviceLocator<SuggestFollowCubit>()..fetchSuggestFollow(),
          ),
        ],
        child: const InstagramViewBody(),
      ),
    );
  }
}

// class InstagramViewBody extends StatelessWidget {
//   const InstagramViewBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<PostsInstagramCubit, PostsInstagramState>(
//       builder: (context, state) {
//         if (state.status.isLoading) {
//           return const CustomLoading();
//         }

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTabBar(context),
//             // const SizedBox(height: 16),
//             // const StoresInstagramWidget(),
//             const SizedBox(
//               height: 82,
//               child: ChatStories(),
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             ListView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: state.posts.length,
//               itemBuilder: (context, index) {
//                 return PostImageInstagram(
//                   instagramPostEntity: state.posts[index],
//                   // isMenchan: false,
//                   // userImageUrl: testImage,
//                   // images: [
//                   //   testImage,
//                   //   testImage2,
//                   //   testImage,
//                   // ],
//                   // userName: 'Ruffles',
//                   // isReal: false,
//                   // country: 'New York, USA',
//                   // songName: 'Dance Monkey',
//                 );
//               },
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             const PostAdInstagram(
//               images: [testImage],
//               userImageUrl: testImage2,
//               userName: 'joshua_l',
//               isReal: false,
//               country: 'Sponsored',
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//             // const PostImageInstagram(
//             //   isMenchan: true,
//             //   userImageUrl: testImage,
//             //   images: [
//             //     testImage,
//             //     testImage2,
//             //     testImage,
//             //   ],
//             //   userName: 'Ruffles',
//             //   isReal: false,
//             //   country: 'New York, USA',
//             //   songName: 'Dance Monkey',
//             //   numberUserNamesMenchan: 2,
//             //   userNameMenchan: 'janegoodallinst',
//             //   userImageMenchan: testImage2,
//             // ),
//             const SizedBox(
//               height: 16,
//             ),
//             const SuggestReelsInstagramSection(
//               vediosSuggestReels: [
//                 testVideoUrl,
//                 testVideoUrl2,
//                 testVideoUrl3,
//                 testVideoUrl,
//                 testVideoUrl2,
//                 testVideoUrl3,
//               ],
//             ),
//             const Sizer(),
//             const InstagramAdSliderWidget(),
//             const Sizer(),
//             // const PostImageInstagram(
//             //   isMenchan: true,
//             //   images: [
//             //     testImage,
//             //     testImage2,
//             //   ],
//             //   isReal: false,
//             //   userImageUrl: testImage,
//             //   userName: 'joshua_l',
//             //   country: 'Tokyo, Japan',
//             // ),
//             const Sizer(),

//             const Sizer(),
//             const InstagramVideoPostWidget(),
//             const Sizer(),
//             const InstagramForYouSliderWidget(),
//             const Sizer(
//               height: 60,
//             ),
//             // Expanded(
//             //   child:
//             //       InstagramPosts(scrollController: scrollController),
//             // ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildTabBar(BuildContext context) {
//     final user = context.read<UserCubit>().state.data;
//     List<Map<String, String>> icons = [
//       {"Home": Assets.homeIcon},
//       {"Create": Assets.createIcon},
//       {"Profile": Assets.profile2Icon}
//     ];
//     int selectedIndex = 0;
//     return Container(
//       padding: const EdgeInsets.all(10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           ...List.generate(
//             icons.length,
//             (index) {
//               return Expanded(
//                 child: Container(
//                   // margin: const EdgeInsets.symmetric(horizontal: 18),
//                   // width: double.infinity,
//                   child: GestureDetector(
//                     onTap: () {
//                       // يقوم بنقلك لصفحة انشاء منشور او ريلز للانستقرام
//                       if (index == 1) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 const CreatePostInstagramView(),
//                           ),
//                         );
//                       }
//                       // يقوم بتحويلك لصفحة الملف الشخصي
//                       if (index == 2) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const ProfileInstagramView(),
//                           ),
//                         );
//                       }
//                       // setState(() {});
//                       log(selectedIndex.toString());
//                     },
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SvgPicture.asset(
//                               icons[index].values.first.toString(),
//                               colorFilter: ColorFilter.mode(
//                                   selectedIndex == index
//                                       ? const Color(0xFF0B1035)
//                                       : const Color(0xffD9D9D9),
//                                   BlendMode.srcIn),
//                             ),
//                             const SizedBox(
//                               width: 8,
//                             ),
//                             Label(
//                               text: icons[index].keys.first.toString(),
//                               style: Styles.headerText(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 32,
//                                 color: selectedIndex == index
//                                     ? const Color(0xFF0B1035)
//                                     : const Color(0xffD9D9D9),
//                               ),
//                             )
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 18,
//                         ),
//                         if (selectedIndex == index)
//                           Container(
//                             width: double.infinity,
//                             height: 2,
//                             color: const Color(0xff0B1035),
//                           )
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//       // child: Row(
//       //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//       //   children: List.generate(
//       //     3,
//       //     (i) => GestureDetector(
//       //       onTap: () {
//       //         if (i == 1) {
//       //           print(context.read<UserCubit>().token);
//       //           !context.read<UserCubit>().isTokenAttached
//       //               ? context.pushNamed(Routes.LOGIN)
//       //               : context.pushNamed(Routes.INSTAGRAMPROFILE, extra: user?.id);
//       //         }
//       //       },
//       //       child: Container(
//       //         decoration: i == 0
//       //             ? const BoxDecoration(
//       //                 border: Border(
//       //                   bottom: BorderSide(
//       //                       color: AppColors.PRIMARY_COLOR_DARK, width: 2),
//       //                 ),
//       //               )
//       //             : null,
//       //         child: Row(
//       //           children: [
//       //             Icon(
//       //               i == 0 ? Icons.home : Icons.person_pin,
//       //               color: i == 0
//       //                   ? context.isDarkMode
//       //                       ? AppColors.PRIMARY_COLOR_DARK
//       //                       : AppColors.PRIMARY_COLOR
//       //                   : Colors.grey,
//       //               size: 40.w,
//       //             ),
//       //             SizedBox(
//       //               width: 8.w,
//       //             ),
//       //             Label(
//       //               text: i == 0
//       //                   ? LocaleKeys.home.localize
//       //                   : LocaleKeys.profile.localize,
//       //               style: Styles.headerText(
//       //                   color: i == 0
//       //                       ? context.isDarkMode
//       //                           ? AppColors.PRIMARY_COLOR_DARK
//       //                           : AppColors.PRIMARY_COLOR
//       //                       : Colors.grey,
//       //                   fontSize: 30),
//       //             )
//       //           ],
//       //         ),
//       //       ),
//       //     ),
//       //   ),
//       // ),
//     );
//   }
// }
