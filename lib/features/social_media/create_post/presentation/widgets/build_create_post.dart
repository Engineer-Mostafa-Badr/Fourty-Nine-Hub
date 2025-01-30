import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:snapping_bottom_sheet/snapping_bottom_sheet.dart';

class BuildCreatePost extends StatelessWidget {
  const BuildCreatePost({super.key, required this.onChange, required this.controller});
  final Function(String) onChange;
  final SheetController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        return Container(
          height: (state.backColor == '#FFFFFFFF' && state.isBiggerThen150 == false)
              ? null
              : (state.isBiggerThen150 == true)
              ? 260
              : 250,
          alignment: state.isBiggerThen150 == false ? AlignmentDirectional.topStart : Alignment.center,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Align(
            child: TextField(
              maxLines: null,
              expands: (state.backColor == '#FFFFFFFF') ? false : true,
              textAlign: (state.backColor == '#FFFFFFFF' || state.isBiggerThen150 == true)
                  ? TextAlign.start
                  : TextAlign.center,
              style: TextStyle(
                color: (state.backColor != '#FFFFFFFF' && state.isBiggerThen150 == false)
                    ? Colors.white
                    : AppColors.QUANTITY_COLOR,
                fontSize: (state.isBiggerThen120 == true && state.isBiggerThan80 == false)
                    ? 25
                    : (state.isBiggerThen120 == false && state.isBiggerThan80 == true)
                    ? 25
                    : 30,
                fontWeight: (state.backColor == '#FFFFFFFF' || state.isBiggerThen150 == true)
                    ? FontWeight.w400
                    : FontWeight.bold,
              ),
              onChanged: (c) => onChange(c),
              controller: context.read<CreatePostCubit>().postContentTextController,
              decoration: InputDecoration(
                hintText: LocaleKeys.whatDoYouThink.localize,
                hintStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: AppColors.GREYTEXT
                ),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        );
      },
    );
  }
}
