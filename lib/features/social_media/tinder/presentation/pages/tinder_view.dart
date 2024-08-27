// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_cubit/chat_room_cubit.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
// import 'package:fourtyninehub/features/social_media/reels/presentation/pages/reel_view.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_card_stack.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
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
//         BlocProvider(create: (context) => serviceLocator<TinderViewCubit>()),
//         BlocProvider(create: (context) => serviceLocator<ChatRoomCubit>()),
//         BlocProvider(create: (context) => serviceLocator<UserCubit>()),
//         BlocProvider(create: (context) => serviceLocator<ChatsCubit>()),
//         // BlocProvider(create: (context) => serviceLocator<LoginCubit>()),
//       ],
//       child: const TinderScreen(),
//     );
//   }
//
// // UserCubit _createUserCubit() {
// //   return UserCubit(serviceLocator(), serviceLocator(), serviceLocator(),
// //       serviceLocator(), serviceLocator(), serviceLocator());
// // }
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
//   @override
//   void initState() {
//     super.initState();
//     _initializeTinderData();
//   }
//
//   void _initializeTinderData() {
//     context.read<TinderViewCubit>()
//       ..fetchUserData(gender: 'female')
//       ..fetchSubCategoryData()
//       ..fetchFavorites();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     log('TinderScreen built');
//     return SharedScaffold(
//       body: Builder(builder: (context) {
//         //---------------------------------------------
//         log("${serviceLocator<UserCubit>().token}============================================================================");
//         if (context.watch<TinderViewCubit>().state.userData == null ||
//             context.watch<TinderViewCubit>().state.subCategoryData == null) {
//           // _initializeTinderData();
//
//           return const Center(
//             child: CupertinoActivityIndicator(radius: 25),
//           );
//         }
//         if (serviceLocator<UserCubit>().token == null ||
//             serviceLocator<UserCubit>().token!.isEmpty) {
//           showSnackBarAfterBuild(context, message: 'Check the login page.');
//
//           return const Center(
//             child: CupertinoActivityIndicator(radius: 25),
//           );
//         }
//         return _buildLoggedInContent(context);
//       }),
//       mainCategoryId: 2,
//     );
//   }
//
//   Widget _buildLoggedInContent(BuildContext context) {
//     return Container(
//       color: Theme.of(context).scaffoldBackgroundColor,
//       child: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             _buildHeader(),
//             context.watch<TinderViewCubit>().state.userData.isNotEmpty
//                 ? MultiBlocProvider(
//                     providers: [
//                       BlocProvider.value(
//                         value: serviceLocator<UserCubit>(),
//                       ),
//                       // BlocProvider.value(
//                       //   value: serviceLocator<TinderViewCubit>(),
//                       // ),
//                     ],
//                     child: const TinderCardStack(),
//                   )
//                 : SizedBox(
//                     height: MediaQuery.of(context).size.height * 2.5 / 4,
//                     child: const Center(
//                       child: CupertinoActivityIndicator(
//                         radius: 15,
//                       ),
//                     ),
//                   ),
//             const Padding(
//               padding: EdgeInsets.only(top: 8.0, bottom: 2),
//               child: Divider(color: Colors.grey, height: 1),
//             ),
//             _buildSubCategoryList(context),
//             const SizedBox(height: 50),
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
//         alignment: Alignment.topLeft,
//         child: Label(
//           text: 'Find',
//           style: Styles.headerText(fontSize: 18),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSubCategoryList(BuildContext context) {
//     return SizedBox(
//       height: 225,
//       child: BlocBuilder<TinderViewCubit, TinderViewState>(
//         builder: (context, state) {
//           return ListView.separated(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             scrollDirection: Axis.horizontal,
//             itemCount: state.subCategoryData.length,
//             separatorBuilder: (context, index) => const SizedBox(width: 0),
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.all(2.0),
//                 child: BlocProvider.value(
//                   value: serviceLocator<TinderViewCubit>()..fetchFavorites(),
//                   child: TinderSubCategoryCard(
//                     subCategoryCardData: state.subCategoryData[index],
//                     index: index,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// //21/8/2024
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chat_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_card_stack.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/widgets/tinder_sub_category_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

const kToolbarHeightFactor = 0.80;
const kDefaultPadding = 8.0;

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
      child: const TinderScreen(),
    );
  }
}

class TinderScreen extends StatefulWidget {
  const TinderScreen({super.key});

  @override
  State<TinderScreen> createState() => _TinderScreenState();
}

class _TinderScreenState extends State<TinderScreen> {
  @override
  void initState() {
    super.initState();
    _initializeTinderData();
  }

  void _initializeTinderData() {
    final tinderCubit = context.read<TinderViewCubit>();
    tinderCubit
      ..fetchUserData(gender: 'female')
      ..fetchSubCategoryData()
      ..fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    log('TinderScreen built');
    return SharedScaffold(
      body: BlocConsumer<TinderViewCubit, TinderViewState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.userData.isEmpty || state.subCategoryData.isEmpty) {
            return const Center(
              child: CupertinoActivityIndicator(radius: 25),
            );
          }
          return _buildLoggedInContent(context, state);
        },
      ),
      mainCategoryId: 2,
    );
  }

  Widget _buildLoggedInContent(BuildContext context, TinderViewState state) {
    return Container(
//000000000000
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(),
            state.userData.isNotEmpty
                ? const TinderCardStack()
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 2.5 / 4,
                    child: const Center(
                      child: CupertinoActivityIndicator(radius: 15),
                    ),
                  ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 2),
              child: Divider(color: Colors.grey, height: 1),
            ),
            _buildSubCategoryList(state),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Align(
        alignment: Alignment.topLeft,
        child: Label(
          text: 'Find',
          style: Styles.headerText(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildSubCategoryList(TinderViewState state) {
    return SizedBox(
      height: 225,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        scrollDirection: Axis.horizontal,
        itemCount: state.subCategoryData.length,
        separatorBuilder: (context, index) => const SizedBox(width: 0),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: TinderSubCategoryCard(
              subCategoryCardData: state.subCategoryData[index],
              index: index,
            ),
          );
        },
      ),
    );
  }
}
//00000000