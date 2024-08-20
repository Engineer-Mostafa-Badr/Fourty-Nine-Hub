import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';

class SelectActivity extends StatelessWidget {
  final List<ActivityEntity> activities;
  final Function(ActivityEntity) onSelected;

  const SelectActivity(
      {super.key, required this.activities, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Select Activity',
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 4),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final item = activities[index];
            return InkWell(
              onTap: () {
                onSelected(item);
                Navigator.pop(context, item);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: .5)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(item.image),
                    ),
                    const Sizer(),
                    Expanded(child: Label(text: item.name))
                  ],
                ),
              ),
            );
          }),
    );
  }
}
