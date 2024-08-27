import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/card_title_and_info.dart';

class DestionationPointSuggestion extends StatelessWidget {
  const DestionationPointSuggestion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...cardTitleAndInfo(title: 'Destination Point'),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 6,
            // itemExtent: 50,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Radio(
                        value: index,
                        groupValue: 'destinationPoint',
                        onChanged: (value) {}),
                    const Expanded(
                      child: Flexible(
                        child: Text(
                            overflow: TextOverflow.visible,
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Sizer(),
          CustomButton(
            onTap: () {},
            title: 'Save destination point address',
            height: 40,
          ),
        ],
      ),
    );
  }
}
