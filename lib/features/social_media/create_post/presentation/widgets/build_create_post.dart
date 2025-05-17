import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:snapping_bottom_sheet/snapping_bottom_sheet.dart';

class BuildCreatePost extends StatelessWidget {
  const BuildCreatePost({super.key, required this.onChange, required this.sheetController});
  final Function(String) onChange;
  final SheetController sheetController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        print("state.backColor${state.backColor}");
        var controller = context.read<CreatePostCubit>();

        return Container(
          height: ((state.backColor == '#FFFFFFFF' && state.isBiggerThen150 == false)||state.selectedLifeEvent!=null)
              ? 250
              :((state.backColor == '#FFFFFFFF' && state.isBiggerThen120 == true)||state.selectedLifeEvent!=null)?250: (state.isBiggerThen150 == true)
              ? 300
              : 250,
          alignment: state.isBiggerThen150 == false ? AlignmentDirectional.topStart : Alignment.center,
          color: Color(int.parse((state.selectedLifeEvent!=null?(context.isDarkMode?'#00000000':'#FFFFFFFF'):state.backColor ?? (context.isDarkMode?'#FFFFFFFF':'#FFFFFFFF')).replaceAll("#", ""), radix: 16),),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  maxLines: null,
                  expands: true,
                  textAlign:TextAlign.start,
                  style: TextStyle(
                    color: (state.backColor != '#FFFFFFFF' && state.isBiggerThen150 == false&&state.selectedLifeEvent==null&&state.backColor!='#FFFFFF00')
                        ? Colors.white
                        : AppColors.QUANTITY_COLOR,
                    fontSize: (state.isBiggerThen120 == true && state.isBiggerThan80 == false)
                        ? 45.sp
                        : (state.isBiggerThen120 == false && state.isBiggerThan80 == true)
                        ? 45.sp
                        : 55.sp,
                    fontWeight: (state.backColor == '#FFFFFFFF' || state.isBiggerThen150 == true||state.selectedLifeEvent!=null)
                        ? FontWeight.w400
                        : FontWeight.bold,
                  ),
                  onChanged: (c) {
                    if (c.isNotEmpty) {
                      sheetController.collapse();
                    }
                    if (c.length > 80 &&
                        c.length < 120 &&
                        state.backColor != '#FFFFFFFF') {
                      controller.onBigger80();
                    } else if (c.length > 120 &&
                        c.length < 150 &&
                        state.backColor != '#FFFFFFFF') {
                      controller.onBigger120();
                    } else if (c.length > 150) {
                      controller.onBigger150();
                      // controller.selectColor(color: "#FFFFFFFF");
                    } else {
                      controller.onSmallerText();
                    }
                    },
                  controller: context.read<CreatePostCubit>().postContentTextController,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.whatDoYouThink.localize,
                    hintStyle: TextStyle(
                      fontSize: 45.sp,
                      fontWeight: FontWeight.w400,
                      color:(state.backColor != '#FFFFFFFF' && state.isBiggerThen150 == false&&state.backColor!='#FFFFFF00')
                          ? Colors.white
                          : AppColors.GREYTEXT
                    ),
                    focusColor:(state.backColor != '#FFFFFFFF' && state.isBiggerThen150 == false&&state.backColor!='#FFFFFF00')
                        ? Colors.white
                        : AppColors.GREYTEXT,

                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    fillColor: state.isBiggerThen150?Colors.white:Color(int.parse((state.backColor??'#FFFFFFFF').replaceAll("#", ""), radix: 16),),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
