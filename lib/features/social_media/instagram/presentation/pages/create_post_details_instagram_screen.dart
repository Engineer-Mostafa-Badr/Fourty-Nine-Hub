import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreatePostDetailsInstagramScreen extends StatelessWidget {
  const CreatePostDetailsInstagramScreen({super.key, required this.images});
  final List<File> images;
  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Sizer(),
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: images.map(
                    (e) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
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
            Sizer(),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Write a caption...",
                          hintStyle:
                              Styles.headerText(fontWeight: FontWeight.w400),
                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          filled: false),
                    ),
                    Sizer(height: 70,),
                    Divider(),
                    Sizer(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person_pin_outlined,
                          size: 30,
                        ),
                        Sizer(),
                        Text(
                          "Tag people",
                          style: Styles.headerText(fontWeight: FontWeight.w400),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                    Sizer(
                      height: 8,
                    ),
                    Divider(),
                    Sizer(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Image.asset(Assets.musicalNote),
                        Sizer(),
                        Text(
                          "Add music",
                          style: Styles.headerText(fontWeight: FontWeight.w400),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                    Sizer(
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
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                padding: EdgeInsets.symmetric(
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
                                    Sizer(),
                                    Text(
                                      "Music Name",
                                      style: Styles.mediumText(fontSize: 27),
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Sizer(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          Assets.audienceIcon,
                          width: 28,
                        ),
                        Sizer(),
                        Text(
                          "Audience",
                          style: Styles.headerText(fontWeight: FontWeight.w400),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                    Sizer(
                      height: 8,
                    ),
                    Divider(),
                    Sizer(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 30,
                        ),
                        Sizer(),
                        Text(
                          "Add location",
                          style: Styles.headerText(fontWeight: FontWeight.w400),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    ),
                    Sizer(
                      height: 50,
                    ),
                    Container(
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
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
