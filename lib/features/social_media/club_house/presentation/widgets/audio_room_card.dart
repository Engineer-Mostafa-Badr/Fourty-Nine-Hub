import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/ReadMoreLabel.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../pages/audio_stream_screen.dart';

class AudioRoomCard extends StatelessWidget {
  const AudioRoomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => AudioStreamScreen(
                liveId: '93314', roomSubject: 'Hiring Manager On-Hire', isHost: false),
          ),
        );
      },
      child: Container(
        padding:
            const EdgeInsets.only(right: 100, top: 10, left: 10, bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xfff0f2ff),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            const ReadMoreLabel(
              text: UIConst.placeholderText,
              trimLines: 2,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    children: [
                      Positioned(
                          child: ProfileImage(
                        accountId: 0,
                      )),
                      Positioned(
                          top: 20,
                          left: 20,
                          child: ProfileImage(
                            accountId: 0,
                            withBorder: true,
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ListView.separated(
                        itemCount: 2,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Label(
                                  text: 'Sara Ahmed',
                                  style: Styles.mediumText()),
                              const Sizer(),
                              const Icon(
                                FontAwesomeIcons.comment,
                                color: Colors.grey,
                                size: 15,
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Sizer();
                        },
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 14,
                              ),
                              const Sizer(),
                              Label(
                                  text: '144',
                                  style: Styles.mediumText(color: Colors.grey))
                            ],
                          ),
                          const Sizer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
