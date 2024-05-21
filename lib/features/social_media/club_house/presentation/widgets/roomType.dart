import 'package:flutter/material.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';

import 'roomInfo.dart';

class RoomTypeWidget extends StatelessWidget {
  const RoomTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: GridView.builder(
            itemCount: 7,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.6, crossAxisCount: 3),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  bottomSheet(
                    context: context,
                    widget: const RoomInfoWidget(),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const ProfileImage(accountId: 0),
                    const Sizer(),
                    Label(text: 'Anyone on 49', style: Styles.mediumText())
                  ],
                ),
              );
            }));
  }
}
