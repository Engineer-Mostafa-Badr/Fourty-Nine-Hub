import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/fetch_car_brands/fetch_car_brands_cubit.dart';
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
        Text('Car Brand', style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
        TypeAheadField<String>(
          builder: (context, controller, focusNode) {
            return TextField(
                controller: controller,
                focusNode: focusNode,
                // autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  fillColor: Colors.transparent,
                  hintText: 'Model',
                ));
          },
          itemBuilder: (context, value) {
            return ListTile(title: Text(value));
          },
          onSelected: (value) {},
          suggestionsCallback: (search) async {
            if (search.length % 3 == 0 || search.length == 1) {
              context.read<FetchCarBrandsCubit>().fetchCarBrand(search: search);
            }
            return context.read<FetchCarBrandsCubit>().carBrandsList.map((e) => e?.brand ?? '').toList();
          },
        ),
        const Sizer(),
        Text('Car Model', style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
        TypeAheadField<String>(
          builder: (context, controller, focusNode) {
            return TextField(
                controller: controller,
                focusNode: focusNode,
                // autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
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
        Text('Year', style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
        TypeAheadField<String>(
          builder: (context, controller, focusNode) {
            return TextField(
                controller: controller,
                focusNode: focusNode,
                // autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
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
