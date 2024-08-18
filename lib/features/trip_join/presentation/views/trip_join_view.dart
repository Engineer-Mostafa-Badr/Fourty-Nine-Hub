// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/destination_text_field_and_find_button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/illustration_image.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/start_text_field_and_find_button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/welcome_text.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripJoinView extends StatelessWidget {
  const TripJoinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Trip Join',
          style: Styles.headerText(fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  ...welcomeText(),
                  const Sizer(),
                  const IllustrationImage(),
                  const Sizer(height: 20),
                  const StartTextFieldAndFindButon(),
                  const Sizer(),
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...cardTitleAndInfo(title: 'Starting Point'),
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
                                  Radio(value: index, groupValue: 'startPoint', onChanged: (value) {}),
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
                          title: 'Save starting point address',
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                  const Sizer(height: 20),
                  const DestinationTextFieldAndFindButon(),
                  const Sizer(),
                  CustomCard(
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
                                  Radio(value: index, groupValue: 'destinationPoint', onChanged: (value) {}),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> cardTitleAndInfo({required String title}) {
  return [
    Text(
      title,
      style: Styles.headerText(fontSize: 24, textAlign: TextAlign.start),
    ),
    Text(
      'Location Suggestion',
      style: Styles.headerText(fontSize: 20, textAlign: TextAlign.start),
    ),
    Text(
      'Please Choose the address that match what you are searching for',
      style: Styles.mediumText(fontSize: 14, fontWeight: FontWeight.w300),
    ),
  ];
}
