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
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
    isScrollControlled: true,
    builder: (context, ) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius:const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
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
                          backgroundColor: AppColors.getFillColor(context),
                          child:Icon(Icons.close,color: AppColors.getTextColor(context),),
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
                              checkColor:context.isDarkMode?AppColors.black: Colors.white,
                              activeColor: AppColors.getButtonPrimaryColor(context),
                            ),
                            const Sizer(),
                            Label(text: context.isArabic?'انا احجز بالنيابة عن شخص اخر':'I am booking on behalf of another Client',

                            ),
                          ],
                        ),
                        const Sizer(height: 20,),
                        FormTextField(
                          prefix: Icon(Icons.call,color: AppColors.getButtonPrimaryColor(context),),
                          fillColor:AppColors.getFillColor(context) ,
                          hint: LocaleKeys.phoneNumber.localize,
                          borderRadius: BorderRadius.circular(10),
                          type: TextInputType.phone,
                          borderColor: AppColors.getFillColor(context),
                          borderSide: AppColors.getFillColor(context),
                          textStyle: Styles.mediumText(color: AppColors.getTextColor(context)),
                          style: Styles.mediumText(color: AppColors.getTextColor(context)),
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
                                    color:context.isDarkMode?AppColors.black:Colors.white),
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
