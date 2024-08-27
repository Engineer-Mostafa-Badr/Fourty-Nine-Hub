import 'package:flutter/material.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';

import '../../../../../res/style/app_colors.dart';
import '../../domain/entities/bidding_entity.dart';

class Biddings extends StatelessWidget {
  final List<BiddingEntity> biddingsList;
  const Biddings({super.key, required this.biddingsList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: Labels.biddings,
      ),
      body: ListView.builder(
          itemCount: biddingsList.length,
          itemBuilder: (context, index) {
            return _buildBiddingItem(item: biddingsList[index]);
          }),
    );
  }

  Widget _buildBiddingItem({required BiddingEntity item}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
                item.user.profilePicture ?? UIConst.profilePlaceHolder),
          ),
          const Sizer(),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextAppButton(label: item.user.fullName, onPressed: () {}),
              Label(
                  text: item.formatedSinceTime,
                  style: Styles.mediumText(color: Colors.grey))
            ],
          )),
          const Sizer(),
          Label(
              text: '${item.bidding} ${Labels.currency}',
              style: Styles.headerText(color: AppColors.PRIMARY_COLOR))
        ],
      ),
    );
  }
}
