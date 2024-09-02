import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class RoomInfoWidget extends StatelessWidget {
  const RoomInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  spreadRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: [
                const ProfileImage(accountId: 0,userId: '',),
                const Sizer(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Label(
                          text: 'Public',
                          style:
                              Styles.mediumText(fontWeight: FontWeight.bold)),
                      Label(
                          text: 'Anyone on 49 can join',
                          style: Styles.mediumText(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Sizer(
            height: 20,
          ),
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xfff3f3f3),
            ),
            child: TextField(
              textAlignVertical: TextAlignVertical.bottom,
              style: const TextStyle(color: Colors.black, fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Room title',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xfff3f3f3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xfff3f3f3)),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xfff3f3f3),
            ),
            child: Row(
              children: [
                const Text(
                  'Allow Replays',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Switch(
                  value: true,
                  activeColor: AppColors.PRIMARY_COLOR,
                  onChanged: (v) {},
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xfff3f3f3),
            ),
            child: Row(
              children: [
                const Text(
                  'Allow room chat',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Switch(
                  value: true,
                  activeColor: AppColors.PRIMARY_COLOR,
                  onChanged: (v) {},
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xfff3f3f3),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: const Row(
                    children: [
                      Text(
                        'Pinned link',
                        style: TextStyle(),
                      ),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: const Row(
                    children: [
                      Text(
                        'Topics',
                        style: TextStyle(),
                      ),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: const Row(
                    children: [
                      Text(
                        'Language',
                        style: TextStyle(),
                      ),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: const Row(
                    children: [
                      Text(
                        'Hand Raising',
                        style: TextStyle(),
                      ),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              context.push(Routes.CLUBHOUSECHAT);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Start new Room',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
