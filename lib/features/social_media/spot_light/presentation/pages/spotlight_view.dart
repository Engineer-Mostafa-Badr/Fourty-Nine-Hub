// // // import 'package:flutter/cupertino.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/widgets.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// // // import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
// // // import 'package:fourtyninehub/res/assets/assets.dart';
// // // import 'package:fourtyninehub/res/style/const.dart';
// // //
// // // import '../../../../../service_locator/service_locator.dart';
// // // import '../../../reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
// // // import '../../../reels/presentation/pages/audio_screen.dart';
// // // import '../../../stories/presentation/cubit/stories_cubit.dart';
// // //
// // // class SpotlightView extends StatefulWidget {
// // //   const SpotlightView({super.key});
// // //
// // //   @override
// // //   State<SpotlightView> createState() => _SpotlightViewState();
// // // }
// // //
// // // class _SpotlightViewState extends State<SpotlightView> {
// // //   @override
// // //   void initState() {
// // //     // TODO: implement initState
// // //     super.initState();
// // //   }
// // //
// // //   void _fetchInitialReels() {
// // //     if (mounted) {
// // //       context.read<ReelsCubit>().fetchReels();
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.white,
// // //         elevation: 2,
// // //         leading: Padding(
// // //           padding: EdgeInsets.symmetric(horizontal: 8.0),
// // //           child: CircleAvatar(
// // //             backgroundColor: Colors.grey[300],
// // //             child: const Icon(
// // //               Icons.person,
// // //               color: Colors.red,
// // //             ),
// // //           ),
// // //         ),
// // //         title: const Center(
// // //           child: Text(
// // //             'Stories',
// // //             textScaler: TextScaler.noScaling,
// // //             style: TextStyle(fontWeight: FontWeight.bold),
// // //           ),
// // //         ),
// // //         actions: [
// // //           Stack(
// // //             children: [
// // //               IconButton(
// // //                 icon: CircleAvatar(
// // //                   backgroundColor: Colors.grey[300],
// // //                   child: const Icon(
// // //                     Icons.group_add,
// // //                     color: Colors.black,
// // //                   ),
// // //                 ),
// // //                 onPressed: () {},
// // //               ),
// // //               const Positioned(
// // //                 right: 6,
// // //                 top: 6,
// // //                 child: CircleAvatar(
// // //                   radius: 8,
// // //                   backgroundColor: Colors.red,
// // //                   child: Text(
// // //                     '8',
// // //                     style: TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 10.sp,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           IconButton(
// // //             icon: CircleAvatar(
// // //               backgroundColor: Colors.grey[300],
// // //               child: const Icon(
// // //                 Icons.more_horiz,
// // //                 color: Colors.black,
// // //               ),
// // //             ),
// // //             onPressed: () {},
// // //           ),
// // //         ],
// // //       ),
// // //       body: SingleChildScrollView(
// // //         physics: const BouncingScrollPhysics(),
// // //         child: Column(
// // //           // physics: const BouncingScrollPhysics(),
// // //           // shrinkWrap: true,
// // //           children: [
// // //             // StorySection(),
// // //             FriendsList(),
// // //             Sizer(),
// // //             FollowingSection(),
// // //             Sizer(),
// // //             DiscoverSection(),
// // //             // DiscoverSection(),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // class StorySection extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       height: kToolbarHeight * 2,
// // //       child: BlocProvider(
// // //         create: (context) => serviceLocator<StoryCubit>()..fetchStories(),
// // //         child: const ChatStories(),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // class FriendsList extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return SizedBox(
// // //       width: double.infinity,
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           const Padding(
// // //             padding: EdgeInsets.all(8.0),
// // //             child: Text(
// // //               'Friends',
// // //               textScaler: TextScaler.noScaling,
// // //               style: TextStyle(fontWeight: FontWeight.bold),
// // //             ),
// // //           ),
// // //           Container(
// // //             height: kToolbarHeight * 2,
// // //             child: const ChatStories(),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // class FollowingSection extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         const Padding(
// // //           padding: EdgeInsets.all(8.0),
// // //           child: Text(
// // //             'Following',
// // //             textScaler: TextScaler.noScaling,
// // //             style: TextStyle(fontWeight: FontWeight.bold),
// // //           ),
// // //         ),
// // //         Container(
// // //           height: 200.h,
// // //           child: ListView.builder(
// // //             physics: const BouncingScrollPhysics(),
// // //             scrollDirection: Axis.horizontal,
// // //             itemCount: 20, // Adjust based on your data
// // //             itemBuilder: (context, index) {
// // //               return Padding(
// // //                 padding: EdgeInsets.all(8.0),
// // //                 child: Container(
// // //                   width: 100,
// // //                   decoration: BoxDecoration(
// // //                     image: const DecorationImage(
// // //                       image: NetworkImage(UIConst.profilePlaceHolder),
// // //                       fit: BoxFit.cover,
// // //                     ),
// // //                     borderRadius: BorderRadius.circular(10),
// // //                   ),
// // //                   child: Stack(
// // //                     children: [
// // //                       Positioned(
// // //                         bottom: 8,
// // //                         left: 8,
// // //                         child: Text('Mostafa $index',
// // //                             style: const TextStyle(color: Colors.black87)),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               );
// // //             },
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }
// // //
// // // class DiscoverSection extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     context.read<ReelsCubit>().fetchReels();
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         const Padding(
// // //           padding: EdgeInsets.all(8.0),
// // //           child: Text(
// // //             'Discover',
// // //             textScaler: TextScaler.noScaling,
// // //             style: TextStyle(fontWeight: FontWeight.bold),
// // //           ),
// // //         ),
// // //         Container(
// // //           // color: Colors.grey,
// // //           height: MediaQuery.of(context).size.width * 0.7,
// // //
// // //           child: BlocConsumer<ReelsCubit, ReelsState>(
// // //             listener: (context, state) {
// // //               // TODO: implement listener
// // //             },
// // //             builder: (context, state) {
// // //               return ListView.builder(
// // //                 physics: const BouncingScrollPhysics(),
// // //                 scrollDirection: Axis.horizontal,
// // //                 // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // //                 //   crossAxisCount: 2,
// // //                 //   childAspectRatio: 0.6,
// // //                 //   mainAxisSpacing: 4,
// // //                 //   crossAxisSpacing: 4,
// // //                 // ),
// // //                 itemCount: state.reels!.length,
// // //                 itemBuilder: (context, index) {
// // //                   return SizedBox(
// // //                     width: MediaQuery.of(context).size.width / 2.5,
// // //                     child: Padding(
// // //                       padding: EdgeInsets.symmetric(
// // //                           horizontal: 4.0, vertical: 12.h),
// // //                       child: Card(
// // //                         elevation: 8,
// // //                         clipBehavior: Clip.hardEdge,
// // //                         child: GestureDetector(
// // //                           onTap: () {
// // //                             // reelCubit.updatePlayingIndex(index);
// // //                             Navigator.push(
// // //                                 context,
// // //                                 MaterialPageRoute(
// // //                                   builder: (context) => BlocProvider.value(
// // //                                     value: serviceLocator<ReelsCubit>(),
// // //                                     child: ReelItemFromAudio(
// // //                                       key: ValueKey(state.reels![index].id),
// // //                                       reel: state.reels![index],
// // //                                       isVisible: true,
// // //                                     ),
// // //                                   ),
// // //                                 ));
// // //                           },
// // //                           child: Stack(
// // //                             children: [
// // //                               Image.network(
// // //                                 width: double.infinity,
// // //                                 height: double.infinity,
// // //                                 state.reels![index].thumbnailSignedUrl,
// // //                                 errorBuilder: (context, error, stackTrace) =>
// // //                                     const Center(
// // //                                   child: CupertinoActivityIndicator(
// // //                                     color: Colors.white,
// // //                                   ),
// // //                                 ),
// // //                                 fit: BoxFit.cover,
// // //                               ),
// // //                               Positioned(
// // //                                 bottom: 8,
// // //                                 left: 2,
// // //                                 child: Row(
// // //                                   children: [
// // //                                     const Icon(Icons.play_arrow,
// // //                                         color: Colors.white, size: 16),
// // //                                     SizedBox(width: 4),
// // //                                     Text(
// // //                                       state.reels![index].viewCount.toString(),
// // //                                       style:
// // //                                           const TextStyle(color: Colors.white),
// // //                                     ),
// // //                                   ],
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   );
// // //                 },
// // //               );
// // //             },
// // //           ),
// // //         )
// // //
// // //         // GridView.builder(
// // //         //   shrinkWrap: true,
// // //         //   physics: const NeverScrollableScrollPhysics(),
// // //         //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // //         //     crossAxisCount: 2,
// // //         //     childAspectRatio: 1,
// // //         //   ),
// // //         //   itemCount: 10,
// // //         //   // Adjust based on your data
// // //         //   itemBuilder: (context, index) {
// // //         //     return Padding(
// // //         //       padding: EdgeInsets.all(8.0),
// // //         //       child: Container(
// // //         //         decoration: BoxDecoration(
// // //         //           image: const DecorationImage(
// // //         //             image: NetworkImage(UIConst.profilePlaceHolder),
// // //         //             fit: BoxFit.cover,
// // //         //           ),
// // //         //           borderRadius: BorderRadius.circular(10),
// // //         //         ),
// // //         //       ),
// // //         //     );
// // //         //   },
// // //         // ),
// // //       ],
// // //     );
// // //   }
// // // }
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// // import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// // import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
// // import 'package:fourtyninehub/res/assets/assets.dart';
// // import 'package:fourtyninehub/res/style/const.dart';
// // import 'package:go_router/go_router.dart';
// //
// // import '../../../../../routes/routes.dart';
// // import '../../../../../service_locator/service_locator.dart';
// // import '../../../reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
// // import '../../../reels/presentation/pages/audio_screen.dart';
// // import '../../../stories/presentation/cubit/stories_cubit.dart';
// //
// // class SpotlightView extends StatefulWidget {
// //   const SpotlightView({super.key});
// //
// //   @override
// //   State<SpotlightView> createState() => _SpotlightViewState();
// // }
// //
// // class _SpotlightViewState extends State<SpotlightView> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchInitialReels();
// //   }
// //
// //   void _fetchInitialReels() {
// //     if (mounted) {
// //       // context.read<ReelsCubit>().fetchReels();
// //       context.read<StoryCubit>().fetchStories();
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         elevation: 2,
// //         leading: IconButton(
// //           onPressed: () {
// //             context.push(Routes.OTHERSACCOUNT,
// //                 extra: serviceLocator<UserCubit>().state.data!.id);
// //           },
// //           icon: Padding(
// //             padding: EdgeInsets.symmetric(horizontal: 8.0),
// //             child: CircleAvatar(
// //               backgroundColor: Colors.grey[300],
// //               child: const Icon(
// //                 Icons.person,
// //                 color: Colors.red,
// //               ),
// //             ),
// //           ),
// //         ),
// //         title: const Center(
// //           child: Text(
// //             'Stories',
// //             textScaler: TextScaler.noScaling,
// //             style: TextStyle(fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //         actions: [
// //           Stack(
// //             children: [
// //               IconButton(
// //                 icon: CircleAvatar(
// //                   backgroundColor: Colors.grey[300],
// //                   child: const Icon(
// //                     Icons.group_add,
// //                     color: Colors.black,
// //                   ),
// //                 ),
// //                 onPressed: () {},
// //               ),
// //               const Positioned(
// //                 right: 6,
// //                 top: 6,
// //                 child: CircleAvatar(
// //                   radius: 8,
// //                   backgroundColor: Colors.red,
// //                   child: Text(
// //                     '8',
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 10.sp,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           IconButton(
// //             icon: CircleAvatar(
// //               backgroundColor: Colors.grey[300],
// //               child: const Icon(
// //                 Icons.more_horiz,
// //                 color: Colors.black,
// //               ),
// //             ),
// //             onPressed: () {},
// //           ),
// //         ],
// //       ),
// //       body: serviceLocator<UserCubit>().isLoggedIn
// //           ?  const SingleChildScrollView(
// //               physics: BouncingScrollPhysics(),
// //               child: Column(
// //                 children: [
// //                   FriendsList(),
// //                   Sizer(),
// //                   FollowingSection(),
// //                   Sizer(),
// //                   DiscoverSection(),
// //                   Sizer(
// //                     height: 100.h,
// //                   )
// //                 ],
// //               ),
// //             )
// //           : const Center(
// //               child: CupertinoActivityIndicator(),
// //             ),
// //     );
// //   }
// // }
// //
// // class FriendsList extends StatelessWidget {
// //   const FriendsList({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       width: double.infinity,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Padding(
// //             padding: EdgeInsets.all(8.0),
// //             child: Text(
// //               'Friends',
// //               textScaler: TextScaler.noScaling,
// //               style: TextStyle(fontWeight: FontWeight.bold),
// //             ),
// //           ),
// //           ChatStories(),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class FollowingSection extends StatelessWidget {
// //   const FollowingSection({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Padding(
// //           padding: EdgeInsets.all(8.0),
// //           child: Text(
// //             'Following',
// //             textScaler: TextScaler.noScaling,
// //             style: TextStyle(fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //         SizedBox(
// //           height: MediaQuery.of(context).size.width * 0.7,
// //           child: BlocConsumer<ReelsCubit, ReelsState>(
// //             listener: (context, state) {},
// //             builder: (context, state) {
// //               if (state.reels.isEmpty) {
// //                 return const Center(child: CupertinoActivityIndicator());
// //               }
// //               return ListView.builder(
// //                 physics: const BouncingScrollPhysics(),
// //                 scrollDirection: Axis.horizontal,
// //                 itemCount: state.reels.length,
// //                 itemBuilder: (context, index) {
// //                   return SizedBox(
// //                     width: MediaQuery.of(context).size.width / 2.5,
// //                     child: Padding(
// //                       padding: EdgeInsets.symmetric(
// //                           horizontal: 4.0, vertical: 12.h),
// //                       child: Card(
// //                         elevation: 8,
// //                         clipBehavior: Clip.hardEdge,
// //                         child: GestureDetector(
// //                           onTap: () async {
// //                             await Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) => BlocProvider.value(
// //                                   value: serviceLocator<ReelsCubit>(),
// //                                   child: ReelItemFromAudio(
// //                                     key: ValueKey(state.reels![index].id),
// //                                     reel: state.reels![index],
// //                                     isVisible: true,
// //                                   ),
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                           child: Stack(
// //                             children: [
// //                               Image.network(
// //                                 state.reels![index].thumbnailSignedUrl,
// //                                 width: double.infinity,
// //                                 height: double.infinity,
// //                                 fit: BoxFit.cover,
// //                                 errorBuilder: (context, error, stackTrace) =>
// //                                 const Center(
// //                                   child: CupertinoActivityIndicator(),
// //                                 ),
// //                               ),
// //                               Positioned(
// //                                 bottom: 8,
// //                                 left: 2,
// //                                 child: Row(
// //                                   children: [
// //                                     const Icon(
// //                                       Icons.play_arrow,
// //                                       color: Colors.white,
// //                                       size: 16,
// //                                     ),
// //                                     SizedBox(width: 4),
// //                                     Text(
// //                                       state.reels![index].viewCount.toString(),
// //                                       style:
// //                                       const TextStyle(color: Colors.white),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               );
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// //
// //
// // class DiscoverSection extends StatefulWidget {
// //   const DiscoverSection({super.key});
// //
// //   @override
// //   _DiscoverSectionState createState() => _DiscoverSectionState();
// // }
// //
// // class _DiscoverSectionState extends State<DiscoverSection> {
// //   final ScrollController _scrollController = ScrollController();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Initial data fetch
// //     context.read<ReelsCubit>().fetchReels();
// //
// //     // Add scroll listener for pagination
// //     _scrollController.addListener(_onScroll);
// //   }
// //
// //   void _onScroll() {
// //     if (_scrollController.position.pixels ==
// //         _scrollController.position.maxScrollExtent) {
// //       // Fetch more reels when user reaches the bottom of the list
// //       context.read<ReelsCubit>().fetchReels();
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     _scrollController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Padding(
// //           padding: EdgeInsets.all(8.0),
// //           child: Text(
// //             'Discover',
// //             textScaler: TextScaler.noScaling, // Adjusted for text scale factor
// //             style: TextStyle(fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //         SizedBox(
// //           height: MediaQuery.of(context).size.width * 0.7,
// //           child: BlocConsumer<ReelsCubit, ReelsState>(
// //             listener: (context, state) {},
// //             builder: (context, state) {
// //               if (state.reels.isEmpty && !state.isLoading) {
// //                 return const Center(child: CupertinoActivityIndicator());
// //               }
// //
// //               return GridView.builder(
// //                 shrinkWrap: true,
// //                 controller: _scrollController,
// //                 physics: const BouncingScrollPhysics(),
// //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //                   crossAxisCount: 2, // 2 items per row
// //                   mainAxisSpacing: 8,
// //                   crossAxisSpacing: 8,
// //                   childAspectRatio: 0.7, // Adjust to make the items taller
// //                 ),
// //                 itemCount: state.reels.length + (state.hasReachedMax ? 0 : 1), // Add 1 for pagination loading indicator
// //                 itemBuilder: (context, index) {
// //                   if (index >= state.reels.length) {
// //                     return const Center(child: CupertinoActivityIndicator());
// //                   }
// //
// //                   return GestureDetector(
// //                     onTap: () async {
// //                       await Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) => BlocProvider.value(
// //                             value: serviceLocator<ReelsCubit>(),
// //                             child: ReelItemFromAudio(
// //                               key: ValueKey(state.reels![index].id),
// //                               reel: state.reels![index],
// //                               isVisible: true,
// //                             ),
// //                           ),
// //                         ),
// //                       );
// //                     },
// //                     child: Card(
// //                       elevation: 8,
// //                       clipBehavior: Clip.hardEdge,
// //                       child: Stack(
// //                         children: [
// //                           Image.network(
// //                             state.reels![index].thumbnailSignedUrl,
// //                             width: double.infinity,
// //                             height: double.infinity,
// //                             fit: BoxFit.cover,
// //                             errorBuilder: (context, error, stackTrace) =>
// //                             const Center(
// //                               child: CupertinoActivityIndicator(),
// //                             ),
// //                           ),
// //                           Positioned(
// //                             bottom: 8,
// //                             left: 2,
// //                             child: Row(
// //                               children: [
// //                                 const Icon(
// //                                   Icons.play_arrow,
// //                                   color: Colors.white,
// //                                   size: 16,
// //                                 ),
// //                                 SizedBox(width: 4),
// //                                 Text(
// //                                   state.reels![index].viewCount.toString(),
// //                                   style: const TextStyle(color: Colors.white),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               );
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
// import 'package:fourtyninehub/res/assets/assets.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../../../routes/routes.dart';
// import '../../../../../service_locator/service_locator.dart';
// import '../../../reels/data/models/new_reels_model.dart';
// import '../../../reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
// import '../../../reels/presentation/pages/audio_screen.dart';
// import '../../../stories/presentation/cubit/stories_cubit.dart';
//
// class SpotlightView extends StatefulWidget {
//   const SpotlightView({super.key});
//
//   @override
//   State<SpotlightView> createState() => _SpotlightViewState();
// }
//
// class _SpotlightViewState extends State<SpotlightView> {
//   @override
//   void initState() {
//     super.initState();
//     _fetchInitialData();
//   }
//
//   void _fetchInitialData() {
//     if (mounted) {
//       context.read<StoryCubit>().fetchStories();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(context),
//       body: serviceLocator<UserCubit>().isLoggedIn
//           ? const SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             FriendsList(),
//             Sizer(),
//             FollowingSection(),
//             Sizer(),
//             DiscoverSection(),
//             Sizer(height: 100.h),
//           ],
//         ),
//       )
//           : const Center(
//         child: CupertinoActivityIndicator(),
//       ),
//     );
//   }
//
//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 2,
//       leading: IconButton(
//         onPressed: () {
//           context.push(
//             Routes.OTHERSACCOUNT,
//             extra: serviceLocator<UserCubit>().state.data!.id,
//           );
//         },
//         icon: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8.0),
//           child: CircleAvatar(
//             backgroundColor: Colors.grey[300],
//             child: const Icon(
//               Icons.person,
//               color: Colors.red,
//             ),
//           ),
//         ),
//       ),
//       title: const Center(
//         child: Text(
//           'Stories',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
//         ),
//       ),
//       actions: [
//         _buildActionIcons(),
//         IconButton(
//           icon: CircleAvatar(
//             backgroundColor: Colors.grey[300],
//             child: const Icon(
//               Icons.more_horiz,
//               color: Colors.black,
//             ),
//           ),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionIcons() {
//     return Stack(
//       children: [
//         IconButton(
//           icon: CircleAvatar(
//             backgroundColor: Colors.grey[300],
//             child: const Icon(
//               Icons.group_add,
//               color: Colors.black,
//             ),
//           ),
//           onPressed: () {},
//         ),
//         const Positioned(
//           right: 6,
//           top: 6,
//           child: CircleAvatar(
//             radius: 8,
//             backgroundColor: Colors.red,
//             child: Text(
//               '8',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 10.sp,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class FriendsList extends StatelessWidget {
//   const FriendsList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Friends',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
//             ),
//           ),
//           ChatStories(),
//         ],
//       ),
//     );
//   }
// }
//
// class FollowingSection extends StatelessWidget {
//   const FollowingSection({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Text(
//             'Following',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
//           ),
//         ),
//         SizedBox(
//           height: MediaQuery.of(context).size.width * 0.7,
//           child: BlocConsumer<ReelsCubit, ReelsState>(
//             listener: (context, state) {},
//             builder: (context, state) {
//               if (state.reels.isEmpty) {
//                 return const Center(child: CupertinoActivityIndicator());
//               }
//               return ListView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 scrollDirection: Axis.horizontal,
//                 itemCount: state.reels.length,
//                 itemBuilder: (context, index) {
//                   return SizedBox(
//                     width: MediaQuery.of(context).size.width / 2.5,
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 4.0, vertical: 12.h),
//                       child: _buildReelCard(context, state.reels[index]),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildReelCard(BuildContext context, Reel reel) {
//     return GestureDetector(
//       onTap: () async {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BlocProvider.value(
//               value: serviceLocator<ReelsCubit>(),
//               child: ReelItemFromAudio(
//                 key: ValueKey(reel.id),
//                 reel: reel,
//                 isVisible: true,
//               ),
//             ),
//           ),
//         );
//       },
//       child: Card(
//         elevation: 8,
//         clipBehavior: Clip.hardEdge,
//         child: Stack(
//           children: [
//             Image.network(
//               reel.thumbnailSignedUrl,
//               width: double.infinity,
//               height: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) =>
//               const Center(child: CupertinoActivityIndicator()),
//             ),
//             Positioned(
//               bottom: 8,
//               left: 2,
//               child: Row(
//                 children: [
//                   const Icon(
//                     Icons.play_arrow,
//                     color: Colors.white,
//                     size: 16,
//                   ),
//                   SizedBox(width: 4),
//                   Text(
//                     reel.viewCount.toString(),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class DiscoverSection extends StatefulWidget {
//   const DiscoverSection({super.key});
//
//   @override
//   _DiscoverSectionState createState() => _DiscoverSectionState();
// }
//
// class _DiscoverSectionState extends State<DiscoverSection> {
//   final ScrollController _scrollController = ScrollController();
//   bool _isFetchingMore = false;
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<ReelsCubit>().fetchReels();
//     _scrollController.addListener(_onScroll);
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200 &&
//         !_isFetchingMore) {
//       _fetchMoreReels();
//     }
//   }
//
//   void _fetchMoreReels() async {
//     setState(() {
//       _isFetchingMore = true;
//     });
//     await context.read<ReelsCubit>().fetchReels();
//     setState(() {
//       _isFetchingMore = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Text(
//             'Discover',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
//           ),
//         ),
//         SizedBox(
//           height: MediaQuery.of(context).size.width * 0.7,
//           child: BlocConsumer<ReelsCubit, ReelsState>(
//             listener: (context, state) {},
//             builder: (context, state) {
//               if (state.reels.isEmpty && !state.isLoading) {
//                 return const Center(child: CupertinoActivityIndicator());
//               }
//
//               return NotificationListener<ScrollNotification>(
//                 onNotification: (ScrollNotification scrollInfo) {
//                   if (scrollInfo.metrics.pixels ==
//                       scrollInfo.metrics.maxScrollExtent &&
//                       !_isFetchingMore) {
//                     _fetchMoreReels();
//                   }
//                   return true;
//                 },
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   controller: _scrollController,
//                   physics: const BouncingScrollPhysics(),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 8,
//                     crossAxisSpacing: 8,
//                     childAspectRatio: 0.7,
//                   ),
//                   itemCount: state.reels.length + (_isFetchingMore ? 1 : 0),
//                   itemBuilder: (context, index) {
//                     if (index == state.reels.length && _isFetchingMore) {
//                       return const Center(child: CupertinoActivityIndicator());
//                     }
//                     return _buildReelCard(context, state.reels[index]);
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildReelCard(BuildContext context, Reel reel) {
//     return GestureDetector(
//       onTap: () async {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BlocProvider.value(
//               value: serviceLocator<ReelsCubit>(),
//               child: ReelItemFromAudio(
//                 key: ValueKey(reel.id),
//                 reel: reel,
//                 isVisible: true,
//               ),
//             ),
//           ),
//         );
//       },
//       child: Card(
//         elevation: 8,
//         clipBehavior: Clip.hardEdge,
//         child: Stack(
//           children: [
//             Image.network(
//               reel.thumbnailSignedUrl,
//               width: double.infinity,
//               height: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) =>
//               const Center(child: CupertinoActivityIndicator()),
//             ),
//             Positioned(
//               bottom: 8,
//               left: 2,
//               child: Row(
//                 children: [
//                   const Icon(
//                     Icons.play_arrow,
//                     color: Colors.white,
//                     size: 16,
//                   ),
//                   SizedBox(width: 4),
//                   Text(
//                     reel.viewCount.toString(),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_items.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../reels/data/models/new_reels_model.dart';
import '../../../reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import '../../../stories/presentation/cubit/stories_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpotlightView extends StatefulWidget {
  const SpotlightView({super.key});

  @override
  State<SpotlightView> createState() => _SpotlightViewState();
}

class _SpotlightViewState extends State<SpotlightView> {
  late ScrollController _scrollController;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _fetchInitialData();
  }

  void _fetchInitialData() {
    context.read<StoryCubit>().fetchStories();
    context.read<ReelsCubit>().fetchReels(); // Fetch initial data for reels
    context
        .read<ReelsCubit>()
        .fetchReelsForFollowers(); // Fetch initial data for reels
  }

  // Method to detect when the user reaches the bottom of the scroll and fetch more data
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingMore) {
      _fetchMoreReels();
    }
  }

  void _fetchMoreReels() async {
    setState(() {
      _isFetchingMore = true; // Show loading indicator
    });
    await context.read<ReelsCubit>().fetchReels(); // Fetch more reels
    setState(() {
      _isFetchingMore = false; // Hide loading indicator
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: serviceLocator<UserCubit>().isLoggedIn
          ? NestedScrollView(
              controller: _scrollController,
              // Use single scroll controller for parent and child
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  const SliverToBoxAdapter(
                    child: Column(
                      children: [
                        FriendsList(),
                        Sizer(),
                        FollowingSection(),
                        Sizer(),
                      ],
                    ),
                  ),
                ];
              },
              body: DiscoverSection(
                  isFetchingMore:
                      _isFetchingMore), // The scrollable child section
            )
          : const Center(
              child: CupertinoActivityIndicator(),
            ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      leading: IconButton(
        onPressed: () {
          context.push(
            Routes.OTHERSACCOUNT,
            extra: serviceLocator<UserCubit>().state.data!.id,
          );
        },
        icon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(
            Icons.person_4,
            size: 35,
            color: Colors.red,
          ),
        ),
      ),
      title: const Row(
        children: [
          Spacer(),
          Text(
            'Stories',
            textScaler: TextScaler.noScaling,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Spacer()
        ],
      ),
    );
  }

  Widget _buildActionIcons() {
    return Stack(
      children: [
        IconButton(
          icon: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: const Icon(
              Icons.group_add,
              color: Colors.black,
            ),
          ),
          onPressed: () {},
        ),
        Positioned(
          right: 6,
          top: 6,
          child: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.red,
            child: Text(
              '8',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Friends',
              textScaler: TextScaler.noScaling,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ChatStories(),
        ],
      ),
    );
  }
}

class FollowingSection extends StatefulWidget {
  const FollowingSection({super.key});

  @override
  State<FollowingSection> createState() => _FollowingSectionState();
}

class _FollowingSectionState extends State<FollowingSection> {
  late ScrollController _scrollController;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  // Detect when the user scrolls near the end and fetch more data
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingMore) {
      _fetchMoreReels();
    }
  }

  Future<void> _fetchMoreReels() async {
    setState(() {
      _isFetchingMore = true; // Start fetching more reels
    });

    try {
      await context.read<ReelsCubit>().fetchReelsForFollowers();
    } finally {
      setState(() {
        _isFetchingMore = false; // Fetching complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Following',
            textScaler: TextScaler.noScaling, // Adjusting for scaling
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.7,
          child: BlocBuilder<ReelsCubit, ReelsState>(
            builder: (context, state) {
              if (state.reelsForFollower.isEmpty) {
                return const Center(child: CupertinoActivityIndicator());
              }
              return Stack(
                children: [
                  ListView.builder(
                    controller:
                        _scrollController, // Attach the scroll controller
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.reelsForFollower.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 12.h),
                          child: _buildReelCard(
                              context, state.reelsForFollower[index]),
                        ),
                      );
                    },
                  ),
                  if (_isFetchingMore) // Show loader when fetching more
                    const Positioned(
                      right: 16,
                      bottom: 16,
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReelCard(BuildContext context, Reel reel) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: serviceLocator<ReelsCubit>(),
              child: SpotlightReelItem(
                key: ValueKey(reel.id),
                reel: reel,
                isVisible: true,
              ),
            ),
          ),
        );
      },
      child: Card(
        elevation: 8,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Image.network(
              reel.thumbnailSignedUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: CupertinoActivityIndicator()),
            ),
            Positioned(
              bottom: 8,
              left: 2,
              child: Row(
                children: [
                  const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    reel.viewCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}

class DiscoverSection extends StatefulWidget {
  final bool isFetchingMore;

  const DiscoverSection({super.key, required this.isFetchingMore});

  @override
  DiscoverSectionState createState() => DiscoverSectionState();
}

class DiscoverSectionState extends State<DiscoverSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Discover',
            textScaler: TextScaler.noScaling,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: BlocConsumer<ReelsCubit, ReelsState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.globalReels.isEmpty && !state.globalReelsIsLoading) {
                return const Center(child: CupertinoActivityIndicator());
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // GridView won't scroll independently
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount:
                    state.globalReels.length + (widget.isFetchingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.globalReels.length &&
                      widget.isFetchingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CupertinoActivityIndicator(
                        color: Colors.black,
                      ),
                    );
                  }
                  return _buildReelCard(context, state.globalReels[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReelCard(BuildContext context, Reel reel) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: serviceLocator<ReelsCubit>(),
              child: SpotlightReelItem(
                key: ValueKey(reel.id),
                reel: reel,
                isVisible: true,
              ),
            ),
          ),
        );
      },
      child: Card(
        elevation: 8,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Image.network(
              reel.thumbnailSignedUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: CupertinoActivityIndicator()),
            ),
            Positioned(
              bottom: 8,
              left: 2,
              child: Row(
                children: [
                  const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    reel.viewCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
// import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_items.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../../../routes/routes.dart';
// import '../../../../../service_locator/service_locator.dart';
// import '../../../reels/data/models/new_reels_model.dart';
// import '../../../reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
// import '../../../stories/presentation/cubit/stories_cubit.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class SpotlightView extends StatefulWidget {
//   const SpotlightView({super.key});
//
//   @override
//   State<SpotlightView> createState() => _SpotlightViewState();
// }
//
// class _SpotlightViewState extends State<SpotlightView> {
//   late ScrollController _scrollController;
//   bool _isFetchingMore = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _scrollController.addListener(_onScroll);
//     _fetchInitialData();
//   }
//
//   void _fetchInitialData() {
//     context.read<StoryCubit>().fetchStories();
//     context.read<ReelsCubit>().fetchReels();
//     context.read<ReelsCubit>().fetchReelsForFollowers();
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent - 200 &&
//         !_isFetchingMore) {
//       _fetchMoreReels();
//     }
//   }
//
//   Future<void> _fetchMoreReels() async {
//     setState(() {
//       _isFetchingMore = true;
//     });
//     await context.read<ReelsCubit>().fetchReels();
//     setState(() {
//       _isFetchingMore = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose(); // Dispose the controller when not needed
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final userCubit = serviceLocator<UserCubit>();
//     final isLoggedIn = userCubit.isLoggedIn;
//
//     return Scaffold(
//       appBar: _buildAppBar(context),
//       body: isLoggedIn
//           ? NestedScrollView(
//               controller: _scrollController,
//               headerSliverBuilder:
//                   (BuildContext context, bool innerBoxIsScrolled) {
//                 return <Widget>[
//                   const SliverToBoxAdapter(
//                     child: Column(
//                       children: [
//                         FriendsList(),
//                         Sizer(),
//                         FollowingSection(),
//                         Sizer(),
//                       ],
//                     ),
//                   ),
//                 ];
//               },
//               body: DiscoverSection(isFetchingMore: _isFetchingMore),
//             )
//           : const Center(
//               child: CupertinoActivityIndicator(),
//             ),
//     );
//   }
//
//   AppBar _buildAppBar(BuildContext context) {
//     final userCubit = serviceLocator<UserCubit>();
//     final userId = userCubit.state.data?.id ?? '';
//
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 2,
//       title: Text(
//         'Spotlight',
//         textScaler: TextScaler.noScaling,
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55.sp),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () {
//             context.push(
//               Routes.OTHERSACCOUNT,
//               extra: userId,
//             );
//           },
//           icon: const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 4.0),
//             child: Icon(
//               Icons.person,
//               size: 35,
//               color: Colors.red,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionIcons() {
//     return Stack(
//       children: [
//         IconButton(
//           icon: CircleAvatar(
//             backgroundColor: Colors.grey[300],
//             child: const Icon(
//               Icons.group_add,
//               color: Colors.black,
//             ),
//           ),
//           onPressed: () {},
//         ),
//         Positioned(
//           right: 6,
//           top: 6,
//           child: CircleAvatar(
//             radius: 8,
//             backgroundColor: Colors.red,
//             child: Text(
//               '8',
//               textScaler: TextScaler.noScaling,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 10.sp,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class FriendsList extends StatelessWidget {
//   const FriendsList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox(
//       width: double.infinity,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Friends',
//               textScaler: TextScaler.noScaling,
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           ChatStories(),
//         ],
//       ),
//     );
//   }
// }
//
// class FollowingSection extends StatefulWidget {
//   const FollowingSection({super.key});
//
//   @override
//   State<FollowingSection> createState() => _FollowingSectionState();
// }
//
// class _FollowingSectionState extends State<FollowingSection> {
//   late ScrollController _scrollController;
//   bool _isFetchingMore = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _scrollController.addListener(_onScroll);
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent - 200 &&
//         !_isFetchingMore) {
//       _fetchMoreReels();
//     }
//   }
//
//   Future<void> _fetchMoreReels() async {
//     setState(() {
//       _isFetchingMore = true;
//     });
//
//     try {
//       await context.read<ReelsCubit>().fetchReelsForFollowers();
//     } finally {
//       setState(() {
//         _isFetchingMore = false;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose(); // Dispose the controller when not needed
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'Following',
//             textScaler: TextScaler.noScaling, // Adjusting for scaling
//             style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(
//           height: MediaQuery.of(context).size.width * 0.7,
//           child: BlocBuilder<ReelsCubit, ReelsState>(
//             builder: (context, state) {
//               if (state.reelsForFollower.isEmpty) {
//                 return const Center(child: CupertinoActivityIndicator());
//               }
//               return Stack(
//                 children: [
//                   ListView.builder(
//                     controller: _scrollController,
//                     physics: const BouncingScrollPhysics(),
//                     scrollDirection: Axis.horizontal,
//                     itemCount: state.reelsForFollower.length,
//                     itemBuilder: (context, index) {
//                       final reel = state.reelsForFollower[index];
//                       if (reel != null) {
//                         return SizedBox(
//                           width: MediaQuery.of(context).size.width / 2.5,
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 4.0, vertical: 12.h),
//                             child: _buildReelCard(context, reel),
//                           ),
//                         );
//                       } else {
//                         return const SizedBox.shrink();
//                       }
//                     },
//                   ),
//                   if (_isFetchingMore)
//                     const Positioned(
//                       right: 16,
//                       bottom: 16,
//                       child: CircularProgressIndicator(),
//                     ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildReelCard(BuildContext context, Reel reel) {
//     return GestureDetector(
//       onTap: () async {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BlocProvider.value(
//               value: serviceLocator<ReelsCubit>(),
//               child: SpotlightReelItem(
//                 key: ValueKey(reel.id),
//                 reel: reel,
//                 isVisible: true,
//               ),
//             ),
//           ),
//         );
//       },
//       child: Card(
//         elevation: 8,
//         clipBehavior: Clip.hardEdge,
//         child: Stack(
//           children: [
//             Image.network(
//               reel.thumbnailSignedUrl ?? '',
//               width: double.infinity,
//               height: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) =>
//                   const Center(child: CupertinoActivityIndicator()),
//             ),
//             Positioned(
//               bottom: 8,
//               left: 2,
//               child: Row(
//                 children: [
//                   const Icon(
//                     Icons.play_arrow,
//                     color: Colors.white,
//                     size: 16,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     reel.viewCount?.toString() ?? '0',
//                     textScaler: TextScaler.noScaling,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class DiscoverSection extends StatefulWidget {
//   final bool isFetchingMore;
//
//   const DiscoverSection({super.key, required this.isFetchingMore});
//
//   @override
//   DiscoverSectionState createState() => DiscoverSectionState();
// }
//
// class DiscoverSectionState extends State<DiscoverSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'Discover',
//             textScaler: TextScaler.noScaling,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
//           ),
//         ),
//         Flexible(
//           child: BlocBuilder<ReelsCubit, ReelsState>(
//             builder: (context, state) {
//               if (state.globalReels.isEmpty && !state.globalReelsIsLoading) {
//                 return const Center(child: CupertinoActivityIndicator());
//               }
//
//               return GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 // GridView won't scroll independently
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 8,
//                   crossAxisSpacing: 8,
//                   childAspectRatio: 0.7,
//                 ),
//                 itemCount:
//                     state.globalReels.length + (widget.isFetchingMore ? 1 : 0),
//                 itemBuilder: (context, index) {
//                   if (index == state.globalReels.length &&
//                       widget.isFetchingMore) {
//                     return const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: CupertinoActivityIndicator(
//                         color: Colors.black,
//                       ),
//                     );
//                   }
//                   final reel = state.globalReels[index];
//                   if (reel != null) {
//                     return _buildReelCard(context, reel);
//                   } else {
//                     return const SizedBox.shrink();
//                   }
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildReelCard(BuildContext context, Reel reel) {
//     return GestureDetector(
//       onTap: () async {
//         await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BlocProvider.value(
//               value: serviceLocator<ReelsCubit>(),
//               child: SpotlightReelItem(
//                 key: ValueKey(reel.id),
//                 reel: reel,
//                 isVisible: true,
//               ),
//             ),
//           ),
//         );
//       },
//       child: Card(
//         elevation: 8,
//         clipBehavior: Clip.hardEdge,
//         child: Stack(
//           children: [
//             Image.network(
//               reel.thumbnailSignedUrl ?? '',
//               width: double.infinity,
//               height: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) =>
//                   const Center(child: CupertinoActivityIndicator()),
//             ),
//             Positioned(
//               bottom: 8,
//               left: 2,
//               child: Row(
//                 children: [
//                   const Icon(
//                     Icons.play_arrow,
//                     color: Colors.white,
//                     size: 16,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     reel.viewCount?.toString() ?? '0',
//                     textScaler: TextScaler.noScaling,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_items.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../reels/data/models/new_reels_model.dart';
import '../../../reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
import '../../../reels/presentation/pages/recording/recording_shared.dart';
import '../../../reels/presentation/widgets/comments.dart';
import '../../../stories/presentation/cubit/stories_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart'; // For localization keys

class SpotlightView extends StatefulWidget {
  const SpotlightView({super.key});

  @override
  State<SpotlightView> createState() => _SpotlightViewState();
}

// class _SpotlightViewState extends State<SpotlightView> {
//   late ScrollController _scrollController;
//   bool _isFetchingMore = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _scrollController.addListener(_onScroll);
//     _fetchInitialData();
//   }
//
//   void _fetchInitialData() {
//     context.read<StoryCubit>().fetchStories();
//     context.read<ReelsCubit>().fetchReels();
//     context.read<ReelsCubit>().fetchReelsForFollowers();
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent - 200 &&
//         !_isFetchingMore) {
//       _fetchMoreReels();
//     }
//   }
//
//   Future<void> _fetchMoreReels() async {
//     setState(() {
//       _isFetchingMore = true;
//     });
//     await context.read<ReelsCubit>().fetchReels();
//     setState(() {
//       _isFetchingMore = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose(); // Dispose the controller when not needed
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final userCubit = serviceLocator<UserCubit>();
//     final isLoggedIn = userCubit.isLoggedIn;
//
//     return Scaffold(
//       appBar: _buildAppBar(context),
//       body: isLoggedIn
//           ? NestedScrollView(
//
//               controller: _scrollController,
//               physics: BouncingScrollPhysics(),
//               headerSliverBuilder:
//                   (BuildContext context, bool innerBoxIsScrolled) {
//                 return <Widget>[
//                   const SliverToBoxAdapter(
//                     child: Column(
//                       children: [
//                         FriendsList(),
//                         Sizer(),
//                         FollowingSection(),
//                         Sizer(),
//                       ],
//                     ),
//                   ),
//                 ];
//               },
//               body: DiscoverSection(isFetchingMore: _isFetchingMore),
//             )
//           : const Center(
//               child: CupertinoActivityIndicator(),
//             ),
//     );
//   }
//
//   AppBar _buildAppBar(BuildContext context) {
//     final userCubit = serviceLocator<UserCubit>();
//     final userId = userCubit.state.data?.id ?? '';
//
//     return AppBar(
//       elevation: 2,
//       title: Text(
//         LocaleKeys.spotlight_title.tr(), // Localized text
//         textScaler: TextScaler.noScaling,
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55.sp),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () {
//             context.push(
//               Routes.OTHERSACCOUNT,
//               extra: userId,
//             );
//           },
//           icon: const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 4.0),
//             child: Icon(
//               Icons.person,
//               size: 35,
//               color: Colors.red,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionIcons() {
//     return Stack(
//       children: [
//         IconButton(
//           icon: CircleAvatar(
//             backgroundColor: Colors.grey[300],
//             child: const Icon(
//               Icons.group_add,
//               color: Colors.black,
//             ),
//           ),
//           onPressed: () {},
//         ),
//         Positioned(
//           right: 6,
//           top: 6,
//           child: CircleAvatar(
//             radius: 8,
//             backgroundColor: Colors.red,
//             child: Text(
//               '8',
//               textScaler: TextScaler.noScaling,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 10.sp,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
class _SpotlightViewState extends State<SpotlightView> {
  late ScrollController _scrollController;
  bool _isFetchingMore = false;
  int _itemCount = 20; // Example item count, adjust as needed

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _fetchInitialData();
  }

  void _fetchInitialData() {
    context.read<StoryCubit>().fetchStories();
    context.read<ReelsCubit>().fetchReels();
    context.read<ReelsCubit>().fetchReelsForFollowers();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
            _scrollController.position.maxScrollExtent + 50 &&
        !_isFetchingMore) {
      _fetchMoreReels();
    }
  }

  Future<void> _fetchMoreReels() async {
    setState(() {
      _isFetchingMore = true;
    });
    await context.read<ReelsCubit>().fetchReels();
    setState(() {
      _isFetchingMore = false;
      _itemCount += 10; // Simulate more items being added
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userCubit = serviceLocator<UserCubit>();
    final isLoggedIn = userCubit.isLoggedIn;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: isLoggedIn
          ? CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(
                  child: Column(
                    children: [
                      FriendsList(),
                      Sizer(),
                      FollowingSection(),
                      Sizer(),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: DiscoverSection(isFetchingMore: _isFetchingMore),
                ),
                if (_isFetchingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            )
          : const Center(
              child: CupertinoActivityIndicator(),
            ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final userCubit = serviceLocator<UserCubit>();
    final userId = userCubit.state.data?.id ?? '';

    return AppBar(
      elevation: 2,
      title: Text(
        LocaleKeys.spotlight_title.tr(),
        textScaler: TextScaler.noScaling,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55.sp),
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.push(
              Routes.OTHERSACCOUNT,
              extra: userId,
            );
          },
          icon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              Icons.person,
              size: 35,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              LocaleKeys.friends_title.tr(), // Localized text
              textScaler: TextScaler.noScaling,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
            ),
          ),
          BlocProvider<StoryCubit>(
            create: (_) => serviceLocator()..fetchStories(),
            child: const ChatStories(),
          ),
        ],
      ),
    );
  }
}

class FollowingSection extends StatefulWidget {
  const FollowingSection({super.key});

  @override
  State<FollowingSection> createState() => _FollowingSectionState();
}

class _FollowingSectionState extends State<FollowingSection> {
  late ScrollController _scrollController;
  bool _isFetchingMore = false;
  double _previousScrollPosition = 0.0; // Track previous scroll position

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // _scrollController.addListener(_onScroll);
  }

  // Updated _onScroll method to detect scroll direction and trigger fetch
  void _onScroll(ScrollMetrics metrics) {
    double currentScrollPosition = metrics.pixels;

    // print(
    //     'Current scroll: ${currentScrollPosition}, Max scroll extent: ${metrics.maxScrollExtent}');

    // Check if the user is scrolling right to left (i.e., scroll value is increasing)
    bool isScrollingRightToLeft =
        currentScrollPosition > _previousScrollPosition;

    // Check if user has reached near the end of the list and is scrolling right to left
    if (isScrollingRightToLeft &&
        currentScrollPosition >= metrics.maxScrollExtent + 20 &&
        !_isFetchingMore) {
      _fetchMoreReels();
    }

    // Update the previous scroll position for the next event
    _previousScrollPosition = currentScrollPosition;
  }

  // void _onScroll() {
  //   if (_scrollController.position.pixels >=
  //           _scrollController.position.maxScrollExtent - 200 &&
  //       !_isFetchingMore) {
  //     _fetchMoreReels();
  //   }
  // }

  Future<void> _fetchMoreReels() async {
    setState(() {
      _isFetchingMore = true;
    });

    try {
      await context.read<ReelsCubit>().fetchReelsForFollowers();
      print('Fetching more reels');
    } finally {
      setState(() {
        _isFetchingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            LocaleKeys.following_title.tr(), // Localized text
            textScaler: TextScaler.noScaling, // Adjusting for scaling
            style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.7,
          width: double.infinity,
          child: BlocConsumer<ReelsCubit, ReelsState>(
            builder: (context, state) {
              if (state.reelsForFollower.isEmpty) {
                return const Center(child: CupertinoActivityIndicator());
              }
              return Stack(
                children: [
                  // Wrap ListView.builder in a NotificationListener to track scrolls
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      if (notification is ScrollUpdateNotification) {
                        _onScroll(notification.metrics);
                      }
                      return true; // Prevent the event from bubbling up
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.reelsForFollower.length,
                      itemBuilder: (context, index) {
                        final reel = state.reelsForFollower[index];
                        if (reel != null) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 12.h),
                              child: _buildReelCard(context, reel),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  if (_isFetchingMore)
                    const Positioned(
                      right: 16,
                      top: 16,
                      bottom: 16,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            },
            listener: (BuildContext context, ReelsState state) {},
          ),
        ),
      ],
    );
  }

  Widget _buildReelCard(BuildContext context, Reel reel) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                value: serviceLocator<ReelsCubit>(),
                child: Scaffold(
                    extendBodyBehindAppBar: true,
                    extendBody: true,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconAppButton(
                        icon: Icons.arrow_back,
                        size: 50.h,
                        color:
                            isDarkTheme(context) ? Colors.white : Colors.grey,
                        onPressed: () => context.pop(),
                      ),
                      actions: [
                        // const Spacer(),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: IconButton(
                        //     onPressed: () async {
                        //       // context.pop();
                        //       await Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) =>
                        //                 const ReelsRecordingScreen(
                        //                     // advertisementType: 'reel',
                        //                     // comeFromCompany: 'company',
                        //                     // totalPrice: '500',
                        //                     ),
                        //           ));
                        //     },
                        //     icon: FaIcon(
                        //       Icons.camera_alt_outlined,
                        //       color: isDarkTheme(context)
                        //           ? Colors.white
                        //           : Colors.grey,
                        //       size: 50.h,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                    body: UnifiedReelItem(
                      reel: reel,
                      isVisible: true,
                      itemType: ReelItemType.spotlight,
                    ),
                    // MainReelItem(
                    //   key: ValueKey(reel.id),
                    //   reel: reel,
                    //   fromSpotlight: true,
                    //   isVisible: true,
                    // )
                    // SpotlightReelItem(
                    //   key: ValueKey(reel.id),
                    //   reel: reel,
                    //   isVisible: true,
                    // ),,
                    )),
          ),
        );
      },
      child: Card(
        elevation: 8,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Image.network(
              reel.thumbnailSignedUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: CupertinoActivityIndicator()),
            ),
            Positioned(
              bottom: 8,
              left: 2,
              child: Row(
                children: [
                  const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    reel.viewCount.toString() ?? '0',
                    textScaler: TextScaler.noScaling,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiscoverSection extends StatefulWidget {
  final bool isFetchingMore;

  const DiscoverSection({super.key, required this.isFetchingMore});

  @override
  DiscoverSectionState createState() => DiscoverSectionState();
}

class DiscoverSectionState extends State<DiscoverSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            LocaleKeys.discover_title.tr(), // Localized text
            textScaler: TextScaler.noScaling,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
          ),
        ),
        Flexible(
          child: BlocBuilder<ReelsCubit, ReelsState>(
            builder: (context, state) {
              if (state.globalReels.isEmpty && !state.globalReelsIsLoading) {
                return const Center(child: CupertinoActivityIndicator());
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // GridView won't scroll independently
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount:
                    state.globalReels.length + (widget.isFetchingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.globalReels.length &&
                      widget.isFetchingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CupertinoActivityIndicator(
                        color: Colors.black,
                      ),
                    );
                  }
                  final reel = state.globalReels[index];
                  if (reel != null) {
                    return _buildReelCard(context, reel);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReelCard(BuildContext context, Reel reel) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: serviceLocator<ReelsCubit>(),
              child: Scaffold(
                  extendBodyBehindAppBar: true,
                  extendBody: true,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconAppButton(
                      icon: Icons.arrow_back,
                      size: 50.h,
                      color: isDarkTheme(context) ? Colors.white : Colors.grey,
                      onPressed: () => context.pop(),
                    ),
                    actions: [
                      // const Spacer(),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: IconButton(
                      //     onPressed: () async {
                      //       // context.pop();
                      //       await Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) =>
                      //                 const ReelsRecordingScreen(
                      //                     // advertisementType: 'reel',
                      //                     // comeFromCompany: 'company',
                      //                     // totalPrice: '500',
                      //                     ),
                      //           ));
                      //     },
                      //     icon: FaIcon(
                      //       Icons.camera_alt_outlined,
                      //       color: isDarkTheme(context)
                      //           ? Colors.white
                      //           : Colors.grey,
                      //       size: 50.h,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  body: UnifiedReelItem(
                    reel: reel,
                    isVisible: true,
                    itemType: ReelItemType.spotlight,
                  ),
                  // SpotlightReelItem(
                  //   key: ValueKey(reel.id),
                  //   reel: reel,
                  //   isVisible: true,
                  // ),,
                  ),
            ),
          ),
        );
      },
      child: Card(
        elevation: 8,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Image.network(
              reel.thumbnailSignedUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: CupertinoActivityIndicator()),
            ),
            Positioned(
              bottom: 8,
              left: 2,
              child: Row(
                children: [
                  const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    reel.viewCount.toString(),
                    textScaler: TextScaler.noScaling,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
