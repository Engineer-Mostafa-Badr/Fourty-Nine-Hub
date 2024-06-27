import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/models/public/city_model.dart';


class SelectCity extends StatelessWidget {
  final List<CityModel> cities;
  final Function(CityModel) onSelected;
  const SelectCity(
      {super.key, required this.cities, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: ListView.separated(
          itemBuilder: (context, index) {
            final city = cities[index];
            return ListTile(
              title: Label(text: city.name),
              onTap: () {
                onSelected(city);
                context.pop();
              },
            );
          },
          separatorBuilder: (context, index) => const SizedBox(),
          itemCount: cities.length),
    );
  }
}
