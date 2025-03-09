import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/utils/hex_color_helper.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
class ExpandedInputWidget extends StatefulWidget {
  final String title, disableMsg;
  final Color? titleColor;
  final bool? isEditAds;
  final bool? enabled;
  final bool? hasTranslation;
  final TextEditingController? controller;
  final String? subTitle, price, secondSubTitle, hint, editText;
  final List<dynamic> dropDownList;
  final void Function(int) onSelectItem;
  final VoidCallback? clearData;
  final bool? hasColor;
  final List<TextInputFormatter>? formatters;
  const ExpandedInputWidget({
    super.key,
    required this.title,
    this.editText,
    this.controller,
    this.hasColor,
    this.disableMsg = '',
    this.enabled = true,
    required this.dropDownList,
    required this.onSelectItem,
    this.clearData,
    this.subTitle,
    this.price,
    this.secondSubTitle,
    this.hint,
    this.titleColor,
    this.isEditAds = false,
    this.hasTranslation = false,
    this.formatters,
  });

  @override
  State<ExpandedInputWidget> createState() => _ExpandedInputWidgetState();
}

class _ExpandedInputWidgetState extends State<ExpandedInputWidget> {
  var isExpanded = false;
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? TextEditingController(text: widget.editText ?? '');
  }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   widget.title,
        //   style: TextStyle(
        //     fontSize: 15.sp,
        //     color: widget.titleColor ??
        //         Theme.of(context).colorScheme.secondary.withOpacity(.8),
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        // SizedBox(height: widget.isEditAds! ? 13.h : 0),
        Visibility(
          visible: widget.subTitle != null,
          child: Container(
            margin: EdgeInsets.only(top: 2.h),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .color!
                          .withOpacity(.33),
                    ),
                children: [
                  // TextSpan(text: widget.subTitle),
                  // TextSpan(
                  //   text: ' ${widget.price} ',
                  //   style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  //         fontWeight: FontWeight.w700,
                  //         color: Theme.of(context)
                  //             .textTheme
                  //             .bodySmall!
                  //             .color!
                  //             .withOpacity(.33),
                  //       ),
                  // ),
                  TextSpan(text: widget.secondSubTitle),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 7.h),
        GestureDetector(
          onTap: () {
            print(widget.enabled);
            if (widget.enabled!) {
              setState(() {
                isExpanded = !isExpanded;
              });
            } else {
              // MethodHelpers.previewToast(msg: widget.disableMsg);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: isExpanded
                  ? BorderRadius.only(
                      topLeft: Radius.circular(6.r),
                      topRight: Radius.circular(6.r),
                    )
                  : BorderRadius.circular(6.r),
              color: AppColors.whiteColor,
            ),
            child: TextFormField(
                controller: controller,
                // suffixSvg: isExpanded && widget.enabled!
                //     ? Assets.arrowUp
                //     : Assets.arrowDown,
                enabled: false,
                style: Styles.mediumText(color: AppColors.black,fontWeight: FontWeight.w400,fontSize: 26),
                decoration: InputDecoration(
                  fillColor: AppColors.GREYBG,
                  suffixIcon: Icon(isExpanded && widget.enabled!?Icons.keyboard_arrow_up_outlined:Icons.keyboard_arrow_down_outlined,color: AppColors.PRIMARY_COLOR,),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Colors.transparent),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Colors.transparent),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Colors.transparent),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Colors.transparent),
                  ),
                  hintText: widget.hint,
                ),
                // borderRadius: 6.r,
                // formatters: widget.formatters,
                validator: (v) {
                  return null;
                }),
          ),
        ),


        ///expanded list
        Visibility(
          visible:
              isExpanded && widget.dropDownList.isNotEmpty && widget.enabled!,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            constraints: BoxConstraints(maxHeight: 250.h),
            margin: const EdgeInsets.only(top: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.black.withOpacity(.1),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  widget.dropDownList.length,
                  (index) => GestureDetector(
                    onTap: () {
                      widget.onSelectItem(index);
                      isExpanded = false;
                      controller.text = widget.hasTranslation==true?context.isArabic?widget.dropDownList[index].nameAr:widget.dropDownList[index].nameEn:widget.dropDownList[index];
                      setState(() {});
                    },
                    child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      padding: const EdgeInsets.all(5),
                      color: Colors.transparent,
                      // height: 40.h,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if(widget.hasColor==true) ...[Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: HexColor(
                                  widget.dropDownList[index].code ?? ''),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          )],
                          Label(
                            text:widget.hasTranslation==true?context.isArabic?widget.dropDownList[index].nameAr:widget.dropDownList[index].nameEn:widget.dropDownList[index],
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
