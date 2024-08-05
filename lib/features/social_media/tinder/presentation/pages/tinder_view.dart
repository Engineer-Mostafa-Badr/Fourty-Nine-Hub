// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/functions/global/upload_file.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/sub_categories/sub_category_card.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
// import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
// import 'package:fourtyninehub/res/style/const.dart';
// import 'package:fourtyninehub/routes/routes.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
// import '../../../../../res/style/app_colors.dart';
// import '../../../../../res/style/styles.dart';
// import '../cubit/tinder_cubit.dart';
// import '../cubit/tinder_state.dart';

// class TinderView extends StatelessWidget {
//   const TinderView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => TinderViewCubit()
//         ..fetchUserData()
//         ..fetchSubCategoryData(),
//       child: BlocBuilder<TinderViewCubit, TinderViewState>(
//         builder: (context, state) {
//           return SharedScaffold(
//             body: state.userData.isEmpty
//                 ? Builder(builder: (context) {
//                     // context.read<TinderViewCubit>().fetchUserData();
//                     return const Center(child: CircularProgressIndicator());
//                   })
//                 : Stack(
//                     children: [
//                       SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8.0),
//                               child: Align(
//                                 alignment: Alignment.topLeft,
//                                 child: Label(
//                                   text: 'Find',
//                                   style: Styles.headerText(),
//                                 ),
//                               ),
//                             ),
//                             // const Divider(),
//                             SizedBox(
//                               height: MediaQuery.of(context).size.height -
//                                   kToolbarHeight -
//                                   200,
//                               child: Stack(
//                                 children:
//                                     state.userData.asMap().entries.map((entry) {
//                                   int index = entry.key;
//                                   UserData user = entry.value;
//                                   return _buildCard(
//                                       context, index, user.pictures, user);
//                                 }).toList(),
//                               ),
//                             ),
//                             // // const Divider(),
//                             // SizedBox(
//                             //   height: 160,
//                             //   child: Padding(
//                             //     padding:
//                             //         const EdgeInsets.symmetric(horizontal: 0.0),
//                             //     child: ListView.builder(
//                             //       scrollDirection: Axis.horizontal,
//                             //       itemCount: state.subCategoryData.length,
//                             //       itemBuilder: (context, index) {
//                             //         return Card(
//                             //           clipBehavior: Clip.hardEdge,
//                             //           color: Colors.transparent,
//                             //           child: FittedBox(
//                             //             child: Container(
//                             //               decoration: BoxDecoration(
//                             //                   image: DecorationImage(
//                             //                       image: NetworkImage(state
//                             //                           .subCategoryData[index]
//                             //                           .picture
//                             //                           .toString()))),
//                             //               width: 160,
//                             //               height: 160,
//                             //               child: Align(
//                             //                 alignment: Alignment.bottomCenter,
//                             //                 child: Container(
//                             //                   width: double.infinity,
//                             //                   color: Colors.white54,
//                             //                   child: Text(
//                             //                     '${state.subCategoryData[index].nameEn}',
//                             //                     textAlign: TextAlign.center,
//                             //                     textScaler:
//                             //                         const TextScaler.linear(
//                             //                             1.2),
//                             //                     style: Styles.headerText(
//                             //                       fontWeight: FontWeight.w600,
//                             //                     ),
//                             //                   ),
//                             //                 ),
//                             //               ),
//                             //             ),
//                             //           ),
//                             //         );
//                             //       },
//                             //     ),
//                             //   ),
//                             // ),
//                             if (state.subCategoryData.isNotEmpty)
//                               SizedBox(
//                                 height: 200,
//                                 child: ListView.separated(
//                                   separatorBuilder: (context, index) =>
//                                       const Sizer(),
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 20),
//                                   scrollDirection: Axis.horizontal,
//                                   itemBuilder: (context, index) =>
//                                       TinderSubCategoryCard(
//                                           subCategory:
//                                               state.subCategoryData[index]),
//                                   itemCount: state.subCategoryData.length,
//                                 ),
//                               )
//                             else
//                               const SizedBox.shrink(),

//                             const SizedBox(
//                               height: 50,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//             mainCategoryId: 2,
//           );
//         },
//       ),
//     );
//   }

//   void switchDisplayGander(TinderViewState state, BuildContext context) {
//     state.userData.first.users.first.gender.toString() == 'female' //persons
//         ? context.read<TinderViewCubit>().fetchUserData(gender: 'female') //user
//         : context.read<TinderViewCubit>().fetchUserData(gender: 'male');
//   }

//   Widget _buildCard(
//       BuildContext context, int index, List<Picture> images, UserData user) {
//     final cubit = context.read<TinderViewCubit>();
//     final state = cubit.state;
//     bool isFrontCard = index == state.currentIndex;

//     return Positioned(
//       left: 0,
//       right: 0,
//       top: 0,
//       bottom: 0,
//       child: isFrontCard
//           ? GestureDetector(
//               onPanStart: (details) {
//                 cubit.updatePanStart(details.globalPosition);
//               },
//               onPanUpdate: (details) {
//                 final position = details.globalPosition - state.startDragOffset;
//                 final rotation = position.dx /
//                     (position.dy > state.startDragOffset.dy - 180 ? 500 : -500);
//                 cubit.updatePanUpdate(position, rotation);
//               },
//               onPanEnd: (details) {
//                 if (state.position.dx > 250 ||
//                     state.position.dx < -250 ||
//                     state.position.dy > 250 ||
//                     state.position.dy < -250) {
//                   cubit.swipeAway();
//                 } else {
//                   cubit.resetPan();
//                 }
//               },
//               onTapUp: (details) {
//                 double tapPosition = details.localPosition.dx;
//                 double screenWidth = MediaQuery.of(context).size.width;

//                 if (tapPosition < screenWidth / 2) {
//                   cubit.previousStory();
//                 } else {
//                   cubit.nextStory();
//                 }
//               },
//               child: Transform.translate(
//                 offset: state.position,
//                 child: Transform.rotate(
//                   angle: state.rotation,
//                   child:
//                       _cardWidget(context, images: user.pictures, user: user),
//                 ),
//               ),
//             )
//           : const Offstage(),
//     );
//   }

//   Widget _cardWidget(
//     BuildContext context, {
//     required List<Picture> images,
//     required UserData user,
//   }) {
//     final state = context.read<TinderViewCubit>().state;
//     return Padding(
//       padding: const EdgeInsets.all(0.0),
//       child: Card(
//         clipBehavior: Clip.hardEdge,
//         elevation: 6,
//         child: Stack(
//           children: [
//             Hero(
//               tag: 'userHero-${user.id}', // Ensure each hero tag is unique

//               child: Image.network(
//                 (images.isNotEmpty)
//                     ? images[state.currentStoryIndex].mediaKey
//                     : UIConst.profilePlaceHolder,
//                 errorBuilder: (context, error, stackTrace) => Image.network(
//                   UIConst.profilePlaceHolder,
//                   fit: BoxFit.fitHeight,
//                   height: double.infinity,
//                 ),
//                 fit: BoxFit.fitHeight,
//                 height: double.infinity,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 12.0, right: 8),
//               child: Align(
//                 alignment: Alignment.topRight,
//                 child: IconButton(
//                   onPressed: () {
//                     switchDisplayGander(state, context);
//                   },
//                   iconSize: 30,
//                   icon: Icon(
//                     user.users.first.gender == 'male'
//                         ? Icons.female
//                         : Icons.male,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 10,
//               left: 10,
//               right: 10,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(images.length, (dotIndex) {
//                   return Expanded(
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 2.0),
//                       height: 4,
//                       decoration: BoxDecoration(
//                         color: (dotIndex == state.currentStoryIndex)
//                             ? Colors.red
//                             : Colors.white54,
//                         borderRadius: BorderRadius.circular(2),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//             Positioned(
//               bottom: kToolbarHeight * 1.2,
//               right: 20,
//               left: 20,
//               child: _buildPersonInfo(context: context, user: user),
//             ),
//             Positioned(
//               bottom: 8,
//               right: 10,
//               left: 10,
//               child: _buildActions(context, state.userData, cardUser: user),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPersonInfo(
//       {required BuildContext context, required UserData user}) {
//     return InkWell(
//       onTap: () => context.push(Routes.OTHERSACCOUNT),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const BadgedLabel(
//                   color: AppColors.SECONDARY_COLOR,
//                   label: 'Nearby',
//                 ),
//                 ListTile(
//                   onTap: null,
//                   selected: false,
//                   enabled: false,
//                   title: Label(
//                     text:
//                         "${user.users.first.firstName} ${user.users.first.lastName}", // must start with capital...
//                     style: Styles.headerText(color: Colors.black, fontSize: 26),
//                   ),
//                   subtitle: Label(
//                     text: 'last seen 3 minute ago',
//                     style: Styles.mediumText(color: Colors.black),
//                   ),

//                   // leading: Icon(
//                   //   user.user.first.gender == 'male'
//                   //       ? Icons.male
//                   //       : Icons.female,
//                   //   color: Colors.black
//                   // ,
//                   //   size: 28,
//                   // ),
//                 ),
//                 // Label(
//                 //   text: user.user.first.birthday ?? '',
//                 //   style: Styles.smallText(color: Colors.white),
//                 // )
//               ],
//             ),
//           ),
//           const Icon(
//             Icons.arrow_upward_rounded,
//             color: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActions(BuildContext context, List<UserData> listOfUsers,
//       {required UserData cardUser}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         _buildFloatingActionButton(context, Icons.person, null),
//         _buildFloatingActionButton(context, Icons.chat, null,
//             color: AppColors.PRIMARY_COLOR),
//         FloatingActionButton.small(
//           backgroundColor: Colors.red,
//           onPressed: () {
//             // UploadFile().uploadImage(
//             //     subCategoryId: '66af974f8bf69f9469944746',
//             //     onUploaded: (p0) {
//             //       context
//             //           .read<TinderViewCubit>()
//             //           .uploadImages(mediaIds: [p0.mediaId]);
//             //       log("${p0.file.path}-----------===========");
//             //     });
// //--------------------------
//             final user = context.read<UserCubit>().state.data;
//             log("${user?.firstName}pppppppppppppppppppppppppppppppppppppppp");
//             if (user!.isMyAccount(cardUser.userId)) {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => UserProfilePage(
//                       userData: cardUser,
//                     ),
//                   ));
//             }
//             // else {
//             //   for (var element in listOfUsers) {
//             //     if (user.isMyAccount(element.userId)) {
//             //       Navigator.push(
//             //           context,
//             //           MaterialPageRoute(
//             //             builder: (context) => UserProfilePage(
//             //               userData: cardUser,
//             //             ),
//             //           ));
//             //     }

//             //   }
//             // }

// //============================
//             // Navigator.push(
//             //     context,
//             //     MaterialPageRoute(
//             //       builder: (context) => UserProfilePage(
//             //         userData: user,
//             //       ),
//             //     ));
//           },
//           shape: const CircleBorder(),
//           child: const Icon(
//             Icons.add_photo_alternate_outlined,
//             color: Colors.white,
//           ),
//         ),
//         _buildFloatingActionButton(context, Icons.card_giftcard, () {},
//             color: AppColors.ACCENT_COLOR),
//         _buildFloatingActionButton(context, Icons.report, () {
//           showModalBottomSheet(
//             context: context,
//             builder: (context) => SizedBox(
//               height: MediaQuery.of(context).size.height / 1.5,
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: ReportView(
//                   id: '2',
//                   categoryId: '',
//                 ),
//               ),
//             ),
//           );
//         }, color: Colors.red),
//       ],
//     );
//   }

//   Widget _buildFloatingActionButton(
//       BuildContext context, IconData icon, VoidCallback? onPressed,
//       {Color? color}) {
//     return FloatingActionButton.small(
//       onPressed: onPressed,
//       backgroundColor: color,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//       child: Icon(
//         icon,
//         color: color != null ? Colors.white : null,
//       ),
//     );
//   }
// }
// //rommana1
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/tinder_person_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
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
            body: state.userData.isEmpty
                ? Builder(builder: (context) {
                    context.read<TinderViewCubit>().fetchUserData().then(
                      (value) {
                        print('success..........................');
                      },
                    );
                    return const Center(child: CircularProgressIndicator());
                  })
                : Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Label(
                                  text: 'Find',
                                  style: Styles.headerText(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height -
                                  kToolbarHeight -
                                  200,
                              child: Stack(
                                children:
                                    state.userData.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  UserData user = entry.value;
                                  return _buildCard(context, index,
                                      user.pictures ?? [], user);
                                }).toList(),
                              ),
                            ),
                            if (state.subCategoryData.isNotEmpty)
                              SizedBox(
                                height: 200,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const Sizer(),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      TinderSubCategoryCard(
                                          subCategory:
                                              state.subCategoryData[index]),
                                  itemCount: state.subCategoryData.length,
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ],
                  ),
            mainCategoryId: 2,
          );
        },
      ),
    );
  }

  void switchDisplayGender(TinderViewState state, BuildContext context) {
    String gender = state.userData.first.user!.first.gender.toString();
    context
        .read<TinderViewCubit>()
        .fetchUserData(gender: gender == 'female' ? 'female' : 'male');
  }

  Widget _buildCard(
      BuildContext context, int index, List<Picture> images, UserData user) {
    final cubit = context.read<TinderViewCubit>();
    final state = cubit.state;
    bool isFrontCard = index == state.currentIndex;

    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: isFrontCard
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
                double tapPosition = details.localPosition.dx;
                double screenWidth = MediaQuery.of(context).size.width;
                tapPosition < screenWidth / 2
                    ? cubit.previousStory()
                    : cubit.nextStory();
              },
              child: Transform.translate(
                offset: state.position,
                child: Transform.rotate(
                  angle: state.rotation,
                  child: _cardWidget(context,
                      images: user.pictures ?? [], user: user),
                ),
              ),
            )
          : const Offstage(),
    );
  }

  Widget _cardWidget(BuildContext context,
      {required List<Picture> images, required UserData user}) {
    final state = context.read<TinderViewCubit>().state;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 6,
        child: Stack(
          children: [
            Hero(
              tag: 'userHero-${user.id}',
              child: Image.network(
                images.isNotEmpty
                    ? images[state.currentStoryIndex].mediaKey ?? ''
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
              padding: const EdgeInsets.only(top: 12.0, right: 8),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => switchDisplayGender(state, context),
                  iconSize: 30,
                  icon: Icon(
                      user.user!.first.gender == 'male'
                          ? Icons.female
                          : Icons.male,
                      color: Colors.black),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (dotIndex) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
                      height: 4,
                      decoration: BoxDecoration(
                        color: dotIndex == state.currentStoryIndex
                            ? Colors.red
                            : Colors.white54,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              bottom: kToolbarHeight * 1.2,
              right: 20,
              left: 20,
              child: _buildPersonInfo(context: context, user: user),
            ),
            Positioned(
              bottom: 8,
              right: 10,
              left: 10,
              child: _buildActions(context, state.userData, cardUser: user),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonInfo(
      {required BuildContext context, required UserData user}) {
    return InkWell(
      onTap: () => context.push(Routes.OTHERSACCOUNT),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BadgedLabel(
                    color: AppColors.SECONDARY_COLOR, label: 'Nearby'),
                ListTile(
                  onTap: null,
                  selected: false,
                  enabled: false,
                  title: Label(
                    text:
                        "${user.user!.first.firstName} ${user.user!.first.lastName}",
                    style: Styles.headerText(color: Colors.black, fontSize: 26),
                  ),
                  subtitle: Label(
                    text: 'last seen 3 minute ago',
                    style: Styles.mediumText(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_upward_rounded, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, List<UserData> listOfUsers,
      {required UserData cardUser}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildFloatingActionButton(context, Icons.person, null),
        _buildFloatingActionButton(context, Icons.chat, null,
            color: AppColors.PRIMARY_COLOR),
        FloatingActionButton.small(
          backgroundColor: Colors.red,
          onPressed: () async {
            // Uploading an image and updating state with the uploaded image's media ID
            // try {
            //   final uploadResult = await UploadFile().uploadImage(
            //     subCategoryId: '66af974f8bf69f9469944746',
            //     onUploaded: (p0) {
            //       context
            //           .read<TinderViewCubit>()
            //           .uploadImages(mediaIds: [p0.mediaId]);
            //       log("${p0.file.path}-----------===========");
            //     },
            //   );
            //   log("Image uploaded successfully:");
            // } catch (e) {
            //   log("Image upload failed: $e");
            // }

            // Fetching the current user data
            final user = context.read<UserCubit>().state.data;
            log("${user?.firstName}pppppppppppppppppppppppppppppppppppppppp");

            if (user != null) {
              if (user.isMyAccount(cardUser.userId ?? '')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(userData: cardUser),
                  ),
                );
              } else {
                for (var element in listOfUsers) {
                  if (user.isMyAccount(element.userId ?? '')) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserProfilePage(userData: cardUser),
                      ),
                    );
                    break;
                  }
                }
              }
            }
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.add_photo_alternate_outlined,
              color: Colors.white),
        ),
        _buildFloatingActionButton(context, Icons.card_giftcard, () {},
            color: AppColors.ACCENT_COLOR),
        _buildFloatingActionButton(context, Icons.report, () {
          showModalBottomSheet(
            context: context,
            builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: ReportView(id: '2', categoryId: ''),
              ),
            ),
          );
        }, color: Colors.red),
      ],
    );
  }

  Widget _buildFloatingActionButton(
      BuildContext context, IconData icon, VoidCallback? onPressed,
      {Color? color}) {
    return FloatingActionButton.small(
      onPressed: onPressed,
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Icon(icon, color: color != null ? Colors.white : null),
    );
  }
}
//rommana2.2