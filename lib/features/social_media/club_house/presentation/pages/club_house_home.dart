import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';

import '../widgets/audioRoomCard.dart';

class ClubHouseHome extends StatelessWidget {
  const ClubHouseHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
        mainCategoryId: 3,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.separated(
            itemCount: 12,
            itemBuilder: (context, index) {
              return AudioRoomCard();
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
          ),
        ));
  }
}
