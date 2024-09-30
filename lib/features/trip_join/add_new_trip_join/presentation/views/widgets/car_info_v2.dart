import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_brands/fetch_car_brands_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_models/fetch_car_models_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_year_type/fetch_car_year_type_cubit.dart';

class CarInfoV2 extends StatefulWidget {
  const CarInfoV2({
    super.key,
  });

  @override
  State<CarInfoV2> createState() => _CarInfoV2State();
}

class _CarInfoV2State extends State<CarInfoV2> {
  late FetchCarBrandsCubit fetchCarBrandsCubit;
  late FetchCarModelsCubit fetchCarModelsCubit;
  late FetchCarYearTypeCubit fetchCarYearTypeCubit;

  @override
  void initState() {
    fetchCarBrandsCubit = context.read<FetchCarBrandsCubit>();
    fetchCarModelsCubit = context.read<FetchCarModelsCubit>();
    fetchCarYearTypeCubit = context.read<FetchCarYearTypeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: TypeAheadField<String>(
            builder: (context, controller, focusNode) {
              controller.text = fetchCarBrandsCubit.brand ?? '';
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                // autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  fillColor: Colors.transparent,
                  label: const Text('Brand'),
                  isDense: true,
                  // Added this
                  contentPadding: const EdgeInsets.all(14),
                ),
                onChanged: (value) {
                  fetchCarBrandsCubit.brand = value;
                  // print(' ============ $value');
                  fetchCarModelsCubit.fetchCarModel(brand: value);
                  fetchCarBrandsCubit.fetchCarBrand(search: value);
                },
                validator: (value) {
                  return null;
                  log(value.toString(),
                      name: "==========================================");
                  if (value == null || value.isEmpty) {
                    return 'Car Brand Required';
                  }
                  return null;
                },
              );
            },
            itemBuilder: (context, value) {
              return ListTile(title: Text(value));
            },
            onSelected: (value) {
              fetchCarModelsCubit.fetchCarModel(brand: value);
              fetchCarBrandsCubit.brand = value;
              setState(() {});
            },
            suggestionsCallback: (search) async {
              // fetchCarBrandsCubit.brand = search;
              return fetchCarBrandsCubit.carBrandsList
                  .map((e) => e?.brand ?? '')
                  .toList();
            },
          ),
        ),
        const Sizer(),
        Expanded(
          flex: 1,
          child: TypeAheadField<String>(
            builder: (context, controller, focusNode) {
              controller.text = fetchCarModelsCubit.model ?? '';
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                // autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  fillColor: Colors.transparent,
                  label: const Text('Model'),
                  isDense: true,
                  // Added this
                  contentPadding: const EdgeInsets.all(14),
                ),
                onChanged: (value) {
                  fetchCarModelsCubit.model = value;
                  if (value.length == 1) {
                    fetchCarModelsCubit.fetchCarModel(
                        brand: fetchCarBrandsCubit.brand ?? '');
                  }
                },
                validator: (value) {
                  return null;
                  log(value.toString(),
                      name: "==========================================");
                  if (value == null || value.isEmpty) {
                    return 'Car Model Required';
                  }
                  return null;
                },
              );
            },
            itemBuilder: (context, value) {
              return ListTile(title: Text(value));
            },
            onSelected: (value) {
              // print(' ============== $value');
              fetchCarModelsCubit.model = value;
              setState(() {});
            },
            suggestionsCallback: (search) async {
              return fetchCarModelsCubit.carModels
                  .map((e) => e?.model ?? '')
                  .where((element) =>
                      element.toLowerCase().contains(search.toLowerCase()))
                  .toList();
            },
          ),
        ),
      ],
    );
  }
}
