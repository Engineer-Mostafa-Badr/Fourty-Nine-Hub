import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../core/localization/locale_keys.g.dart';
import 'sheet_vertical_item.dart';

class CustomVerticalSheetItem {
  CustomVerticalSheetItem._();

  static Future<T?> normal<T>(
    BuildContext context,
    List<CustomSheetModel> items, {
    T? selectedItem,
  }) async {
    return showCupertinoModalPopup<T?>(
      semanticsDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              LocaleKeys.cancel.localize,
              style: Styles.headerText(),
            ),
            onPressed: () {
      ManageVibration.vibrate();
              Navigator.pop(context);
            },
          ),
          actions: items.map(
            (e) {
              if (!e.isHidden) {
                return CupertinoActionSheetAction(
                  child: Row(
                    mainAxisAlignment: (e.iconData != null || e.image != null)
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      if (e.iconData != null)
                        Padding(
                          padding: EdgeInsets.only(right: 15.w, left: 5.w),
                          child: Icon(
                            e.iconData,
                            color: selectedItem == e.value ? Colors.red : null,
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      if (e.image != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 15, left: 5),
                          child: Image.asset(
                            e.image ?? '',
                            color: selectedItem == e.value ? Colors.red : null,
                            width: 30,
                            height: 35.h,
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      Label(
                        text: e.text,
                        style: Styles.headerText(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                  onPressed: () async {
      ManageVibration.vibrate();
                    Navigator.pop(context, e.value);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ).toList(),
        );
      },
    );
  }
}
