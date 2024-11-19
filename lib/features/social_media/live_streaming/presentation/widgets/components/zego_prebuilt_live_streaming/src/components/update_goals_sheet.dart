import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../../../res/style/const.dart';
import '../../../../../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../../../../../zoom/presentation/controller/stream_cubit.dart';
import '../../../../../../../../zoom/presentation/controller/stream_state.dart';
import '../../../../../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

Future<void> showUpdateGoalsSheet(BuildContext context) async {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // Make background transparent for rounded effect
      isScrollControlled: true,
      // Allows the sheet to take more space
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.4,
            // Adjust as needed
            maxChildSize: 0.7,
            minChildSize: 0.2,
            builder: (context, controller) {
              return Container(
                  constraints: BoxConstraints(
                    maxHeight: context.screenHeight / 2,
                  ),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ImageFromInternet(
                              image: context
                                      .read<UserCubit>()
                                      .state
                                      .data!
                                      .profilePicture ??
                                  UIConst.imagePlaceHolder,
                              width: 130.w,
                              height: 130.h,
                              isCircle: true,
                            ),
                            SizedBox(width: 20.w),
                            Label(
                              text: context
                                  .read<UserCubit>()
                                  .state
                                  .data!
                                  .fullName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        BlocBuilder<StreamCubit, StreamState>(
                          builder: (context, state) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white10,
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                      state.selectedGifts.length,
                                      (index) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Row(
                                              children: [
                                                SvgPicture.network(
                                                    state.selectedGifts[index]
                                                        .picture!,
                                                    height: 100.h,
                                                    width: 100.w),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Label(
                                                        text: context.isArabic
                                                            ? state
                                                                .selectedGifts[
                                                                    index]
                                                                .nameAr!
                                                            : state
                                                                .selectedGifts[
                                                                    index]
                                                                .nameEn!),
                                                    RichText(
                                                        text: TextSpan(
                                                            text: '0',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .yellow,
                                                                fontSize:
                                                                    30.sp),
                                                            children: [
                                                          TextSpan(
                                                              text: '/',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 30.sp,
                                                              )),
                                                          TextSpan(
                                                              text: state
                                                                  .selectedGifts[
                                                                      index]
                                                                  .currentValue
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      30.sp))
                                                        ]))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ))),
                            );
                          },
                        )
                      ]));
            });
      });
}
