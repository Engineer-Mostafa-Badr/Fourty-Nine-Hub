import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';

class BuildColorsBallet extends StatelessWidget {
  const BuildColorsBallet({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> colors = [
      "#FFFFFFFF", // Colors.white
      "#FFFFA500", // Colors.orange
      "#FF0000FF", // Colors.blue
      "#FFFF0000", // Colors.red
      "#FF008000", // Colors.green
      "#FFDA70D6", // Colors.purpleAccent
      "#FFFFC0CB", // Colors.pink
      "#FFFFFF00", // Colors.yellow
      "#FFFF5252", // Colors.redAccent
      "#FF90EE90", // Colors.lightGreen
      "#FF64FFDA" // Colors.tealAccent
    ];

    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context,state) {
        final controller = context.read<CreatePostCubit>();
        return SizedBox(
          height: 30.h,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    controller.selectColor(color: colors[index]);
                    print("state.backColor${state.backColor}");
                  },
                  child: Container(
                    height: 30.h,
                    width: 30,
                    decoration: BoxDecoration(
                        color:
                        Color(int.parse(colors[index].substring(1), radix: 16)),
                        border: Border.all(color: Colors.grey, width: .5),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: colors.length),
        );
      }
    );
  }
}
