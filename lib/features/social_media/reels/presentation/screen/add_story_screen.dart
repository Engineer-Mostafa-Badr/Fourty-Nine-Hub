import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class AddStoryScreen extends StatelessWidget {
  const AddStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(body: AddStoryBody());
  }
}

class AddStoryBody extends StatefulWidget {
  const AddStoryBody({super.key});

  @override
  State<AddStoryBody> createState() => _AddStoryBodyState();
}

class _AddStoryBodyState extends State<AddStoryBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: Stack(
        children: [
          // الخلفية بتدرج اللون
          Container(
            margin: EdgeInsets.only(top: 50, bottom: 80),
            decoration: const BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(20),
                topEnd: Radius.circular(20),
                bottomEnd: Radius.circular(20),
                bottomStart: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1E2F41),
                  Color(0xFF7F7F7F),
                ],
              ),
            ),
          ),
          // المحتوى الأساسي
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 40.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // يخلي كل العناصر تبدا من فوق
                    children: [
                      const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 20),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            constraints: const BoxConstraints(maxWidth: 140),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.music_note,
                                    color: Colors.white, size: 14),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    "Amr Diab Music...",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // هنا بقى نخلي الكولم طالع لفوق أكتر باستخدام Align
                      Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start, // مهم جدا
                          children: [
                            SvgPicture.asset(Assets.aaIcon),
                            const SizedBox(height: 20),
                            SvgPicture.asset(Assets.stickerIcon),
                            const SizedBox(height: 20),
                            SvgPicture.asset(Assets.cameraStoryIcon),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Center(
                  child: Container(
                    width: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.asset(
                              Assets.amrImage,
                            )),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1F2C3B),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Amr Diab Music',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    'Amr Diab Music',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  Spacer(),
                                  Icon(Icons.bar_chart,
                                      size: 14, color: Colors.white),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // زر Your Story
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                              'https://randomuser.me/api/portraits/men/12.jpg'),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Your Story",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
