import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/ReadMoreLabel.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';

import '../../../../../../res/style/app_colors.dart';

class MessageCard extends StatelessWidget {
  final bool isMine;

  const MessageCard({super.key, required this.isMine});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return isMine
        ? _buildMineMessage(width: width)
        : _buildOtherMessage(width: width);
  }

  Widget _buildMineMessage({
    required double width,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: width / 1.5,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: AppColors.PRIMARY_COLOR,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
          child: Column(
            children: [
              ReadMoreLabel(
                trimLines: 5,
                text: UIConst.placeholderText,
                style: Styles.mediumText(color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Label(
                      text: '3:16 PM',
                      style: Styles.smallText(color: Colors.white)),
                  const Sizer(),
                  const Icon(
                    FontAwesomeIcons.checkDouble,
                    color: Colors.white,
                    size: 10,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtherMessage({required double width}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CircleAvatar(
          radius: 15,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
        ),
        const Sizer(width: 5,),
        Container(
          width: width / 1.5,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Column(
            children: [
              ReadMoreLabel(
                trimLines: 5,
                text: UIConst.placeholderText,
                style: Styles.mediumText(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
