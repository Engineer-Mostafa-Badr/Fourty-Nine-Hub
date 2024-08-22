import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CarInfo extends StatelessWidget {
  const CarInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Car Info',
      children: [
        const Sizer(),
        Text('Car Brand',
            style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
        TypeAheadField<String>(
          builder: (context, controller, focusNode) {
            return TextField(
                controller: controller,
                focusNode: focusNode,
                // autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  fillColor: Colors.transparent,
                  hintText: 'Model',
                ));
          },
          itemBuilder: (context, value) {
            return ListTile(title: Text(value));
          },
          onSelected: (value) {},
          suggestionsCallback: (search) {
            return ['Toyota', 'Kia', 'Hyndai'];
          },
        ),
        const Sizer(),
        Text('Car Model',
            style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
        TypeAheadField<String>(
          builder: (context, controller, focusNode) {
            return TextField(
                controller: controller,
                focusNode: focusNode,
                // autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  fillColor: Colors.transparent,
                  hintText: 'Brand',
                ));
          },
          itemBuilder: (context, value) {
            return ListTile(title: Text(value));
          },
          onSelected: (value) {},
          suggestionsCallback: (search) {
            return ['Toyota', 'Kia', 'Hyndai'];
          },
        ),
        const Sizer(),
        Text('Year',
            style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
        TypeAheadField<String>(
          builder: (context, controller, focusNode) {
            return TextField(
                controller: controller,
                focusNode: focusNode,
                // autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  fillColor: Colors.transparent,
                  hintText: 'Year',
                ));
          },
          itemBuilder: (context, value) {
            return ListTile(title: Text(value));
          },
          onSelected: (value) {},
          suggestionsCallback: (search) {
            return ['Toyota', 'Kia', 'Hyndai'];
          },
        ),
        const Sizer(),
      ],
    );
  }
}
