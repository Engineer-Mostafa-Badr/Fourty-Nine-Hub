import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../domain/entities/feeling_entity.dart';

class SelectFeelingView extends StatelessWidget {
  final List<FeelingEntity> feelings;
  final Function(FeelingEntity) onSelected;

  const SelectFeelingView(
      {super.key, required this.feelings, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Select Feeling',
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 4),
          itemCount: feelings.length,
          itemBuilder: (context, index) {
            final item = feelings[index];
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
