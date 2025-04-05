import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/text_input/text_input_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class ExpandedInputWidget extends StatefulWidget {
  final String title, disableMsg;
  final Color? titleColor;
  final bool? isEditAds;
  final bool? enabled;
  final TextEditingController? controller;
  final String? subTitle, price, secondSubTitle, hint, editText;
  final List<String> dropDownList;
  final void Function(int) onSelectItem;
  final VoidCallback? clearData;
  final List<TextInputFormatter>? formatters;
  const ExpandedInputWidget({
    super.key,
    required this.title,
    this.editText,
    this.controller,
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
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 15.sp,
            color: widget.titleColor ??
                Theme.of(context).colorScheme.secondary.withOpacity(.8),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: widget.isEditAds! ? 13.h : 0),
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
              showErrorMessage(context, widget.disableMsg);
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
              color: Colors.white,
            ),
            child: TextInputWidget(
                controller: controller,
                suffixSvg: isExpanded && widget.enabled!
                    ? Assets.arrowUp
                    : Assets.arrowDown,
                enabled: false,
                borderRadius: 6.r,
                hint: widget.hint,
                formatters: widget.formatters,
                validator: (v) {
                  return null;
                }),
          ),
        ),

        /// golden divider
        Visibility(
          visible:
              isExpanded && widget.dropDownList.isNotEmpty && widget.enabled!,
          child: const Divider(
            height: 0,
            color: AppColors.PRIMARY_COLOR,
            thickness: 1,
          ),
        ),

        ///expanded list
        Visibility(
          visible:
              isExpanded && widget.dropDownList.isNotEmpty && widget.enabled!,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            constraints: BoxConstraints(maxHeight: 250.h),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6.r),
                bottomRight: Radius.circular(6.r),
              ),
              color: Colors.black,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  widget.dropDownList.length,
                  (index) => GestureDetector(
                    onTap: () {
                      widget.onSelectItem(index);
                      isExpanded = false;
                      controller.text = widget.dropDownList[index];
                      setState(() {});
                    },
                    child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      color: Colors.transparent,
                      height: 40.h,
                      width: double.infinity,
                      child: Text(
                        widget.dropDownList[index],
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .fontSize,
                          fontWeight: FontWeight.w500,

                        ),
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
