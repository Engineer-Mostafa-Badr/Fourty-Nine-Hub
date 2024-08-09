// // // // import 'dart:developer';
// // //
// // // // import 'package:flutter/cupertino.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // // import 'package:fourtyninehub/common/functions/global/upload_file.dart';
// // // // import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// // // // import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
// // // // import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// // // // import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// // // // import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/sub_categories/sub_category_card.dart';
// // // // import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
// // // // import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
// // // // import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
// // // // import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
// // // // import 'package:fourtyninehub/res/style/const.dart';
// // // // import 'package:fourtyninehub/routes/routes.dart';
// // // // import 'package:go_router/go_router.dart';
// // // // import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
// // // // import '../../../../../res/style/app_colors.dart';
// // // // import '../../../../../res/style/styles.dart';
// // // // import '../cubit/tinder_cubit.dart';
// // // // import '../cubit/tinder_state.dart';
// // //
// // // // class TinderView extends StatelessWidget {
// // // //   const TinderView({super.key});
// // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return BlocProvider(
// // // //       create: (context) => TinderViewCubit()
// // // //         ..fetchUserData()
// // // //         ..fetchSubCategoryData(),
// // // //       child: BlocBuilder<TinderViewCubit, TinderViewState>(
// // // //         builder: (context, state) {
// // // //           return SharedScaffold(
// // // //             body: state.userData.isEmpty
// // // //                 ? Builder(builder: (context) {
// // // //                     // context.read<TinderViewCubit>().fetchUserData();
// // // //                     return const Center(child: CircularProgressIndicator());
// // // //                   })
// // // //                 : Stack(
// // // //                     children: [
// // // //                       SingleChildScrollView(
// // // //                         child: Column(
// // // //                           children: [
// // // //                             Padding(
// // // //                               padding:
// // // //                                   const EdgeInsets.symmetric(horizontal: 8.0),
// // // //                               child: Align(
// // // //                                 alignment: Alignment.topLeft,
// // // //                                 child: Label(
// // // //                                   text: 'Find',
// // // //                                   style: Styles.headerText(),
// // // //                                 ),
// // // //                               ),
// // // //                             ),
// // // //                             // const Divider(),
// // // //                             SizedBox(
// // // //                               height: MediaQuery.of(context).size.height -
// // // //                                   kToolbarHeight -
// // // //                                   200,
// // // //                               child: Stack(
// // // //                                 children:
// // // //                                     state.userData.asMap().entries.map((entry) {
// // // //                                   int index = entry.key;
// // // //                                   UserData user = entry.value;
// // // //                                   return _buildCard(
// // // //                                       context, index, user.pictures, user);
// // // //                                 }).toList(),
// // // //                               ),
// // // //                             ),
// // // //                             // // const Divider(),
// // // //                             // SizedBox(
// // // //                             //   height: 160,
// // // //                             //   child: Padding(
// // // //                             //     padding:
// // // //                             //         const EdgeInsets.symmetric(horizontal: 0.0),
// // // //                             //     child: ListView.builder(
// // // //                             //       scrollDirection: Axis.horizontal,
// // // //                             //       itemCount: state.subCategoryData.length,
// // // //                             //       itemBuilder: (context, index) {
// // // //                             //         return Card(
// // // //                             //           clipBehavior: Clip.hardEdge,
// // // //                             //           color: Colors.transparent,
// // // //                             //           child: FittedBox(
// // // //                             //             child: Container(
// // // //                             //               decoration: BoxDecoration(
// // // //                             //                   image: DecorationImage(
// // // //                             //                       image: NetworkImage(state
// // // //                             //                           .subCategoryData[index]
// // // //                             //                           .picture
// // // //                             //                           .toString()))),
// // // //                             //               width: 160,
// // // //                             //               height: 160,
// // // //                             //               child: Align(
// // // //                             //                 alignment: Alignment.bottomCenter,
// // // //                             //                 child: Container(
// // // //                             //                   width: double.infinity,
// // // //                             //                   color: Colors.white54,
// // // //                             //                   child: Text(
// // // //                             //                     '${state.subCategoryData[index].nameEn}',
// // // //                             //                     textAlign: TextAlign.center,
// // // //                             //                     textScaler:
// // // //                             //                         const TextScaler.linear(
// // // //                             //                             1.2),
// // // //                             //                     style: Styles.headerText(
// // // //                             //                       fontWeight: FontWeight.w600,
// // // //                             //                     ),
// // // //                             //                   ),
// // // //                             //                 ),
// // // //                             //               ),
// // // //                             //             ),
// // // //                             //           ),
// // // //                             //         );
// // // //                             //       },
// // // //                             //     ),
// // // //                             //   ),
// // // //                             // ),
// // // //                             if (state.subCategoryData.isNotEmpty)
// // // //                               SizedBox(
// // // //                                 height: 200,
// // // //                                 child: ListView.separated(
// // // //                                   separatorBuilder: (context, index) =>
// // // //                                       const Sizer(),
// // // //                                   padding:
// // // //                                       const EdgeInsets.symmetric(vertical: 20),
// // // //                                   scrollDirection: Axis.horizontal,
// // // //                                   itemBuilder: (context, index) =>
// // // //                                       TinderSubCategoryCard(
// // // //                                           subCategory:
// // // //                                               state.subCategoryData[index]),
// // // //                                   itemCount: state.subCategoryData.length,
// // // //                                 ),
// // // //                               )
// // // //                             else
// // // //                               const SizedBox.shrink(),
// // //
// // // //                             const SizedBox(
// // // //                               height: 50,
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //             mainCategoryId: 2,
// // // //           );
// // // //         },
// // // //       ),
// // // //     );
// // // //   }
// // //
// // // //   void switchDisplayGander(TinderViewState state, BuildContext context) {
// // // //     state.userData.first.users.first.gender.toString() == 'female' //persons
// // // //         ? context.read<TinderViewCubit>().fetchUserData(gender: 'female') //user
// // // //         : context.read<TinderViewCubit>().fetchUserData(gender: 'male');
// // // //   }
// // //
// // // //   Widget _buildCard(
// // // //       BuildContext context, int index, List<Picture> images, UserData user) {
// // // //     final cubit = context.read<TinderViewCubit>();
// // // //     final state = cubit.state;
// // // //     bool isFrontCard = index == state.currentIndex;
// // //
// // // //     return Positioned(
// // // //       left: 0,
// // // //       right: 0,
// // // //       top: 0,
// // // //       bottom: 0,
// // // //       child: isFrontCard
// // // //           ? GestureDetector(
// // // //               onPanStart: (details) {
// // // //                 cubit.updatePanStart(details.globalPosition);
// // // //               },
// // // //               onPanUpdate: (details) {
// // // //                 final position = details.globalPosition - state.startDragOffset;
// // // //                 final rotation = position.dx /
// // // //                     (position.dy > state.startDragOffset.dy - 180 ? 500 : -500);
// // // //                 cubit.updatePanUpdate(position, rotation);
// // // //               },
// // // //               onPanEnd: (details) {
// // // //                 if (state.position.dx > 250 ||
// // // //                     state.position.dx < -250 ||
// // // //                     state.position.dy > 250 ||
// // // //                     state.position.dy < -250) {
// // // //                   cubit.swipeAway();
// // // //                 } else {
// // // //                   cubit.resetPan();
// // // //                 }
// // // //               },
// // // //               onTapUp: (details) {
// // // //                 double tapPosition = details.localPosition.dx;
// // // //                 double screenWidth = MediaQuery.of(context).size.width;
// // //
// // // //                 if (tapPosition < screenWidth / 2) {
// // // //                   cubit.previousStory();
// // // //                 } else {
// // // //                   cubit.nextStory();
// // // //                 }
// // // //               },
// // // //               child: Transform.translate(
// // // //                 offset: state.position,
// // // //                 child: Transform.rotate(
// // // //                   angle: state.rotation,
// // // //                   child:
// // // //                       _cardWidget(context, images: user.pictures, user: user),
// // // //                 ),
// // // //               ),
// // // //             )
// // // //           : const Offstage(),
// // // //     );
// // // //   }
// // //
// // // //   Widget _cardWidget(
// // // //     BuildContext context, {
// // // //     required List<Picture> images,
// // // //     required UserData user,
// // // //   }) {
// // // //     final state = context.read<TinderViewCubit>().state;
// // // //     return Padding(
// // // //       padding: const EdgeInsets.all(0.0),
// // // //       child: Card(
// // // //         clipBehavior: Clip.hardEdge,
// // // //         elevation: 6,
// // // //         child: Stack(
// // // //           children: [
// // // //             Hero(
// // // //               tag: 'userHero-${user.id}', // Ensure each hero tag is unique
// // //
// // // //               child: Image.network(
// // // //                 (images.isNotEmpty)
// // // //                     ? images[state.currentStoryIndex].mediaKey
// // // //                     : UIConst.profilePlaceHolder,
// // // //                 errorBuilder: (context, error, stackTrace) => Image.network(
// // // //                   UIConst.profilePlaceHolder,
// // // //                   fit: BoxFit.fitHeight,
// // // //                   height: double.infinity,
// // // //                 ),
// // // //                 fit: BoxFit.fitHeight,
// // // //                 height: double.infinity,
// // // //               ),
// // // //             ),
// // // //             Padding(
// // // //               padding: const EdgeInsets.only(top: 12.0, right: 8),
// // // //               child: Align(
// // // //                 alignment: Alignment.topRight,
// // // //                 child: IconButton(
// // // //                   onPressed: () {
// // // //                     switchDisplayGander(state, context);
// // // //                   },
// // // //                   iconSize: 30,
// // // //                   icon: Icon(
// // // //                     user.users.first.gender == 'male'
// // // //                         ? Icons.female
// // // //                         : Icons.male,
// // // //                     color: Colors.black,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             Positioned(
// // // //               top: 10,
// // // //               left: 10,
// // // //               right: 10,
// // // //               child: Row(
// // // //                 mainAxisAlignment: MainAxisAlignment.center,
// // // //                 children: List.generate(images.length, (dotIndex) {
// // // //                   return Expanded(
// // // //                     child: Container(
// // // //                       margin: const EdgeInsets.symmetric(horizontal: 2.0),
// // // //                       height: 4,
// // // //                       decoration: BoxDecoration(
// // // //                         color: (dotIndex == state.currentStoryIndex)
// // // //                             ? Colors.red
// // // //                             : Colors.white54,
// // // //                         borderRadius: BorderRadius.circular(2),
// // // //                       ),
// // // //                     ),
// // // //                   );
// // // //                 }),
// // // //               ),
// // // //             ),
// // // //             Positioned(
// // // //               bottom: kToolbarHeight * 1.2,
// // // //               right: 20,
// // // //               left: 20,
// // // //               child: _buildPersonInfo(context: context, user: user),
// // // //             ),
// // // //             Positioned(
// // // //               bottom: 8,
// // // //               right: 10,
// // // //               left: 10,
// // // //               child: _buildActions(context, state.userData, cardUser: user),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // //
// // // //   Widget _buildPersonInfo(
// // // //       {required BuildContext context, required UserData user}) {
// // // //     return InkWell(
// // // //       onTap: () => context.push(Routes.OTHERSACCOUNT),
// // // //       child: Row(
// // // //         crossAxisAlignment: CrossAxisAlignment.end,
// // // //         children: [
// // // //           Expanded(
// // // //             child: Column(
// // // //               mainAxisAlignment: MainAxisAlignment.end,
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 const BadgedLabel(
// // // //                   color: AppColors.SECONDARY_COLOR,
// // // //                   label: 'Nearby',
// // // //                 ),
// // // //                 ListTile(
// // // //                   onTap: null,
// // // //                   selected: false,
// // // //                   enabled: false,
// // // //                   title: Label(
// // // //                     text:
// // // //                         "${user.users.first.firstName} ${user.users.first.lastName}", // must start with capital...
// // // //                     style: Styles.headerText(color: Colors.black, fontSize: 26),
// // // //                   ),
// // // //                   subtitle: Label(
// // // //                     text: 'last seen 3 minute ago',
// // // //                     style: Styles.mediumText(color: Colors.black),
// // // //                   ),
// // //
// // // //                   // leading: Icon(
// // // //                   //   user.user.first.gender == 'male'
// // // //                   //       ? Icons.male
// // // //                   //       : Icons.female,
// // // //                   //   color: Colors.black
// // // //                   // ,
// // // //                   //   size: 28,
// // // //                   // ),
// // // //                 ),
// // // //                 // Label(
// // // //                 //   text: user.user.first.birthday ?? '',
// // // //                 //   style: Styles.smallText(color: Colors.white),
// // // //                 // )
// // // //               ],
// // // //             ),
// // // //           ),
// // // //           const Icon(
// // // //             Icons.arrow_upward_rounded,
// // // //             color: Colors.white,
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // //
// // // //   Widget _buildActions(BuildContext context, List<UserData> listOfUsers,
// // // //       {required UserData cardUser}) {
// // // //     return Row(
// // // //       mainAxisAlignment: MainAxisAlignment.spaceAround,
// // // //       children: [
// // // //         _buildFloatingActionButton(context, Icons.person, null),
// // // //         _buildFloatingActionButton(context, Icons.chat, null,
// // // //             color: AppColors.PRIMARY_COLOR),
// // // //         FloatingActionButton.small(
// // // //           backgroundColor: Colors.red,
// // // //           onPressed: () {
// // // //             // UploadFile().uploadImage(
// // // //             //     subCategoryId: '66af974f8bf69f9469944746',
// // // //             //     onUploaded: (p0) {
// // // //             //       context
// // // //             //           .read<TinderViewCubit>()
// // // //             //           .uploadImages(mediaIds: [p0.mediaId]);
// // // //             //       log("${p0.file.path}-----------===========");
// // // //             //     });
// // // // //--------------------------
// // // //             final user = context.read<UserCubit>().state.data;
// // // //             log("${user?.firstName}pppppppppppppppppppppppppppppppppppppppp");
// // // //             if (user!.isMyAccount(cardUser.userId)) {
// // // //               Navigator.push(
// // // //                   context,
// // // //                   MaterialPageRoute(
// // // //                     builder: (context) => UserProfilePage(
// // // //                       userData: cardUser,
// // // //                     ),
// // // //                   ));
// // // //             }
// // // //             // else {
// // // //             //   for (var element in listOfUsers) {
// // // //             //     if (user.isMyAccount(element.userId)) {
// // // //             //       Navigator.push(
// // // //             //           context,
// // // //             //           MaterialPageRoute(
// // // //             //             builder: (context) => UserProfilePage(
// // // //             //               userData: cardUser,
// // // //             //             ),
// // // //             //           ));
// // // //             //     }
// // //
// // // //             //   }
// // // //             // }
// // //
// // // // //============================
// // // //             // Navigator.push(
// // // //             //     context,
// // // //             //     MaterialPageRoute(
// // // //             //       builder: (context) => UserProfilePage(
// // // //             //         userData: user,
// // // //             //       ),
// // // //             //     ));
// // // //           },
// // // //           shape: const CircleBorder(),
// // // //           child: const Icon(
// // // //             Icons.add_photo_alternate_outlined,
// // // //             color: Colors.white,
// // // //           ),
// // // //         ),
// // // //         _buildFloatingActionButton(context, Icons.card_giftcard, () {},
// // // //             color: AppColors.ACCENT_COLOR),
// // // //         _buildFloatingActionButton(context, Icons.report, () {
// // // //           showModalBottomSheet(
// // // //             context: context,
// // // //             builder: (context) => SizedBox(
// // // //               height: MediaQuery.of(context).size.height / 1.5,
// // // //               child: const Padding(
// // // //                 padding: EdgeInsets.all(8.0),
// // // //                 child: ReportView(
// // // //                   id: '2',
// // // //                   categoryId: '',
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           );
// // // //         }, color: Colors.red),
// // // //       ],
// // // //     );
// // // //   }
// // //
// // // //   Widget _buildFloatingActionButton(
// // // //       BuildContext context, IconData icon, VoidCallback? onPressed,
// // // //       {Color? color}) {
// // // //     return FloatingActionButton.small(
// // // //       onPressed: onPressed,
// // // //       backgroundColor: color,
// // // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
// // // //       child: Icon(
// // // //         icon,
// // // //         color: color != null ? Colors.white : null,
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // // //rommana1
// // // import 'dart:developer';
// // // import 'package:flutter/cupertino.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// // // import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
// // // import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// // // import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// // // import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/other_account_view.dart';
// // // import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
// // // import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
// // // import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
// // // import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
// // // import 'package:fourtyninehub/res/style/const.dart';
// // // import 'package:fourtyninehub/routes/routes.dart';
// // // import 'package:go_router/go_router.dart';
// // // import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
// // // import '../../../../../res/style/app_colors.dart';
// // // import '../../../../../res/style/styles.dart';
// // // import '../cubit/tinder_cubit.dart';
// // // import '../cubit/tinder_state.dart';
// // //
// // // class TinderView extends StatelessWidget {
// // //   const TinderView({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return BlocProvider(
// // //       create: (context) => TinderViewCubit()
// // //         ..fetchUserData()
// // //         ..fetchSubCategoryData(),
// // //       child: BlocBuilder<TinderViewCubit, TinderViewState>(
// // //         builder: (context, state) {
// // //           return SharedScaffold(
// // //             body: state.userData.isEmpty
// // //                 ? Builder(builder: (context) {
// // //                     context.read<TinderViewCubit>().fetchUserData().then(
// // //                       (value) {
// // //                         log('success..........................');
// // //                       },
// // //                     );
// // //                     return const Center(child: CircularProgressIndicator());
// // //                   })
// // //                 : Stack(
// // //                     children: [
// // //                       SingleChildScrollView(
// // //                         child: Column(
// // //                           children: [
// // //                             Padding(
// // //                               padding:
// // //                                   const EdgeInsets.symmetric(horizontal: 8.0),
// // //                               child: Align(
// // //                                 alignment: Alignment.topLeft,
// // //                                 child: Label(
// // //                                   text: 'Find',
// // //                                   style: Styles.headerText(),
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                             SizedBox(
// // //                               height: MediaQuery.of(context).size.height -
// // //                                   kToolbarHeight -
// // //                                   150,
// // //                               child: Stack(
// // //                                 children:
// // //                                     state.userData.asMap().entries.map((entry) {
// // //                                   int index = entry.key;
// // //                                   UserData user = entry.value;
// // //                                   return _buildCard(context, index,
// // //                                       user.pictures ?? [], user);
// // //                                 }).toList(),
// // //                               ),
// // //                             ),
// // //                             if (state.subCategoryData.isNotEmpty)
// // //                               SizedBox(
// // //                                 height: 200,
// // //                                 child: ListView.separated(
// // //                                   separatorBuilder: (context, index) =>
// // //                                       const Sizer(),
// // //                                   padding: const EdgeInsets.symmetric(
// // //                                       vertical: 0, horizontal: 0),
// // //                                   scrollDirection: Axis.horizontal,
// // //                                   itemBuilder: (context, index) =>
// // //                                       TinderSubCategoryCard(
// // //                                           subCategory:
// // //                                               state.subCategoryData[index]),
// // //                                   itemCount: state.subCategoryData.length,
// // //                                 ),
// // //                               )
// // //                             else
// // //                               const SizedBox.shrink(),
// // //                             const SizedBox(height: 50),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //             mainCategoryId: 2,
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // //
// // //   void switchDisplayGender(TinderViewState state, BuildContext context) {
// // //     String gender = state.userData.first.user!.gender.toString();
// // //     context
// // //         .read<TinderViewCubit>()
// // //         .fetchUserData(gender: gender == 'female' ? 'female' : 'male');
// // //   }
// // //
// // //   Widget _buildCard(
// // //       BuildContext context, int index, List<Pictures> images, UserData user) {
// // //     final cubit = context.read<TinderViewCubit>();
// // //     final state = cubit.state;
// // //     bool isFrontCard = index == state.currentIndex;
// // //
// // //     return Positioned(
// // //       left: 0,
// // //       right: 0,
// // //       top: 0,
// // //       bottom: 0,
// // //       child: isFrontCard
// // //           ? GestureDetector(
// // //               onPanStart: (details) =>
// // //                   cubit.updatePanStart(details.globalPosition),
// // //               onPanUpdate: (details) {
// // //                 final position = details.globalPosition - state.startDragOffset;
// // //                 final rotation = position.dx /
// // //                     (position.dy > state.startDragOffset.dy - 180 ? 500 : -500);
// // //                 cubit.updatePanUpdate(position, rotation);
// // //               },
// // //               onPanEnd: (details) {
// // //                 if (state.position.dx > 250 ||
// // //                     state.position.dx < -250 ||
// // //                     state.position.dy > 250 ||
// // //                     state.position.dy < -250) {
// // //                   cubit.swipeAway();
// // //                 } else {
// // //                   cubit.resetPan();
// // //                 }
// // //               },
// // //               onTapUp: (details) {
// // //                 double tapPosition = details.localPosition.dx;
// // //                 double screenWidth = MediaQuery.of(context).size.width;
// // //                 tapPosition < screenWidth / 2
// // //                     ? cubit.previousStory()
// // //                     : cubit.nextStory();
// // //               },
// // //               child: Transform.translate(
// // //                 offset: state.position,
// // //                 child: Transform.rotate(
// // //                   angle: state.rotation,
// // //                   child: _cardWidget(context,
// // //                       images: user.pictures ?? [], user: user),
// // //                 ),
// // //               ),
// // //             )
// // //           : const Offstage(),
// // //     );
// // //   }
// // //
// // //   Widget _cardWidget(BuildContext context,
// // //       {required List<Pictures> images, required UserData user}) {
// // //     final state = context.read<TinderViewCubit>().state;
// // //     return Padding(
// // //       padding: const EdgeInsets.all(0.0),
// // //       child: Card(
// // //         clipBehavior: Clip.hardEdge,
// // //         elevation: 2,
// // //         child: Stack(
// // //           children: [
// // //             Hero(
// // //               tag: 'userHero-${user.sId}',
// // //               child: Image.network(
// // //                 images.isNotEmpty
// // //                     ? images[state.currentStoryIndex].mediaKey ?? ''
// // //                     : UIConst.profilePlaceHolder,
// // //                 errorBuilder: (context, error, stackTrace) => Image.network(
// // //                     UIConst.profilePlaceHolder,
// // //                     fit: BoxFit.fitHeight,
// // //                     height: double.infinity),
// // //                 fit: BoxFit.fitHeight,
// // //                 height: double.infinity,
// // //               ),
// // //             ),
// // //             Padding(
// // //               padding: const EdgeInsets.only(top: 0.0, right: 8),
// // //               child: Align(
// // //                 alignment: Alignment.topRight,
// // //                 child: IconButton(
// // //                   onPressed: () => switchDisplayGender(state, context),
// // //                   iconSize: 30,
// // //                   icon: Icon(
// // //                       user.user!.gender == 'male' ? Icons.female : Icons.male,
// // //                       color: Colors.black),
// // //                 ),
// // //               ),
// // //             ),
// // //             Positioned(
// // //               top: 10,
// // //               left: 10,
// // //               right: 10,
// // //               child: Row(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: List.generate(images.length, (dotIndex) {
// // //                   return Expanded(
// // //                     child: Container(
// // //                       margin: const EdgeInsets.symmetric(horizontal: 2.0),
// // //                       height: 4,
// // //                       decoration: BoxDecoration(
// // //                         color: dotIndex == state.currentStoryIndex
// // //                             ? Colors.red
// // //                             : Colors.white54,
// // //                         borderRadius: BorderRadius.circular(2),
// // //                       ),
// // //                     ),
// // //                   );
// // //                 }),
// // //               ),
// // //             ),
// // //             Positioned(
// // //               bottom: kToolbarHeight * 1.2,
// // //               right: 20,
// // //               left: 20,
// // //               child: _buildPersonInfo(context: context, user: user),
// // //             ),
// // //             Positioned(
// // //               bottom: 8,
// // //               right: 10,
// // //               left: 10,
// // //               child: _buildActions(context, state.userData, cardUser: user),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildPersonInfo(
// // //       {required BuildContext context, required UserData user}) {
// // //     return InkWell(
// // //       onTap: () => context.push(Routes.OTHERSACCOUNT),
// // //       child: Row(
// // //         crossAxisAlignment: CrossAxisAlignment.end,
// // //         children: [
// // //           Expanded(
// // //             child: Column(
// // //               mainAxisAlignment: MainAxisAlignment.end,
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 const BadgedLabel(
// // //                     color: AppColors.SECONDARY_COLOR, label: 'Nearby'),
// // //                 ListTile(
// // //                   onTap: null,
// // //                   selected: false,
// // //                   enabled: false,
// // //                   title: Label(
// // //                     text: "${user.user!.firstName} ${user.user!.lastName}",
// // //                     style: Styles.headerText(color: Colors.black, fontSize: 26),
// // //                   ),
// // //                   subtitle: Label(
// // //                     text: 'last seen 3 minute ago',
// // //                     style: Styles.mediumText(color: Colors.black),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           const Icon(Icons.arrow_upward_rounded, color: Colors.white),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   // Widget _buildActions(BuildContext context, List<UserData> listOfUsers,
// // //   //     {required UserData cardUser}) {
// // //   //   return Row(
// // //   //     mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //   //     children: [
// // //   //       _buildFloatingActionButton(
// // //   //         context,
// // //   //         Icons.person,
// // //   //         () {
// // //   //           Navigator.pop(context);
// // //   //           // context.push(Routes.OTHERSACCOUNT);
// // //   //           Navigator.push(
// // //   //               context,
// // //   //               MaterialPageRoute(
// // //   //                 builder: (context) => OtherAccountView(),
// // //   //               ));
// // //   //         },
// // //   //       ),
// // //   //       _buildFloatingActionButton(
// // //   //           context, Icons.chat, () => showAdvancedDialog(context),
// // //   //           color: AppColors.PRIMARY_COLOR),
// // //   //       FloatingActionButton.small(
// // //   //         backgroundColor: Colors.red,
// // //   //         onPressed: () async {
// // //   //           // Uploading an image and updating state with the uploaded image's media ID
// // //   //           // try {
// // //   //           //   final uploadResult = await UploadFile().uploadImage(
// // //   //           //     subCategoryId: '66af974f8bf69f9469944746',
// // //   //           //     onUploaded: (p0) {
// // //   //           //       context
// // //   //           //           .read<TinderViewCubit>()
// // //   //           //           .uploadImages(mediaIds: [p0.mediaId]);
// // //   //           //       log("${p0.file.path}-----------===========");
// // //   //           //     },
// // //   //           //   );
// // //   //           //   log("Image uploaded successfully:");
// // //   //           // } catch (e) {
// // //   //           //   log("Image upload failed: $e");
// // //   //           // }
// // //   //
// // //   //           // Fetching the current user data
// // //   //           final user = context.read<UserCubit>().state.data;
// // //   //           log("${user?.firstName}pppppppppppppppppppppppppppppppppppppppp");
// // //   //
// // //   //           if (user != null) {
// // //   //             if (user.isMyAccount(cardUser.sId ?? '')) {
// // //   //               Navigator.push(
// // //   //                 context,
// // //   //                 MaterialPageRoute(
// // //   //                   builder: (context) => UserProfilePage(userData: cardUser),
// // //   //                 ),
// // //   //               );
// // //   //             } else {
// // //   //               for (var element in listOfUsers) {
// // //   //                 if (user.isMyAccount(element.sId ?? '')) {
// // //   //                   Navigator.push(
// // //   //                     context,
// // //   //                     MaterialPageRoute(
// // //   //                       builder: (context) =>
// // //   //                           UserProfilePage(userData: cardUser),
// // //   //                     ),
// // //   //                   );
// // //   //                   break;
// // //   //                 }
// // //   //               }
// // //   //             }
// // //   //           }
// // //   //         },
// // //   //         shape: const CircleBorder(),
// // //   //         child: const Icon(Icons.add_photo_alternate_outlined,
// // //   //             color: Colors.white),
// // //   //       ),
// // //   //       _buildFloatingActionButton(context, Icons.card_giftcard, () {
// // //   //         showModalBottomSheet(
// // //   //           context: context,
// // //   //           builder: (context) => GiftBottomSheet(),
// // //   //         );
// // //   //       }, color: AppColors.ACCENT_COLOR),
// // //   //       _buildFloatingActionButton(context, Icons.report, () {
// // //   //         final user = context.read<UserCubit>().state.data;
// // //   //         showModalBottomSheet(
// // //   //           context: context,
// // //   //           builder: (context) => SizedBox(
// // //   //             height: MediaQuery.of(context).size.height / 1.5,
// // //   //             child: Padding(
// // //   //               padding: EdgeInsets.all(8.0),
// // //   //               child: ReportView(id: user!.id, categoryId: ''),
// // //   //             ),
// // //   //           ),
// // //   //         );
// // //   //       }, color: Colors.red),
// // //   //     ],
// // //   //   );
// // //   // }
// // //   //2
// // //   // Widget _buildActions(BuildContext context, List<UserData> listOfUsers, {required UserData cardUser}) {
// // //   //   final UserCubit userCubit = context.read<UserCubit>();
// // //   //   final user = userCubit.state.data;
// // //   //
// // //   //   return Row(
// // //   //     mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //   //     children: [
// // //   //       _buildFloatingActionButton(
// // //   //         context,
// // //   //         Icons.person,
// // //   //             () {
// // //   //           // Navigator.pop(context);
// // //   //           // Navigator.push(
// // //   //           //   context,
// // //   //           //   MaterialPageRoute(
// // //   //           //     builder: (context) => OtherAccountView(),
// // //   //           //   ),
// // //   //           // );
// // //   //               context.push(Routes.OTHERSACCOUNT);
// // //   //         },
// // //   //       ),
// // //   //       _buildFloatingActionButton(
// // //   //         context,
// // //   //         Icons.chat,
// // //   //             () => showAdvancedDialog(context),
// // //   //         color: AppColors.PRIMARY_COLOR,
// // //   //       ),
// // //   //       FloatingActionButton.small(
// // //   //         backgroundColor: Colors.red,
// // //   //         onPressed: () async {
// // //   //           if (user != null) {
// // //   //             final userId = cardUser.sId ?? '';
// // //   //             if (userId.isNotEmpty && user.isMyAccount(userId)) {
// // //   //               Navigator.push(
// // //   //                 context,
// // //   //                 MaterialPageRoute(
// // //   //                   builder: (context) => UserProfilePage(userData: cardUser),
// // //   //                 ),
// // //   //               );
// // //   //             } else {
// // //   //               for (var element in listOfUsers) {
// // //   //                 if (user.isMyAccount(element.sId ?? '')) {
// // //   //                   Navigator.push(
// // //   //                     context,
// // //   //                     MaterialPageRoute(
// // //   //                       builder: (context) => UserProfilePage(userData: cardUser),
// // //   //                     ),
// // //   //                   );
// // //   //                   break;
// // //   //                 }
// // //   //               }
// // //   //             }
// // //   //           }
// // //   //         },
// // //   //         shape: const CircleBorder(),
// // //   //         child: const Icon(Icons.add_photo_alternate_outlined, color: Colors.white),
// // //   //       ),
// // //   //       _buildFloatingActionButton(
// // //   //         context,
// // //   //         Icons.card_giftcard,
// // //   //             () {
// // //   //           showModalBottomSheet(
// // //   //             context: context,
// // //   //             builder: (context) => GiftBottomSheet(),
// // //   //           );
// // //   //         },
// // //   //         color: AppColors.ACCENT_COLOR,
// // //   //       ),
// // //   //       _buildFloatingActionButton(
// // //   //         context,
// // //   //         Icons.report,
// // //   //             () {
// // //   //           if (user != null) {
// // //   //             showModalBottomSheet(
// // //   //               context: context,
// // //   //               builder: (context) => SizedBox(
// // //   //                 height: MediaQuery.of(context).size.height / 1.5,
// // //   //                 child: Padding(
// // //   //                   padding: const EdgeInsets.all(8.0),
// // //   //                   child: ReportView(id: user.id, categoryId: ''),
// // //   //                 ),
// // //   //               ),
// // //   //             );
// // //   //           }
// // //   //         },
// // //   //         color: Colors.red,
// // //   //       ),
// // //   //     ],
// // //   //   );
// // //   // }
// // //   Widget _buildFloatingActionButton(
// // //       BuildContext context, IconData icon, VoidCallback? onPressed,
// // //       {Color? color, required String heroTag}) {
// // //     return FloatingActionButton.small(
// // //       heroTag: heroTag,
// // //       onPressed: onPressed,
// // //       backgroundColor: color,
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
// // //       child: Icon(icon, color: color != null ? Colors.white : null),
// // //     );
// // //   }
// // //
// // //   Widget _buildActions(BuildContext context, List<UserData> listOfUsers,
// // //       {required UserData cardUser}) {
// // //     return Row(
// // //       mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //       children: [
// // //         _buildFloatingActionButton(
// // //           context,
// // //           Icons.person,
// // //           () {
// // //             context.push(Routes.OTHERSACCOUNT);
// // //           },
// // //           heroTag: 'personButton',
// // //         ),
// // //         _buildFloatingActionButton(
// // //           context,
// // //           Icons.chat,
// // //           () => showAdvancedDialog(context),
// // //           color: AppColors.PRIMARY_COLOR,
// // //           heroTag: 'chatButton',
// // //         ),
// // //         FloatingActionButton.small(
// // //           heroTag: 'photoButton',
// // //           backgroundColor: Colors.red,
// // //           onPressed: () async {
// // //             final user = context.read<UserCubit>().state.data;
// // //
// // //             if (user != null) {
// // //               final userId = cardUser.sId ?? '';
// // //               if (userId.isNotEmpty && user.isMyAccount(userId)) {
// // //                 Navigator.push(
// // //                   context,
// // //                   MaterialPageRoute(
// // //                     builder: (context) => UserProfilePage(userData: cardUser),
// // //                   ),
// // //                 );
// // //               } else {
// // //                 for (var element in listOfUsers) {
// // //                   if (user.isMyAccount(element.sId ?? '')) {
// // //                     Navigator.push(
// // //                       context,
// // //                       MaterialPageRoute(
// // //                         builder: (context) =>
// // //                             UserProfilePage(userData: cardUser),
// // //                       ),
// // //                     );
// // //                     break;
// // //                   }
// // //                 }
// // //               }
// // //             }
// // //           },
// // //           shape: const CircleBorder(),
// // //           child: const Icon(Icons.add_photo_alternate_outlined,
// // //               color: Colors.white),
// // //         ),
// // //         _buildFloatingActionButton(
// // //           context,
// // //           Icons.card_giftcard,
// // //           () {
// // //             showModalBottomSheet(
// // //               context: context,
// // //               builder: (context) => GiftBottomSheet(),
// // //             );
// // //           },
// // //           color: AppColors.ACCENT_COLOR,
// // //           heroTag: 'giftButton',
// // //         ),
// // //         _buildFloatingActionButton(
// // //           context,
// // //           Icons.report,
// // //           () {
// // //             final user = context.read<UserCubit>().state.data;
// // //             showModalBottomSheet(
// // //               context: context,
// // //               builder: (context) => SizedBox(
// // //                 height: MediaQuery.of(context).size.height / 1.5,
// // //                 child: Padding(
// // //                   padding: const EdgeInsets.all(8.0),
// // //                   child: ReportView(id: user!.id, categoryId: ''),
// // //                 ),
// // //               ),
// // //             );
// // //           },
// // //           color: Colors.red,
// // //           heroTag: 'reportButton',
// // //         ),
// // //       ],
// // //     );
// // //   }
// // //
// // //   // void _showPopupMenu(BuildContext context) {
// // //   //   final RenderBox overlay =
// // //   //       Overlay.of(context).context.findRenderObject() as RenderBox;
// // //
// // //   //   showMenu(
// // //   //     context: context,
// // //   //     position: RelativeRect.fromRect(
// // //   //       Rect.fromCenter(
// // //   //         center: overlay.size.center(Offset.zero),
// // //   //         width: 300,
// // //   //         height: 300,
// // //   //       ),
// // //   //       Offset.zero & overlay.size,
// // //   //     ),
// // //   //     items: [
// // //   //       PopupMenuItem<int>(
// // //   //         value: 0,
// // //   //         child: Text("Anonymous Chat"),
// // //   //       ),
// // //   //       PopupMenuItem<int>(
// // //   //         value: 1,
// // //   //         child: Text("Normal Chat"),
// // //   //       ),
// // //   //     ],
// // //   //   ).then((value) {
// // //   //     if (value == 0) {
// // //   //       Navigator.push(
// // //   //         context,
// // //   //         MaterialPageRoute(builder: (context) => AnonymousChatScreen()),
// // //   //       );
// // //   //     } else if (value == 1) {
// // //   //       Navigator.push(
// // //   //         context,
// // //   //         MaterialPageRoute(builder: (context) => NormalChatScreen()),
// // //   //       );
// // //   //     }
// // //   //   });
// // //   // }
// // //   // void showAdvancedDialog(BuildContext context) {
// // //   //   showDialog(
// // //   //     context: context,
// // //   //     builder: (BuildContext context) {
// // //   //       return AlertDialog(
// // //   //         title: Text("Select Chat Type"),
// // //   //         content: Row(
// // //   //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //   //           children: [
// // //   //             Expanded(
// // //   //               child: Card(
// // //   //                 child: Padding(
// // //   //                   padding: const EdgeInsets.all(8.0),
// // //   //                   child: Column(
// // //   //                     mainAxisSize: MainAxisSize.min,
// // //   //                     children: [
// // //   //                       IconButton(
// // //   //                         icon: Icon(
// // //   //                           Icons.person_outline,
// // //   //                           size: 30,
// // //   //                         ),
// // //   //                         onPressed: () {
// // //   //                           Navigator.pop(context);
// // //   //                           context.push(Routes.CHATROOM);
// // //   //
// // //   //                           // Navigator.push(
// // //   //                           //   context,
// // //   //                           //   MaterialPageRoute(
// // //   //                           //       builder: (context) => AnonymousChatScreen()),
// // //   //                           // );
// // //   //                         },
// // //   //                       ),
// // //   //                       Text("Anonymous Chat"),
// // //   //                     ],
// // //   //                   ),
// // //   //                 ),
// // //   //               ),
// // //   //             ),
// // //   //             Expanded(
// // //   //               child: Card(
// // //   //                 child: Padding(
// // //   //                   padding: const EdgeInsets.all(8.0),
// // //   //                   child: Column(
// // //   //                     mainAxisSize: MainAxisSize.min,
// // //   //                     children: [
// // //   //                       IconButton(
// // //   //                         icon: Icon(
// // //   //                           Icons.person,
// // //   //                           size: 30,
// // //   //                         ),
// // //   //                         onPressed: () {
// // //   //                           Navigator.pop(context);
// // //   //                           Navigator.push(
// // //   //                             context,
// // //   //                             MaterialPageRoute(
// // //   //                                 builder: (context) => NormalChatScreen()),
// // //   //                           );
// // //   //                         },
// // //   //                       ),
// // //   //                       Text("Normal Chat"),
// // //   //                     ],
// // //   //                   ),
// // //   //                 ),
// // //   //               ),
// // //   //             ),
// // //   //           ],
// // //   //         ),
// // //   //       );
// // //   //     },
// // //   //   );
// // //   // }
// // //   void showAdvancedDialog(BuildContext context) {
// // //     showDialog(
// // //       context: context,
// // //       builder: (BuildContext context) {
// // //         return AlertDialog(
// // //           title: Text("Select Chat Type"),
// // //           content: Row(
// // //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //             children: [
// // //               Expanded(
// // //                 child: Card(
// // //                   child: Padding(
// // //                     padding: const EdgeInsets.all(8.0),
// // //                     child: Column(
// // //                       mainAxisSize: MainAxisSize.min,
// // //                       children: [
// // //                         IconButton(
// // //                           icon: Icon(
// // //                             Icons.person_outline,
// // //                             size: 30,
// // //                           ),
// // //                           onPressed: () {
// // //                             Navigator.pop(context);
// // //                             context.push(Routes.CHATROOM);
// // //                           },
// // //                         ),
// // //                         Text("Anonymous Chat"),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //               Expanded(
// // //                 child: Card(
// // //                   child: Padding(
// // //                     padding: const EdgeInsets.all(8.0),
// // //                     child: Column(
// // //                       mainAxisSize: MainAxisSize.min,
// // //                       children: [
// // //                         IconButton(
// // //                           icon: Icon(
// // //                             Icons.person,
// // //                             size: 30,
// // //                           ),
// // //                           onPressed: () {
// // //                             Navigator.pop(context);
// // //                             context.push(Routes.CHAT);
// // //                           },
// // //                         ),
// // //                         Text("Normal Chat"),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // // // Widget _buildFloatingActionButton(
// // // //     BuildContext context, IconData icon, VoidCallback? onPressed,
// // // //     {Color? color}) {
// // // //   return FloatingActionButton.small(
// // // //     onPressed: onPressed,
// // // //     backgroundColor: color,
// // // //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
// // // //     child: Icon(icon, color: color != null ? Colors.white : null),
// // // //   );
// // // // }
// // // }
// // //
// // // class GiftBottomSheet extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return SingleChildScrollView(
// // //       child: Column(
// // //         mainAxisSize: MainAxisSize.min,
// // //         children: [
// // //           Padding(
// // //             padding: const EdgeInsets.all(16.0),
// // //             child: Text(
// // //               'الهدايا',
// // //               style: TextStyle(
// // //                   fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
// // //             ),
// // //           ),
// // //           ListTile(
// // //             leading: Image.network(
// // //               'https://your-correct-image-url/lion.png',
// // //               width: 50,
// // //               height: 50,
// // //               errorBuilder: (BuildContext context, Object exception,
// // //                   StackTrace? stackTrace) {
// // //                 return Icon(Icons.error, color: Colors.red, size: 50);
// // //               },
// // //             ),
// // //             title: Text('اسد', style: TextStyle(fontSize: 22)),
// // //             trailing: Text('500 جنيه مصري', style: TextStyle(fontSize: 22)),
// // //           ),
// // //           ListTile(
// // //             leading: Icon(Icons.money, color: Colors.green, size: 50),
// // //             title: Text('اموال', style: TextStyle(fontSize: 22)),
// // //             trailing: Text('400 جنيه مصري', style: TextStyle(fontSize: 22)),
// // //           ),
// // //           ListTile(
// // //             leading: Icon(Icons.card_giftcard, color: Colors.red, size: 50),
// // //             title: Text('صندوق هدايا', style: TextStyle(fontSize: 22)),
// // //             trailing: Text('300 جنيه مصري', style: TextStyle(fontSize: 22)),
// // //           ),
// // //           ListTile(
// // //             leading: Icon(Icons.local_florist, color: Colors.pink, size: 50),
// // //             title: Text('باقة ورود', style: TextStyle(fontSize: 22)),
// // //             trailing: Text('200 جنيه مصري', style: TextStyle(fontSize: 22)),
// // //           ),
// // //           ListTile(
// // //             leading: Image.network(
// // //               'https://your-correct-image-url/butterfly.png',
// // //               width: 50,
// // //               height: 50,
// // //               errorBuilder: (BuildContext context, Object exception,
// // //                   StackTrace? stackTrace) {
// // //                 return Icon(Icons.error, color: Colors.red, size: 50);
// // //               },
// // //             ),
// // //             title: Text('فراشة', style: TextStyle(fontSize: 22)),
// // //             trailing: Text('100 جنيه مصري', style: TextStyle(fontSize: 22)),
// // //           ),
// // //           ListTile(
// // //             leading: Icon(Icons.star, color: Colors.yellow, size: 50),
// // //             title: Text('نجمة', style: TextStyle(fontSize: 22)),
// // //             trailing: Text('50 جنيه مصري', style: TextStyle(fontSize: 22)),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // // class HomeScreen extends StatelessWidget {
// // // //   void _showPopupMenu(BuildContext context) {
// // // //     showMenu(
// // // //       context: context,
// // // //       position:
// // // //           RelativeRect.fromLTRB(100, 100, 0, 0), // Adjust position as needed
// // // //       items: [
// // // //         PopupMenuItem<int>(
// // // //           value: 0,
// // // //           child: Text("Anonymous Chat"),
// // // //         ),
// // // //         PopupMenuItem<int>(
// // // //           value: 1,
// // // //           child: Text("Normal Chat"),
// // // //         ),
// // // //       ],
// // // //     ).then((value) {
// // // //       if (value == 0) {
// // // //         Navigator.push(
// // // //           context,
// // // //           MaterialPageRoute(builder: (context) => AnonymousChatScreen()),
// // // //         );
// // // //       } else if (value == 1) {
// // // //         Navigator.push(
// // // //           context,
// // // //           MaterialPageRoute(builder: (context) => NormalChatScreen()),
// // // //         );
// // // //       }
// // // //     });
// // // //   }
// // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text('Home Screen'),
// // // //       ),
// // // //       body: Center(
// // // //         child: Text('Welcome to Home Screen'),
// // // //       ),
// // // //       floatingActionButton: FloatingActionButton(
// // // //         onPressed: () => _showPopupMenu(context),
// // // //         child: Icon(Icons.add),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // //
// // // class AnonymousChatScreen extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Anonymous Chat'),
// // //       ),
// // //       body: Center(
// // //         child: Text('Welcome to Anonymous Chat'),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // // class NormalChatScreen extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Normal Chat'),
// // //       ),
// // //       body: Center(
// // //         child: Text('Welcome to Normal Chat'),
// // //       ),
// // //     );
// // //   }
// // // }
// // // //rommana2.4
// // //---------------------------------------------------------------------------
// //
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/consts/shared.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:intl/intl.dart';
import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import '../cubit/tinder_cubit.dart';
import '../cubit/tinder_state.dart';

class TinderView extends StatelessWidget {
  const TinderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TinderViewCubit()
        ..fetchUserData()
        ..fetchSubCategoryData(),
      child: BlocBuilder<TinderViewCubit, TinderViewState>(
        builder: (context, state) {
          return SharedScaffold(
            body: state.userData.isNotEmpty || state.subCategoryData.isNotEmpty
                ? Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Label(
                                text: 'Find',
                                style: Styles.headerText(fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height -
                                kToolbarHeight -
                                200,
                            child: Stack(
                              children: List.generate(
                                state.userData.length,
                                (index) {
                                  final cardUser = state.userData[index];
                                  return _buildCard(context, index, cardUser);
                                },
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade500,
                            height: 1,
                            width: double.infinity,
                          ),
                          if (state.subCategoryData.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 0.0),
                              child: SizedBox(
                                height: 200,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const Sizer(
                                    width: 0,
                                  ),
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: TinderSubCategoryCard(
                                        subCategory:
                                            state.subCategoryData[index]),
                                  ),
                                  itemCount: state.subCategoryData.length,
                                ),
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
            mainCategoryId: 2,
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index, UserData user) {
    final cubit = context.read<TinderViewCubit>();
    final state = cubit.state;
    final isFrontCard = index == state.currentIndex;

    return isFrontCard
        ? GestureDetector(
            onPanStart: (details) =>
                cubit.updatePanStart(details.globalPosition),
            onPanUpdate: (details) {
              final position = details.globalPosition - state.startDragOffset;
              final rotation = position.dx /
                  (position.dy > state.startDragOffset.dy - 180 ? 500 : -500);
              cubit.updatePanUpdate(position, rotation);
            },
            onPanEnd: (details) {
              if (state.position.dx > 250 ||
                  state.position.dx < -250 ||
                  state.position.dy > 250 ||
                  state.position.dy < -250) {
                cubit.swipeAway();
              } else {
                cubit.resetPan();
              }
            },
            onTapUp: (details) {
              final tapPosition = details.localPosition.dx;
              final screenWidth = MediaQuery.of(context).size.width;
              tapPosition < screenWidth / 2
                  ? cubit.previousStory()
                  : cubit.nextStory();
            },
            child: Transform.translate(
              offset: state.position,
              child: Transform.rotate(
                angle: state.rotation,
                child: _cardWidget(context, user),
              ),
            ),
          )
        : const Offstage();
  }

  Widget _cardWidget(BuildContext context, UserData user) {
    final state = context.read<TinderViewCubit>().state;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: Stack(
          children: [
            Hero(
              tag: 'userHero-${user.sId}',
              child: Image.network(
                user.pictures!.isNotEmpty
                    ? user.pictures![state.currentStoryIndex].mediaKey ?? ''
                    : UIConst.profilePlaceHolder,
                errorBuilder: (context, error, stackTrace) => Image.network(
                    UIConst.profilePlaceHolder,
                    fit: BoxFit.fitHeight,
                    height: double.infinity),
                fit: BoxFit.fitHeight,
                height: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 25),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: IconButton(
                        onPressed: () => switchDisplayGender(state, context),
                        iconSize: 50, // Icon size
                        icon: Icon(
                          user.user!.gender == 'male'
                              ? Icons.female
                              : Icons.male,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )),
            ),
            //story bar
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(user.pictures!.length, (dotIndex) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
                      height: 4,
                      decoration: BoxDecoration(
                        color: dotIndex == state.currentStoryIndex
                            ? Colors.red
                            : Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              bottom: kToolbarHeight * 1.1,
              right: 8,
              left: 8,
              child: _buildPersonInfo(context, user),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              left: 8,
              child: _buildActions(context, user),
            ),
          ],
        ),
      ),
    );
  }

  String getTimeAgo(String lastSeen) {
    DateTime lastSeenTime = DateTime.parse(lastSeen);
    DateTime now = DateTime.now().toUtc(); // Ensure we're using UTC

    Duration difference = now.difference(lastSeenTime);

    // Check if the last seen is more than a week old
    if (difference.inDays > 7) {
      // Format the date and time
      DateFormat dateFormat = DateFormat('EEEE, MMMM d, yyyy');
      DateFormat timeFormat = DateFormat('h:mm a');
      String formattedDate = dateFormat.format(lastSeenTime);
      String formattedTime = timeFormat.format(lastSeenTime);
      return 'Date: $formattedDate\nTime: $formattedTime';
    } else if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes == 1) {
      return "1 minute ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours == 1) {
      return "1 hour ago";
    } else {
      return "${difference.inHours} hours ago";
    }
  }

  Widget _buildPersonInfo(BuildContext context, UserData user) {
    return BlocConsumer<TinderViewCubit, TinderViewState>(
      builder: (context, state) {
        context
            .read<TinderViewCubit>()
            .checkUserNearby(cardUserId: user.user?.sId ?? '');
        log(user.user!.sId ?? '');
        context.read<TinderViewCubit>().fetchLastSeen(user.user!.sId ?? '');
        if (state.lastSeenModel != null && state.lastSeenModel!.data != null) {
          print(
              "${state.lastSeenModel?.data?.lastSeen}+++++++++++++++++++++++++++++++++++++++++++++");

          final lastSeen =
              getTimeAgo(state.lastSeenModel!.data?.lastSeen ?? '');

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BadgedLabel(
                      color: AppColors.WHATS_APP_COLOR,
                      label: state.lastSeenModel!.data!.status ?? '',
                    ),
                    const SizedBox(width: 10),
                    state.isUserNearby
                        ? const BadgedLabel(
                            color: AppColors.SECONDARY_COLOR, label: 'Nearby')
                        : const BadgedLabel(
                            color: AppColors.SECONDARY_COLOR,
                            label: 'is not Nearby'),
                  ],
                ),
                ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: null,
                    selected: false,
                    enabled: false,
                    title: OutlineText(
                      text: capitalizeAndSplit(
                          "${user.user!.firstName} ${user.user!.lastName}"),
                      textStyle: Styles.headerText(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: OutlineText(
                      text: "Last seen $lastSeen",
                      textStyle: Styles.mediumText(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
              ],
            ),
          );
        }
        //------------------
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const BadgedLabel(
                        color: AppColors.WHATS_APP_COLOR,
                        label: 'N/A',
                      ),
                      const SizedBox(width: 10),
                      state.isUserNearby
                          ? const BadgedLabel(
                              color: AppColors.SECONDARY_COLOR, label: 'Nearby')
                          : const BadgedLabel(
                              color: AppColors.SECONDARY_COLOR,
                              label: 'is not Nearby'),
                    ],
                  ),
                  ListTile(
                    selected: false,
                    enabled: false,
                    title: OutlineText(
                      text: capitalizeAndSplit(
                          "${user.user!.firstName} ${user.user!.lastName}"),
                      textStyle: Styles.headerText(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      listener: (BuildContext context, TinderViewState state) {},
    );
  }

  // _showGiftBottomSheet2(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.black.withOpacity(0.8),
  //     // To simulate the transparent effect
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) => BottomSheetContent(
  //       gifts: const [],
  //       cardUser: null,
  //       currentLoggedUser: null, subCategoryId: null,
  //     ),
  //   );
  // }

  Widget _buildActions(BuildContext context, UserData user) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFloatingActionButton(
            context,
            Icons.person,
            () => context.push(Routes.OTHERSACCOUNT),
            heroTag: 'personButton',
          ),
          _buildFloatingActionButton(
            context,
            Icons.chat,
            () => showAdvancedDialog(context),
            color: AppColors.PRIMARY_COLOR,
            heroTag: 'chatButton',
          ),
          _buildFloatingActionButton(
            context,
            Icons.add_photo_alternate_outlined,
            () => _navigateToUserProfile(context, user),
            color: Colors.red,
            heroTag: 'photoButton',
          ),
          _buildFloatingActionButton(
            context,
            Icons.card_giftcard,
            // () => _showGiftBottomSheet2,
            () => _showGiftBottomSheet22(
              cardUser: user,
              context,
            ),
            // () {
            //   context.read<TinderViewCubit>().fetchGifts();
            //   // BlocBuilder<TinderViewCubit, TinderViewState>(
            //   //   builder: (context, state) {
            //   //     log(state.gifts.first.toString()+"-------------------------");
            //   //
            //   //     return SizedBox();
            //   //   },
            //   // );
            // },
            color: AppColors.ACCENT_COLOR,
            heroTag: 'giftButton',
          ),
          _buildFloatingActionButton(
            context,
            Icons.report,
            () => _showReportBottomSheet(context, user),
            color: Colors.red,
            heroTag: 'reportButton',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(
      BuildContext context, IconData icon, VoidCallback? onPressed,
      {Color? color, required String heroTag}) {
    return FloatingActionButton.small(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Icon(icon, color: color != null ? Colors.white : null),
    );
  }

  // {
  //       status: true,
  //       data: {
  //           totalViews: 0,
  //           userId: "66a40f7d88dc22dcdbd14240",
  //           username: "user_ggimje6ri",
  //           firstName: "aleee",
  //           lastName: "alee",
  //           "https://49hub-reels.s3.eu-central-1.amazonaws.com/ride/twitter/66a4118c8a30f1
  //           1ecd8f9edd/eeed6270-6a1c-4d76-a3ed-4bb015e1160c.png?X-Amz-Algorithm=AWS4-HMAC-
  //           SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMK
  //           AMUH%2F20240808%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240808T083911Z
  //           &X-Amz-Expires=3600&X-Amz-Signature=7bfbcb79e45e66ea91b87388ea07ddd9e9826093ee
  //           19450a422e4fdf37e44321&X-Amz-SignedHeaders=host&x-id=GetObject"
  //           "Beyond my work in web development, I have a deep love for photography. Captur
  //           ing the beauty of the world through my lens allows me to blend my technical sk
  //           ills with my artistic vision. Whether it's a stunning landscape or a candid mo
  //           ment, photography inspires me to see the world from new perspectives and fuels
  //            my creativity in both my personal and professional life."
  //           friendsCount: 1,
  //           followersCount: 4,
  //           followingCount: 1,
  //           postCount: 0
  //      }
  //  }

  void _navigateToUserProfile(BuildContext context, UserData cardUser) {
    final userState = context.read<UserCubit>().state.data;
    debugPrint(
        "${cardUser.user?.email}=======================${userState!.email}");
    if (userState.isMyAccount(cardUser.user!.sId ?? '')) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserProfilePage(userData: cardUser)),
      );
    }
  }

  // Future<GiftBottomSheet> _showGiftBottomSheet(BuildContext context) async {
  //   List<GiftData>? giftData =
  //       await context.read<TinderViewCubit>().fetchGifts();
  //   log('${giftData!.first.nameAr}//////////////////////////////////////');
  //   return GiftBottomSheet(gifts: giftData);
  // }

  Future<void> _showGiftBottomSheet(BuildContext context,
      {required cardUser}) async {
    final currentLoggedUser = context.read<UserCubit>().state.data;
    List<GiftData>? giftData =
        await context.read<TinderViewCubit>().fetchGifts();
    log('${giftData.toString()}//////////////////////////////////////');

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) => GiftBottomSheet(
        gifts: giftData,
        cardUser: cardUser,
        currentLoggedUser: currentLoggedUser,
      ),
    );
  }

  _showGiftBottomSheet22(BuildContext context, {required cardUser}) async {
    final currentLoggedUser = context.read<UserCubit>().state.data;
    List<GiftData>? giftData =
        await context.read<TinderViewCubit>().fetchGifts();
    log('${giftData.toString()}//////////////////////////////////////');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.8),
      // To simulate the transparent effect
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      // ),
      builder: (context) => BottomSheetContent(
        gifts: giftData,
        cardUser: cardUser,
        currentLoggedUser: currentLoggedUser,
        subCategoryId: null,
      ),
    );
  }

  void _showReportBottomSheet(BuildContext context, UserData user) {
    final userState = context.read<UserCubit>().state.data;
    if (userState != null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReportView(id: userState.id, categoryId: ''),
          ),
        ),
      );
    }
  }

  void switchDisplayGender(TinderViewState state, BuildContext context) {
    final gender = state.userData.first.user!.gender.toString();
    context
        .read<TinderViewCubit>()
        .fetchUserData(gender: gender == 'female' ? 'female' : 'male');
  }

  void showAdvancedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Chat Type"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildChatOptionCard(
                context,
                icon: Icons.person_outline,
                label: "Anonymous Chat",
                route: Routes.CHATROOM,
              ),
              _buildChatOptionCard(
                context,
                icon: Icons.person,
                label: "Normal Chat",
                route: Routes.CHAT,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatOptionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(icon, size: 30),
                onPressed: () {
                  Navigator.pop(context);
                  context.push(route);
                },
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

// class GiftBottomSheet1 extends StatelessWidget {
//   const GiftBottomSheet1({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'الهدايا',
//               style: TextStyle(
//                   fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
//             ),
//           ),
//           _buildGiftItem(
//             context,
//             'assets/images/lion.png',
//             'اسد',
//             '500 جنيه مصري',
//           ),
//           _buildGiftItem(
//             context,
//             'assets/images/salary.png',
//             'اموال',
//             '400 جنيه مصري',
//           ),
//           _buildGiftItem(
//             context,
//             'assets/images/gift-box.png',
//             'صندوق هدايا',
//             '300 جنيه مصري',
//           ),
//           _buildGiftItem(
//             context,
//             'assets/images/rose.png',
//             'باقة ورود',
//             '200 جنيه مصري',
//           ),
//           _buildGiftItem(
//             context,
//             'assets/images/butterfly.png',
//             'فراشة',
//             '100 جنيه مصري',
//           ),
//           _buildGiftItem(
//             context,
//             'assets/images/star.png',
//             'نجمة',
//             '50 جنيه مصري',
//             iconColor: Colors.yellow,
//           ),
//         ],
//       ),
//     );
//   }
//
//
// }
//....

void showGiftSentPopup(BuildContext context, String? amount) {
  Navigator.pop(context);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: const Row(
          children: [
            Icon(Icons.card_giftcard, color: Colors.green, size: 30),
            // Gift icon
            SizedBox(width: 10),
            // Spacing between icon and title
            Text(
              'Gift Sent',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          // Use minimum size for the dialog
          children: [
            const SizedBox(height: 10),
            // Spacing
            Text(
              amount != null
                  ? 'The gift has been sent successfully!\nAmount deducted: ¥$amount' // Using ¥ as a generic currency symbol
                  : 'The gift has been sent successfully!',

              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.left, // Center the text
            ),
            const SizedBox(height: 20),
            // More spacing
            // Optional: Add a decorative element
            const Icon(Icons.check_circle, color: Colors.green, size: 50),
            // Success icon
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigo, // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      );
    },
  );
}

// void showInsufficientFundsPopup(BuildContext context, String? message) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         title: const Row(
//           children: [
//             Icon(Icons.money_off, color: Colors.red, size: 30), // Related icon
//             SizedBox(width: 10), // Spacing between icon and title
//             Text('Insufficient Funds'),
//           ],
//         ),
//         content: Text(
//           message ?? 'You do not have enough money in your wallet.',
//           style: const TextStyle(fontSize: 16),
//         ),
//         actionsAlignment: MainAxisAlignment.spaceBetween,
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.white,
//               backgroundColor: Colors.red, // Button color
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             child: const Text('OK'),
//           ),
//           TextButton(
//             onPressed: () {
//               // Add your logic to charge the wallet here
//               Navigator.of(context).pop(); // Optionally close the dialog
//               // Navigate to the charge wallet screen or perform the charge action
//               // Navigator.push(context, MaterialPageRoute(builder: (context) => ChargeWalletScreen()));
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.white,
//               backgroundColor: Colors.indigo,
//               // Different color for the charge button
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//             child: const Text('Charge Wallet'),
//           ),
//         ],
//       );
//     },
//   );
// }
void showInsufficientFundsPopup(BuildContext context, String? message) {
  Navigator.pop(context);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: const Row(
          children: [
            Icon(Icons.money_off, color: Colors.red, size: 30), // Related icon
            SizedBox(width: 10), // Spacing between icon and title
            Text('Insufficient Funds'),
          ],
        ),
        content: message == 'Unexpected response format.'
            ? SizedBox(
                height: 50, // Adjust height as needed
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LinearProgressIndicator(), // Show progress indicator
                    const SizedBox(height: 10), // Spacing
                    Text(
                      message!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Text(
                message ?? 'You do not have enough money in your wallet.',
                style: const TextStyle(fontSize: 16),
              ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red, // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              // Add your logic to charge the wallet here
              Navigator.of(context).pop(); // Optionally close the dialog
              // Navigate to the charge wallet screen or perform the charge action
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ChargeWalletScreen()));
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.indigo,
              // Different color for the charge button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Charge Wallet'),
          ),
        ],
      );
    },
  );
}

String handleResponse(String jsonResponse, BuildContext context) {
  print("Raw JSON response: $jsonResponse"); // Debugging output

  // Check if the response is null or empty
  if (jsonResponse.isEmpty) {
    // showInsufficientFundsPopup(context, "No data received.");
    return "No data received.";
  }

  try {
    // Decode the JSON response
    Map<String, dynamic> response = json.decode(jsonResponse);

    if (response['success'] == false) {
      // Handle the error response
      String errorMessage =
          response['error']['message'] ?? "Unknown error occurred.";
      return errorMessage;
    } else if (response['status'] == true) {
      // Handle the success response
      String successMessage = response['message'] ?? "Gift sent successfully!";
      return successMessage;
    } else {
      return "Unexpected response format.";
    }
  } catch (e) {
    // Handle JSON decoding errors
    print("Error decoding JSON: $e");
    return "An error occurred while processing the response.";
  }
}

Widget _buildGiftItem({
  required BuildContext context,
  required GiftData gift,
  required receiverId,
  required giftId,
  required subCategoryId,
  required UserEntity currentLoggedUser,
}) {
  return BlocProvider(
    create: (context) => TinderViewCubit()..fetchGifts(),
    child: BlocBuilder<TinderViewCubit, TinderViewState>(
      builder: (context, state) {
        return InkWell(
          // onTap: () {
          //   // Assuming this is where you get the snapshot data
          //   print("Snapshot data: ${snapshot.data.toString()} /***************");
          //
          //   // Check if snapshot.data is not null or empty
          //   if (snapshot.data == null || snapshot.data!.isEmpty) {
          //     print("Error: No data received");
          //     showInsufficientFundsPopup(context, "No data received.");
          //     return;
          //   }
          //
          //   // Attempt to decode the JSON data
          //   // try {
          //   // Map<String, dynamic> successData =
          //   //     json.decode(snapshot.data ?? '');
          //   //
          //   // // log("${successData['success']}**********************");
          //   // log("${successData}--------------------------------------");
          //   //
          //   // if (successData['success'] == false) {
          //   //   showInsufficientFundsPopup(
          //   //       context, state.sendGiftErrorData!.message);
          //   // } else {
          //   //   showGiftSentPopup(context, '10');
          //   // }
          //   // } catch (e) {
          //   // Handle JSON decoding errors
          //   // print("Error decoding JSON: ");
          //   // showInsufficientFundsPopup(context, "Invalid response format.");
          //   // }
          // },
          onTap: () async {
            final data = await context.read<TinderViewCubit>().sendGift(
                  receiverId: receiverId,
                  giftId: giftId,
                  subCategoryId: subCategoryId,
                  currentUserToken: 'currentUserToken',
                );
            // handleResponse(snapshot.data ?? '', context);
            // Use switch case to handle different response types
            print("${data}oppppppppppppppppppppppppp");
            switch (data) {
              case """{"success":false,"error":{"name":"Bad Request","httpCode":400,"message":"You does not have enough money in the wallet","data":{},"isOperational":true,"stack":"","domain":"49dev.com"}}""":
                showInsufficientFundsPopup(
                    context, 'You do not have enough money in your wallet.');

                break;

              case """{"status":true,"message":"sent Gift Successfully"}""":
                showGiftSentPopup(context, '10');
                break;

              default:
                showInsufficientFundsPopup(
                    context, 'Unexpected response format.');
                break;
            }
          },
          // onTap: () {
          //   // context.read<TinderViewCubit>().sendGift(
          //   //       currentUserToken: currentLoggedUser.id,
          //   //       receiverId: receiverId,
          //   //       giftId: giftId,
          //   //       subCategoryId: subCategoryId,
          //   //     );
          //   // if (state.sendGiftErrorData!.message.toString() ==
          //   //     'You does not have enough money in the wallet') {
          //   //   showInsufficientFundsPopup(
          //   //       context, state.sendGiftErrorData!.message);
          //   // }
          //   // if (state.sendGiftErrorData!.message!.trim() ==
          //   //     'You does not have enough money in the wallet') {
          //   //   showInsufficientFundsPopup(
          //   //       context, state.sendGiftErrorData!.message);
          //   // }
          //   print(snapshot.data);
          //   // List<dynamic> successData = json.decode('[${snapshot.data}]');
          //   Map<String, dynamic> successData =
          //       json.decode(snapshot.data ?? '');
          //
          //   log("${successData['success']}**********************");
          //   log("${successData['status']}**********************");
          //   // bool containsMessage = successData
          //   //     .any((item) => item['message'] == 'sent Gift Successfully');
          //   if (successData['success'] == false) {
          //     showInsufficientFundsPopup(
          //         context, state.sendGiftErrorData!.message);
          //   } else {
          //     showGiftSentPopup(context, '10');
          //   }
          //   //   showInsufficientFundsPopup(
          //   //       context, state.sendGiftErrorData!.message);
          // },
          child: Column(
            children: [
              ListTile(
                leading: Image.network(
                  gift.picture!,
                  width: 50,
                  height: 50,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Icon(Icons.error, color: Colors.red, size: 50);
                  },
                ),
                title: Text(gift.nameEn!, style: const TextStyle(fontSize: 22)),
                trailing: Text(gift.value.toString(),
                    style: const TextStyle(fontSize: 22)),
              ),
              const Divider(),
            ],
          ),
        );
      },
    ),
  );
}

// class GiftsPage extends StatelessWidget {
//   const GiftsPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => TinderViewCubit()..fetchGifts(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Gifts'),
//         ),
//         body: BlocBuilder<TinderViewCubit, TinderViewState>(
//           builder: (context, state) {
//             if (state.gifts.isEmpty) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             return ListView.builder(
//               itemCount: state.gifts.length,
//               itemBuilder: (context, index) {
//                 final gift = state.gifts[index];
//                 return ListTile(
//                   title: Text(gift.nameEn ?? 'No Name'),
//                   subtitle: Text('Value: ${gift.value ?? 'N/A'}'),
//                   leading: gift.picture != null
//                       ? Image.network(
//                           'https://49dev.com/${gift.picture![index]}',
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                         )
//                       : const Icon(Icons.card_giftcard),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

class GiftBottomSheet extends StatelessWidget {
  final List<GiftData>? gifts;

  final UserData cardUser;

  final UserEntity? currentLoggedUser;

  const GiftBottomSheet({
    super.key,
    required this.gifts,
    required this.cardUser,
    required this.currentLoggedUser,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // child: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     const Padding(
      //       padding: EdgeInsets.all(16.0),
      //       child: Text(
      //         'الهدايا',
      //         style: TextStyle(
      //             fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
      //       ),
      //     ),
      //     _buildGiftItem(
      //       context,
      //       'assets/images/lion.png',
      //       'اسد',
      //       '500 جنيه مصري',
      //     ),
      //     _buildGiftItem(
      //       context,
      //       'assets/images/salary.png',
      //       'اموال',
      //       '400 جنيه مصري',
      //     ),
      //     _buildGiftItem(
      //       context,
      //       'assets/images/gift-box.png',
      //       'صندوق هدايا',
      //       '300 جنيه مصري',
      //     ),
      //     _buildGiftItem(
      //       context,
      //       'assets/images/rose.png',
      //       'باقة ورود',
      //       '200 جنيه مصري',
      //     ),
      //     _buildGiftItem(
      //       context,
      //       'assets/images/butterfly.png',
      //       'فراشة',
      //       '100 جنيه مصري',
      //     ),
      //     _buildGiftItem(
      //       context,
      //       'assets/images/star.png',
      //       'نجمة',
      //       '50 جنيه مصري',
      //       iconColor: Colors.yellow,
      //     ),
      //   ],
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Send a gift',
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(2),
              itemCount: gifts!.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final gift = gifts![index];
                // return ListTile(
                //   title: Text(gift.nameEn ?? 'No Name'),
                //   subtitle: Text('Value: ${gift.value ?? 'N/A'}'),
                //   leading: gift.picture != null
                //       ? Image.network(
                //           'https://49dev.com/${gift.picture!.mediaKey}',
                //           width: 50,
                //           height: 50,
                //           fit: BoxFit.cover,
                //         )
                //       : const Icon(Icons.card_giftcard),
                // );
                log('${gift.picture} ==================');
                return _buildGiftItem(
                  currentLoggedUser: currentLoggedUser!,
                  giftId: gift.sId,
                  subCategoryId: '66af974f8bf69f9469944746',
                  receiverId: cardUser.user!.sId,
                  gift: gift,
                  context: context,
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
//last 1
