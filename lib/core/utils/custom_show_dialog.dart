import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/authentication/presentation/controllers/user_cubit/user_cubit.dart';

// Future customShowDialog(context) => showDialog(
//       context: context,
//       builder: (context) => //TODO
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Choose option',
//               style: Styles.headerText(),
//             ),
//             SizedBox(
//               height: 20.h,
//             ),
//             buildMaterial(
//               iconData: Icons.camera,
//               text: 'Camera',
//               function: () async {
//                 await context.read<UserCubit>().uploadPhoto(isGallery: false, context: context);
//                 Navigator.pop(context);
//               },
//             ),
//             SizedBox(
//               height: 5.h,
//             ),
//             buildMaterial(
//               iconData: Icons.image,
//               text: 'Gallery',
//               function: () async {
//                 await context.read<UserCubit>().uploadPhoto(isGallery: true, context: context);
//
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//
// Widget buildMaterial({
//   required IconData iconData,
//   required String text,
//   required Function function,
// }) =>
//     MaterialButton(
//       onPressed: () {
//         function();
//       },
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             iconData,
//           ),
//           SizedBox(
//             width: 10.w,
//           ),
//           Text(
//             text,
//             style: Styles.mediumText(),
//           ),
//         ],
//       ),
//     );

// Future customShowDialog(context) =>
//     showDialog(
//       context: context,
//       builder: (context) =>
//           AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             backgroundColor: Theme
//                 .of(context)
//                 .scaffoldBackgroundColor,
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Choose option',
//                   style: Styles.headerText(),
//                 ),
//                 SizedBox(
//                   height: 20.h,
//                 ),
//                 buildMaterial(
//                   iconData: Icons.camera,
//                   text: 'Camera',
//                   function: () async {
//                     await context
//                         .read<UserCubit>()
//                         .uploadPhoto(isGallery: false, context: context);
//                     Navigator.pop(context);
//                   },
//                 ),
//                 SizedBox(
//                   height: 5.h,
//                 ),
//                 buildMaterial(
//                   iconData: Icons.image,
//                   text: 'Gallery',
//                   function: () async {
//                     await context
//                         .read<UserCubit>()
//                         .uploadPhoto(isGallery: true, context: context);
//
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//     );
//
// Widget buildMaterial({
//   required IconData iconData,
//   required String text,
//   required Function function,
// }) =>
//     MaterialButton(
//       onPressed: () {
//         function();
//       },
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             iconData,
//           ),
//           SizedBox(
//             width: 10.w,
//           ),
//           Text(
//             text,
//             style: Styles.mediumText(),
//           ),
//         ],
//       ),
//     );

showAnimatedDialog(BuildContext context, Widget alertDialog,
    {bool? barrierDismissible, String? barrierLabel}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? true,
    barrierLabel: barrierLabel ??
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, _, __) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: alertDialog,
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.7, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        ),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}
