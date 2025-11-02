// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// // import 'package:fourtyninehub/res/style/app_colors.dart';
// // import 'package:fourtyninehub/res/style/const.dart';
// // import 'package:fourtyninehub/service_locator/service_locator.dart';
// // import '../../../../../common/widgets/dynamic/sizer.dart';
// // import '../../../tinder/data/shared/shared.dart';
// // import '../../../tinder/presentation/pages/user_profile.dart';
// // import '../../data/models/new_reels_model.dart';
// //
// // class ProfileBottomSheet extends StatelessWidget {
// //   final ScrollController scrollController;
// //   final Reel reel;
// //
// //   const ProfileBottomSheet(
// //       {super.key, required this.scrollController, required this.reel});
// //
// //   static void show(BuildContext context, Reel reel) {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //       ),
// //       clipBehavior: Clip.antiAliasWithSaveLayer,
// //       builder: (context) => DraggableScrollableSheet(
// //         initialChildSize: 0.7,
// //         minChildSize: 0.5,
// //         maxChildSize: 0.9,
// //         expand: false,
// //         builder: (context, scrollController) => ProfileBottomSheet(
// //           scrollController: scrollController,
// //           reel: reel,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SingleChildScrollView(
// //       controller: scrollController,
// //       child: ProfileContent(reel: reel),
// //     );
// //   }
// // }
// //
// // class ProfileContent extends StatelessWidget {
// //   final Reel reel;
// //
// //   const ProfileContent({super.key, required this.reel});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       mainAxisSize: MainAxisSize.max,
// //       children: [
// //         SizedBox(
// //           height: MediaQuery.of(context).size.width * 0.75,
// //           width: double.infinity,
// //           child: Image.network(
// //             reel.user.coverPictureSignedUrl!.isEmpty ||
// //                     reel.user.coverPictureSignedUrl == null
// //                 ? reel.user.profilePictureSignedUrl!
// //                 : reel.user.coverPictureSignedUrl!,
// //             errorBuilder: (context, error, stackTrace) => Image.network(
// //               UIConst.profilePlaceHolder,
// //             ),
// //             fit: BoxFit.cover,
// //           ),
// //         ),
// //         Card(
// //           shape: const RoundedRectangleBorder(
// //             borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
// //           ),
// //           elevation: 2,
// //           margin: EdgeInsets.zero,
// //           child: Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               children: [
// //                 ProfileHeader(reel: reel),
// //                 const SizedBox(height: 20),
// //                 ActionButton(reel: reel),
// //                 const SizedBox(height: 20),
// //                 LocationAndContact(reel: reel),
// //                 const SizedBox(height: 20),
// //                 const SizedBox(height: 20),
// //                 // SocialLink(reel: reel),
// //                 // SizedBox(height: 20),
// //                 Description(reel: reel),
// //                 const SizedBox(height: 20),
// //               ],
// //             ),
// //           ),
// //         ),
// //         const Sizer(),
// //         MediaHighlights(reel: reel),
// //       ],
// //     );
// //   }
// // }
// //
// // class ProfileHeader extends StatelessWidget {
// //   final Reel reel;
// //
// //   const ProfileHeader({super.key, required this.reel});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: [
// //         CircleAvatar(
// //           radius: 65,
// //           backgroundColor:
// //               reel.user.story ? AppColors.SECONDARY_COLOR : Colors.transparent,
// //           child: CircleAvatar(
// //             radius: 60,
// //             backgroundImage: NetworkImage(
// //               reel.user.profilePictureSignedUrl ?? UIConst.profilePlaceHolder,
// //             ),
// //             onBackgroundImageError: (exception, stackTrace) =>
// //                 const NetworkImage(
// //               UIConst.profilePlaceHolder,
// //             ),
// //           ),
// //         ),
// //         const SizedBox(width: 16),
// //         Expanded(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 children: [
// //                   Flexible(
// //                     child: Text(
// //                       capitalizeAndSplit2Only(
// //                           "${reel.user.firstName} ${reel.user.lastName}"),
// //                       style: Theme.of(context).textTheme.headlineSmall,
// //                       overflow: TextOverflow.ellipsis,
// //                     ),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   if (reel.user.verified)
// //                     const Icon(
// //                       Icons.verified,
// //                       color: AppColors.SECONDARY_COLOR,
// //                     )
// //                 ],
// //               ),
// //               Text(
// //                 '${reel.user.firstName}${reel.user.lastName} · ${reel.user.job ?? ''}',
// //                 style: Theme.of(context)
// //                     .textTheme
// //                     .titleMedium
// //                     ?.copyWith(color: Colors.grey[600]),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// //
// // class ActionButton extends StatelessWidget {
// //   final Reel reel;
// //
// //   const ActionButton({super.key, required this.reel});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final currentUserId = serviceLocator<UserCubit>().state.data!.id;
// //     return SizedBox(
// //       width: double.infinity,
// //       child: Builder(builder: (context) {
// //         if (currentUserId == reel.user.id) {
// //           return ElevatedButton(
// //               onPressed: () {},
// //               style: ElevatedButton.styleFrom(
// //                 foregroundColor: Colors.black,
// //                 backgroundColor: Colors.yellow,
// //                 padding: const EdgeInsets.symmetric(vertical: 16),
// //               ),
// //               child: const Text('Your Account'));
// //         } else if (reel.user.isFriend) {
// //           return ElevatedButton(
// //               onPressed: () {},
// //               style: ElevatedButton.styleFrom(
// //                 foregroundColor: Colors.black,
// //                 backgroundColor: Colors.yellow,
// //                 padding: const EdgeInsets.symmetric(vertical: 16),
// //               ),
// //               child: const Text('Friend'));
// //         }
// //         return ElevatedButton(
// //             onPressed: () {},
// //             style: ElevatedButton.styleFrom(
// //               foregroundColor: Colors.black,
// //               backgroundColor: Colors.yellow,
// //               padding: const EdgeInsets.symmetric(vertical: 16),
// //             ),
// //             child: const Text('+ Add'));
// //       }),
// //     );
// //   }
// // }
// //
// // class LocationAndContact extends StatelessWidget {
// //   final Reel reel;
// //
// //   const LocationAndContact({super.key, required this.reel});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceAround,
// //       children: [
// //         if (reel.user.country!.isNotEmpty)
// //           _buildInfoRow(Icons.location_on,
// //               '${capitalize(reel.user.country ?? '')}, ${capitalize(reel.user.city ?? '')}'),
// //         if (reel.user.phone!.isNotEmpty)
// //           _buildInfoRow(Icons.contact_mail, '${reel.user.phone}'),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildInfoRow(IconData icon, String text) {
// //     return Row(
// //       children: [
// //         Icon(icon),
// //         const SizedBox(width: 5),
// //         Text(text),
// //       ],
// //     );
// //   }
// // }
// //
// // class SocialLink extends StatelessWidget {
// //   final Reel reel;
// //
// //   const SocialLink({super.key, required this.reel});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: [
// //         const Icon(Icons.link),
// //         const SizedBox(width: 5),
// //         Text(
// //           'instagram.com/...',
// //           style: TextStyle(color: Theme.of(context).primaryColor),
// //         ),
// //       ],
// //     );
// //   }
// // }
// //
// // class Description extends StatelessWidget {
// //   final Reel reel;
// //
// //   const Description({super.key, required this.reel});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: [
// //         if (reel.user.bio!.isNotEmpty)
// //           const Icon(
// //             FontAwesomeIcons.userPen,
// //             size: 20,
// //           ),
// //         const Sizer(),
// //         const Sizer(),
// //         Text(
// //           reel.user.bio ?? '',
// //           style: Theme.of(context).textTheme.bodyLarge,
// //           textAlign: TextAlign.start,
// //         ),
// //       ],
// //     );
// //   }
// // }
// //
// // class MediaHighlights extends StatelessWidget {
// //   final Reel reel;
// //
// //   const MediaHighlights({super.key, required this.reel});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(8.0),
// //       child: (reel.user.birthday!.isEmpty &&
// //               reel.user.country!.isEmpty &&
// //               reel.user.job!.isEmpty)
// //           ? const Sizer()
// //           : GridView.count(
// //               crossAxisCount: 3,
// //               shrinkWrap: true,
// //               physics: const NeverScrollableScrollPhysics(),
// //               crossAxisSpacing: 10,
// //               mainAxisSpacing: 10,
// //               children: [
// //                 MediaHighlightItem(
// //                   label:
// //                       reel.user.birthday!.isEmpty || reel.user.birthday == null
// //                           ? 'AST 1999'
// //                           : reel.user.birthday!,
// //                   icon: Icons.event,
// //                   reel: reel,
// //                 ),
// //                 MediaHighlightItem(
// //                     label: capitalize(reel.user.country ?? ''),
// //                     icon: Icons.flag,
// //                     reel: reel),
// //                 MediaHighlightItem(
// //                     label: capitalize(reel.user.job ?? ''),
// //                     icon: FontAwesomeIcons.briefcase,
// //                     reel: reel),
// //               ],
// //             ),
// //     );
// //   }
// // }
// //
// // class MediaHighlightItem extends StatelessWidget {
// //   final Reel reel;
// //
// //   final String label;
// //   final IconData icon;
// //
// //   const MediaHighlightItem(
// //       {super.key, required this.label, required this.icon, required this.reel});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Expanded(
// //           child: Container(
// //             decoration: BoxDecoration(
// //               color: Colors.grey[300],
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //             child: Icon(icon, size: 40),
// //           ),
// //         ),
// //         const SizedBox(height: 5),
// //         Expanded(
// //           child: Text(label,
// //               textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
// //         ),
// //       ],
// //     );
// //   }
// // }
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/res/style/const.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import '../../../../../common/widgets/dynamic/sizer.dart';
// import '../../../tinder/data/shared/shared.dart';
// import '../../../tinder/presentation/pages/user_profile.dart';
// import '../../data/models/new_reels_model.dart';
// import 'package:fourtyninehub/core/localization/locale_keys.g.dart'; // For localization keys
//
// class ProfileBottomSheet extends StatelessWidget {
//   final ScrollController scrollController;
//   final Reel reel;
//
//   const ProfileBottomSheet(
//       {super.key, required this.scrollController, required this.reel});
//
//   static void show(BuildContext context, Reel reel) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.7,
//         minChildSize: 0.5,
//         maxChildSize: 0.9,
//         expand: false,
//         builder: (context, scrollController) => ProfileBottomSheet(
//           scrollController: scrollController,
//           reel: reel,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       controller: scrollController,
//       child: ProfileContent(reel: reel),
//     );
//   }
// }
//
// class ProfileContent extends StatelessWidget {
//   final Reel reel;
//
//   const ProfileContent({super.key, required this.reel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         SizedBox(
//           height: MediaQuery.of(context).size.width * 0.75,
//           width: double.infinity,
//           child: Image.network(
//             reel.user.coverPictureSignedUrl!.isEmpty ||
//                 reel.user.coverPictureSignedUrl == null
//                 ? reel.user.profilePictureSignedUrl!
//                 : reel.user.coverPictureSignedUrl!,
//             errorBuilder: (context, error, stackTrace) => Image.network(
//               UIConst.profilePlaceHolder,
//             ),
//             fit: BoxFit.cover,
//           ),
//         ),
//         Card(
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//           ),
//           elevation: 2,
//           margin: EdgeInsets.zero,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 ProfileHeader(reel: reel),
//                 const SizedBox(height: 20),
//                 ActionButton(reel: reel),
//                 const SizedBox(height: 20),
//                 LocationAndContact(reel: reel),
//                 const SizedBox(height: 20),
//                 const SizedBox(height: 20),
//                 Description(reel: reel),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//         const Sizer(),
//         MediaHighlights(reel: reel),
//       ],
//     );
//   }
// }
//
// class ProfileHeader extends StatelessWidget {
//   final Reel reel;
//
//   const ProfileHeader({super.key, required this.reel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 65,
//           backgroundColor:
//           reel.user.story ? AppColors.SECONDARY_COLOR : Colors.transparent,
//           child: CircleAvatar(
//             radius: 60,
//             backgroundImage: NetworkImage(
//               reel.user.profilePictureSignedUrl ?? UIConst.profilePlaceHolder,
//             ),
//             onBackgroundImageError: (exception, stackTrace) =>
//             const NetworkImage(
//               UIConst.profilePlaceHolder,
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Flexible(
//                     child: Text(
//                       capitalizeAndSplit2Only(
//                           "${reel.user.firstName} ${reel.user.lastName}"),
//                       style: Theme.of(context).textTheme.headlineSmall,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   if (reel.user.verified)
//                     const Icon(
//                       Icons.verified,
//                       color: AppColors.SECONDARY_COLOR,
//                     )
//                 ],
//               ),
//               Text(
//                 '${reel.user.firstName}${reel.user.lastName} · ${reel.user.job ?? ''}',
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleMedium
//                     ?.copyWith(color: Colors.grey[600]),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class ActionButton extends StatelessWidget {
//   final Reel reel;
//
//   const ActionButton({super.key, required this.reel});
//
//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = serviceLocator<UserCubit>().state.data!.id;
//     return SizedBox(
//       width: double.infinity,
//       child: Builder(builder: (context) {
//         if (currentUserId == reel.user.id) {
//           return ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               foregroundColor: Colors.black,
//               backgroundColor: Colors.yellow,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//             ),
//             child: Text(LocaleKeys.your_account.tr()), // Localized text
//           );
//         } else if (reel.user.isFriend) {
//           return ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               foregroundColor: Colors.black,
//               backgroundColor: Colors.yellow,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//             ),
//             child: Text(LocaleKeys.friend.tr()), // Localized text
//           );
//         }
//         return ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.black,
//             backgroundColor: Colors.yellow,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//           ),
//           child: Text(LocaleKeys.add_friend.tr()), // Localized text
//         );
//       }),
//     );
//   }
// }
//
// class LocationAndContact extends StatelessWidget {
//   final Reel reel;
//
//   const LocationAndContact({super.key, required this.reel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         if (reel.user.country!.isNotEmpty)
//           _buildInfoRow(Icons.location_on,
//               '${capitalize(reel.user.country ?? '')}, ${capitalize(reel.user.city ?? '')}'),
//         if (reel.user.phone!.isNotEmpty)
//           _buildInfoRow(Icons.contact_mail, '${reel.user.phone}'),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon),
//         const SizedBox(width: 5),
//         Text(text),
//       ],
//     );
//   }
// }
//
// class Description extends StatelessWidget {
//   final Reel reel;
//
//   const Description({super.key, required this.reel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         if (reel.user.bio!.isNotEmpty)
//           const Icon(
//             FontAwesomeIcons.userPen,
//             size: 20,
//           ),
//         const Sizer(),
//         const Sizer(),
//         Text(
//           reel.user.bio ?? '',
//           style: Theme.of(context).textTheme.bodyLarge,
//           textAlign: TextAlign.start,
//         ),
//       ],
//     );
//   }
// }
//
// class MediaHighlights extends StatelessWidget {
//   final Reel reel;
//
//   const MediaHighlights({super.key, required this.reel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: (reel.user.birthday!.isEmpty &&
//           reel.user.country!.isEmpty &&
//           reel.user.job!.isEmpty)
//           ? const Sizer()
//           : GridView.count(
//         crossAxisCount: 3,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//         children: [
//           MediaHighlightItem(
//             label:
//             reel.user.birthday!.isEmpty || reel.user.birthday == null
//                 ? 'AST 1999'
//                 : reel.user.birthday!,
//             icon: Icons.event,
//             reel: reel,
//           ),
//           MediaHighlightItem(
//               label: capitalize(reel.user.country ?? ''),
//               icon: Icons.flag,
//               reel: reel),
//           MediaHighlightItem(
//               label: capitalize(reel.user.job ?? ''),
//               icon: FontAwesomeIcons.briefcase,
//               reel: reel),
//         ],
//       ),
//     );
//   }
// }
//
// class MediaHighlightItem extends StatelessWidget {
//   final Reel reel;
//
//   final String label;
//   final IconData icon;
//
//   const MediaHighlightItem(
//       {super.key, required this.label, required this.icon, required this.reel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, size: 40),
//           ),
//         ),
//         const SizedBox(height: 5),
//         Expanded(
//           child: Text(label,
//               textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
//         ),
//       ],
//     );
//   }
// }

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart'; // For localization keys
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../routes/routes.dart';
import '../../../social_posts/presentation/cubit/social_posts_cubit.dart';
import '../../data/models/new_reels_model.dart';

class ProfileBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final Reel reel;

  const ProfileBottomSheet({
    super.key,
    required this.scrollController,
    required this.reel,
  });

  static Future<void> show(BuildContext context, Reel reel) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.5,
        maxChildSize: (reel.user.birthday!.isNotEmpty ||
                reel.user.country!.isNotEmpty ||
                reel.user.job!.isNotEmpty)
            ? 0.8
            : 0.6,
        expand: false,
        builder: (context, scrollController) => ProfileBottomSheet(
          scrollController: scrollController,
          reel: reel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: ProfileContent(reel: reel),
    );
  }
}

class ProfileContent extends StatelessWidget {
  final Reel reel;

  const ProfileContent({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    final coverUrl = reel.user.coverPictureSignedUrl;
    final profileUrl = reel.user.profilePictureSignedUrl;

    final imageUrl = (coverUrl != null && coverUrl.isNotEmpty)
        ? coverUrl
        : (profileUrl != null && profileUrl.isNotEmpty)
            ? profileUrl
            : UIConst.profilePlaceHolder;

    return Column(
      mainAxisSize: MainAxisSize.min,
      // Use min to avoid overflow in SingleChildScrollView
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.75,
          width: double.infinity,
          child: Image.network(
            imageUrl,
            errorBuilder: (context, error, stackTrace) => Image.network(
              UIConst.profilePlaceHolder,
              fit: BoxFit.cover,
            ),
            fit: BoxFit.cover,
          ),
        ),
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          elevation: 2,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ProfileHeader(reel: reel),
                const SizedBox(height: 20),
                ActionButton(reel: reel),
                const SizedBox(height: 20),
                LocationAndContact(reel: reel),
                const SizedBox(height: 20),
                Description(reel: reel),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        const Sizer(),
        MediaHighlights(reel: reel),
      ],
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final Reel reel;

  const ProfileHeader({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    final profileUrl =
        reel.user.profilePictureSignedUrl ?? UIConst.profilePlaceHolder;

    return Row(
      children: [
        InkWell(
          onTap: () => context.push(Routes.OTHERSACCOUNT, extra: reel.user.id),
          child: CircleAvatar(
            radius: 70.h,
            backgroundColor: reel.user.story == true
                ? AppColors.SECONDARY_COLOR
                : Colors.transparent,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(profileUrl),
              onBackgroundImageError: (_, __) {},
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      maxLines: 2,
                      textScaler: TextScaler.noScaling,
                      capitalizeAndSplit2Only(
                          "${reel.user.firstName} ${reel.user.lastName}"),
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Divider(),
                  if (reel.user.verified == true)
                    const Icon(
                      Icons.verified,
                      color: AppColors.SECONDARY_COLOR,
                    ),
                ],
              ),
              FittedBox(
                child: Text(
                  maxLines: 1,
                  textScaler: TextScaler.noScaling,
                  '${reel.user.firstName} ${reel.user.lastName} · ${reel.user.job ?? ''}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ActionButton extends StatefulWidget {
  final Reel reel;

  const ActionButton({super.key, required this.reel});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    final currentUserId = serviceLocator<UserCubit>().state.data?.id ?? '';
    final isCurrentUser = currentUserId == widget.reel.user.id;
    final isFollowed = widget.reel.user.isFollowed;

    String buttonText;
    VoidCallback? onPressed;

    if (isCurrentUser) {
      buttonText = context.isArabic ? 'حسابي' : 'My Account';
      onPressed = () {};
    } else if (isFollowed) {
      buttonText = LocaleKeys.spotlight_following.tr();
      onPressed = () async {
        var result = await serviceLocator<SocialPostsCubit>()
            .unFollowRequest(context: context, userId: widget.reel.user.id);
        if (result == true) {
          widget.reel.user.isFollowed = false;
          setState(() {});
        }
      };
    } else {
      buttonText = LocaleKeys.spotlight_follow.tr();
      onPressed = () async {
        var result = await serviceLocator<SocialPostsCubit>()
            .followRequest(context: context, userId: widget.reel.user.id);
        if (result == true) {
          widget.reel.user.isFollowed = true;
          setState(() {});
        }
        // isAdded = await serviceLocator<SocialPostsCubit>()
        //     .friendRequest(context: context, userId: widget.reel.user.id);
        // setState(() {});
      };
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.yellow,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  elevation: 0),
              child: Text(
                buttonText,
                textScaler: TextScaler.noScaling,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationAndContact extends StatelessWidget {
  final Reel reel;

  const LocationAndContact({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    final country = reel.user.country ?? '';
    final city = reel.user.city ?? '';
    final phone = reel.user.phone ?? '';

    final hasLocation = country.isNotEmpty || city.isNotEmpty;
    final hasPhone = phone.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasLocation)
          _buildInfoRow(
            Icons.location_on,
            '${capitalize(country)}, ${capitalize(city)}',
          ),
        const Spacer(),
        if (hasPhone)
          _buildInfoRow(
            Icons.contact_mail,
            phone,
          ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        Text(
          text,
          textScaler: TextScaler.noScaling,
        ),
      ],
    );
  }
}

class Description extends StatelessWidget {
  final Reel reel;

  const Description({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    final bio = reel.user.bio ?? '';

    if (bio.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          FontAwesomeIcons.userPen,
          size: 20,
        ),
        const SizedBox(width: 5),
        Text(
          bio,
          textScaler: TextScaler.noScaling,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}

class MediaHighlights extends StatelessWidget {
  final Reel reel;

  const MediaHighlights({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    final birthday = reel.user.birthday ?? '';
    final country = reel.user.country ?? '';
    final job = reel.user.job ?? '';

    final hasHighlights =
        birthday.isNotEmpty || country.isNotEmpty || job.isNotEmpty;

    if (!hasHighlights) {
      return const Sizer();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (birthday.isNotEmpty)
            MediaHighlightItem(
              label: birthday.isNotEmpty ? birthday : 'AST 1999',
              icon: Icons.event,
            ),
          if (country.isNotEmpty)
            MediaHighlightItem(
              label: capitalize(country),
              icon: Icons.flag,
            ),
          if (job.isNotEmpty)
            MediaHighlightItem(
              label: capitalize(job),
              icon: FontAwesomeIcons.briefcase,
            ),
        ],
      ),
    );
  }
}

class MediaHighlightItem extends StatelessWidget {
  final String label;
  final IconData icon;

  const MediaHighlightItem({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 50.h),
        const SizedBox(height: 5),
        Text(
          label,
          textScaler: TextScaler.noScaling,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
