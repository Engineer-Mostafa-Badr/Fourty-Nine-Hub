import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/app_colors.dart';

import '../../../social_posts/presentation/widgets/posts/post_comments.dart';
import 'comment.dart';
import 'report.dart';

class ClubHouseRoom extends StatelessWidget {
  const ClubHouseRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xfff3f3f3),
          onPressed: () {
            context.push(Routes.CHAT);
          },
          child: const Icon(
            Icons.send_outlined,
            color: Colors.grey,
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  bottomSheet(
                    context: context,
                    isScrollControlled: true,
                    widget:  Container(),
                    // widget: const PostComments(),
                  );
                },
                icon: const Icon(
                  FontAwesomeIcons.comment,
                  size: 25,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xfff3f3f3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Share',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CircleAvatar(
                backgroundColor: const Color(0xfff3f3f3),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    FontAwesomeIcons.hand,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '35:45',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: const Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.handPeace,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Leave quitely',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(
                    child: Text(
                      'نقاش عن حقوق المرأة على برنامج  ٤٩ لجميع الخدمات',
                      style: TextStyle(),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  IconButton(
                    onPressed: () {
                      bottomSheet(
                        context: context,
                        widget: ReportWidget(),
                      );
                    },
                    icon: const Icon(FontAwesomeIcons.ellipsis),
                  ),
                ],
              ),
              const Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Replies on',
                      style: TextStyle(color: Colors.green),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      radius: 1,
                      backgroundColor: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '132 here now',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      radius: 1,
                      backgroundColor: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '140',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.person_outline_outlined,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 30,
                child: ListView.separated(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black38, width: .5),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.earthAmericas,
                            size: 16,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Egypt'),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 5,
                    );
                  },
                ),
              ),
              const Sizer(),
              _buildGroupOfPeople(title: 'Speakers', speaking: true),
              const Sizer(),
              _buildGroupOfPeople(
                  title: 'Followed by the speakers', speaking: false),
              const Sizer(),
              _buildGroupOfPeople(title: 'In The room', speaking: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupOfPeople({
    required String title,
    required bool speaking,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          style: Styles.mediumText(fontWeight: FontWeight.bold),
          text: title,
        ),
        const Sizer(),
        GridView.builder(
          itemCount: 8,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.3,
          ),
          itemBuilder: (context, index) {
            return Column(
              children: [
                const ProfileImage(
                  accountId: 0,
                  withBorder: true,
                  size: 22,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (speaking)
                      const Icon(
                        Icons.mic,
                        color: AppColors.SECONDARY_COLOR,
                      ),
                    Label(text: 'Maha Ahmed', style: Styles.mediumText()),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
