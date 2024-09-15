import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../res/style/app_colors.dart';

class CommentWidget extends StatelessWidget {
  final commentController = TextEditingController();

  CommentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 1,
              title: Row(
                children: [
                  SizedBox(
                    height: 20.h,
                    width: 20,
                    child: const Image(image: AssetImage('images/heart.png')),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '150',
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 20.h,
                    width: 20,
                    child: const Image(image: AssetImage('images/wow.png')),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '122',
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Spacer(),
                  Builder(
                    builder: (ctx) {
                      return ReactionButton<String>(
                        onReactionChanged: (Reaction<String>? value) {},
                        reactions: [
                          Reaction(
                            icon: Container(
                              height: 25.h,
                              width: 25,
                              margin: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5.h,
                              ),
                              child: const Image(
                                image: AssetImage('images/like.png'),
                              ),
                            ),
                            value: 'like',
                          ),
                          Reaction(
                            icon: Container(
                              height: 25.h,
                              width: 25,
                              margin: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5.h,
                              ),
                              child: const Image(
                                image: AssetImage('images/heart.png'),
                              ),
                            ),
                            value: 'love',
                          ),
                          Reaction(
                            icon: Container(
                              height: 25.h,
                              width: 25,
                              margin: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5.h,
                              ),
                              child: const Image(
                                image: AssetImage('images/wow.png'),
                              ),
                            ),
                            value: 'love',
                          ),
                          Reaction(
                            icon: Container(
                              height: 25.h,
                              width: 25,
                              margin: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5.h,
                              ),
                              child: const Image(
                                image: AssetImage('images/sad.png'),
                              ),
                            ),
                            value: 'love',
                          ),
                          Reaction(
                            icon: Container(
                              height: 25.h,
                              width: 25,
                              margin: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5.h,
                              ),
                              child: const Image(
                                image: AssetImage('images/angry.png'),
                              ),
                            ),
                            value: 'love',
                          ),
                        ],
                        itemSize:
                            const Size.fromHeight(kTextTabBarHeight / 1.5),
                      );
                      //   ini: Reaction<String>(
                      //     value: null,
                      //     icon: const Icon(
                      //       Icons.favorite_outline_rounded,
                      //       color: Colors.grey,
                      //     ),
                      //   ),
                      //   boxRadius: 10,
                      //   boxElevation: 2,
                      //   boxAnimationDuration: const Duration(milliseconds: 200),
                      //   itemSize: Size.fromHeight(kTextTabBarHeight/1.5),
                      // );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundImage: CachedNetworkImageProvider(
                            'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg',
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xfff3f3f3),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sara Ahmed',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.earthAmericas,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '4:12 pm',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Gorgeous',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xfff3f3f3),
                      ),
                      child: TextField(
                        controller: commentController,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type your comment',
                          suffixIcon: const Icon(
                            Icons.send,
                            color: AppColors.PRIMARY_COLOR,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                const BorderSide(color: Color(0xfff3f3f3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Color(0xfff3f3f3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
