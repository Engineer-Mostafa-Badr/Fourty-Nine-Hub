import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

Future<dynamic> SubmitBottomSheet(context,
    {
    required Color buttonColor,
    required String buttonTitle,}) {
  bool isChecked=false;
  return showModalBottomSheet(
    backgroundColor: AppColors.whiteColor,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
    isScrollControlled: true,
    builder: (context, ) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            color: AppColors.whiteColor,
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Positioned(
                      top: 10,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: CircleAvatar(
                          radius: 24.h,
                          backgroundColor: AppColors.BG_GRAY_COLOR,
                          child:const Icon(Icons.close),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 45, 12, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              visualDensity:const VisualDensity(
                                  horizontal: -4, vertical: -4),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: isChecked,
                              onChanged: (value) {
                                setModalState(() {
                                  isChecked = value!;
                                });

                              } ,
                              checkColor: Colors.white,
                              activeColor: AppColors.PRIMARY_COLOR,
                            ),
                            const Sizer(),
                            Label(text: context.isArabic?'انا احجز بالنيابة عن شخص اخر':'I am booking on behalf of another Client',

                            ),
                          ],
                        ),
                        const Sizer(),
                        FormTextField(
                          prefix:const Icon(Icons.call,color: AppColors.PRIMARY_COLOR,),
                          fillColor:AppColors.BG_GRAY_COLOR ,
                          hint: LocaleKeys.phoneNumber.localize,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const Sizer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.h,
                              vertical: 12.h,
                            ),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                buttonTitle,
                                style: Styles.headerText(
                                    color:
                                        buttonColor == AppColors.BG_GRAY_COLOR
                                            ? Colors.black
                                            : Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    ),
  );
}
