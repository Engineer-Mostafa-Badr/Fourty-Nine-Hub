import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../common/functions/global/upload_file.dart';
import '../../service_locator/service_locator.dart';
import '../api/api_consumer.dart';

Future customShowDialog(context)=>showDialog(
  context: context,
  builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    backgroundColor:
    Theme.of(context).scaffoldBackgroundColor,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Choose option',
          style: Styles.headerText(),
        ),
        const SizedBox(
          height: 20,
        ),
        buildMaterial(
          iconData: Icons.camera,
          text: 'Camera',
          function: () {
            Navigator.pop(context);
          },
        ),
        const SizedBox(
          height: 5,
        ),
        buildMaterial(
          iconData: Icons.image,
          text: 'Gallery',
          function: () {
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
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: Styles.mediumText(),
          ),
        ],
      ),
    );

