import 'package:flutter/material.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../widgets/roomType.dart';

import '../../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../../common/widgets/dynamic/drawer.dart';
import '../../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../widgets/audioRoomCard.dart';

class ClubHouseHome extends StatelessWidget {
  const ClubHouseHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      bottomNavigationBar: const BottomNavigator(
        mainCategory: 0,
        index: 2,
      ),
      floatingActionButton: FloatingButton(
        icon: Icons.add,
        onTap: () {
          bottomSheet(context: context, widget: RoomTypeWidget());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomSheet: AppButton(label: 'Start Chatting Room', onPressed: () {}),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
          itemCount: 12,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return AudioRoomCard();
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 10,
            );
          },
        ),
      ),
    );
  }
}
