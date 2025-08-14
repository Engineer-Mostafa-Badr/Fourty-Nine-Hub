import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/Post/create_post_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/Post/post_instagram_state.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../service_locator/service_locator.dart';

class CreatePostDetailsInstagramScreen extends StatelessWidget {
  CreatePostDetailsInstagramScreen({super.key, required this.images});
  final List<File> images;
  TextEditingController content = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: BlocConsumer<CreatePostInstagramCubit, PostInstagramState>(
        listener: (context, state) {
          if (state is SuccessCreatePostInstagramState) {
            context.pushReplacement(Routes.HOME);
          }
          if (state is FailurePostInstagramState) {
            showErrorMessage(
                context, getFailureMessage(state.failure, context));
          }
        },
        builder: (context, state) {
          if (state is LoadingPostInstagramState) {
            return const CustomLoading();
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                const Sizer(),
                SizedBox(
                  height: 300,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: images.map(
                        (e) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 300,
                            width: 220,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(e),
                                  fit: BoxFit.cover,
                                )),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
                const Sizer(),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        TextField(
                          controller: content,
                          decoration: InputDecoration(
                              hintText: "Write a caption...",
                              hintStyle: Styles.headerText(
                                  fontWeight: FontWeight.w400),
                              border: InputBorder.none,
                              errorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              filled: false),
                        ),
                        const Sizer(
                          height: 70,
                        ),
                        const Divider(),
                        const Sizer(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.person_pin_outlined,
                              size: 30,
                            ),
                            const Sizer(),
                            Text(
                              "Tag people",
                              style: Styles.headerText(
                                  fontWeight: FontWeight.w400),
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios_outlined)
                          ],
                        ),
                        const Sizer(
                          height: 8,
                        ),
                        const Divider(),
                        const Sizer(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Image.asset(Assets.musicalNote),
                            const Sizer(),
                            Text(
                              "Add music",
                              style: Styles.headerText(
                                  fontWeight: FontWeight.w400),
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios_outlined)
                          ],
                        ),
                        const Sizer(
                          height: 8,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...List.generate(
                                10,
                                (index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(7)),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          Assets.musicalNote,
                                          width: 15,
                                        ),
                                        const Sizer(),
                                        Text(
                                          "Music Name",
                                          style:
                                              Styles.mediumText(fontSize: 27),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        const Divider(),
                        const Sizer(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              Assets.audienceIcon,
                              width: 28,
                            ),
                            const Sizer(),
                            Text(
                              "Audience",
                              style: Styles.headerText(
                                  fontWeight: FontWeight.w400),
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios_outlined)
                          ],
                        ),
                        const Sizer(
                          height: 8,
                        ),
                        const Divider(),
                        const Sizer(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 30,
                            ),
                            const Sizer(),
                            Text(
                              "Add location",
                              style: Styles.headerText(
                                  fontWeight: FontWeight.w400),
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios_outlined)
                          ],
                        ),
                        const Sizer(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            serviceLocator<CreatePostInstagramCubit>()
                                .create(content: content.text, images: images);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                                color: AppColors.PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "Share",
                                style: Styles.headerText(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
          );
        },
      ),
    );
  }
}
