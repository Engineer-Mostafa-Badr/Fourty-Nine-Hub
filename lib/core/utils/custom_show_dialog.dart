import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/authentication/presentation/controllers/user_cubit/user_cubit.dart';

Future customShowDialog(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose option',
              style: Styles.headerText(),
            ),
            SizedBox(
              height: 20.h,
            ),
            buildMaterial(
              iconData: Icons.camera,
              text: 'Camera',
              function: () async {
                await context.read<UserCubit>().uploadPhoto(isGallery: false);
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 5.h,
            ),
            buildMaterial(
              iconData: Icons.image,
              text: 'Gallery',
              function: () async {
                await context.read<UserCubit>().uploadPhoto(isGallery: true);

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );

Widget buildMaterial({
  required IconData iconData,
  required String text,
  required Function function,
}) =>
    MaterialButton(
      onPressed: () {
        function();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            text,
            style: Styles.mediumText(),
          ),
        ],
      ),
    );
