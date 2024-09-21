import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_brands/fetch_car_brands_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_models/fetch_car_models_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_year_type/fetch_car_year_type_cubit.dart';

class CarInfoRider extends StatefulWidget {
  const CarInfoRider({super.key});

  @override
  State<CarInfoRider> createState() => _CarInfoRiderState();
}

class _CarInfoRiderState extends State<CarInfoRider> {
  late FetchCarBrandsCubit fetchCarBrandsCubit;
  late FetchCarModelsCubit fetchCarModelsCubit;
  late FetchCarYearTypeCubit fetchCarYearTypeCubit;
  late RegisterRiderCubit riderCubit;

  @override
  void initState() {
    fetchCarBrandsCubit = context.read<FetchCarBrandsCubit>();
    fetchCarModelsCubit = context.read<FetchCarModelsCubit>();
    fetchCarYearTypeCubit = context.read<FetchCarYearTypeCubit>();
    riderCubit = context.read<RegisterRiderCubit>();
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
                  riderCubit.pickBrand(value);
                  fetchCarModelsCubit.fetchCarModel(brand: value);
                  fetchCarBrandsCubit.fetchCarBrand(search: value);
                },
                validator: (value) {
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
                  riderCubit.pickModel(value);
                  if (value.length == 1) {
                    fetchCarModelsCubit.fetchCarModel(
                        brand: fetchCarBrandsCubit.brand ?? '');
                  }
                },
                validator: (value) {
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
        const Sizer(),
        Expanded(
          // height: 50,
          // width: 150,
          child: TypeAheadField<String>(
            builder: (context, controller, focusNode) {
              controller.text = fetchCarYearTypeCubit.year ?? '';
              return TextField(
                controller: controller,
                focusNode: focusNode,
                // autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  fillColor: Colors.transparent,
                  hintText: 'Year',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  fetchCarYearTypeCubit.year = value;
                },
              );
            },
            itemBuilder: (context, value) {
              return ListTile(title: Text(value));
            },
            onSelected: (value) {
              riderCubit.pickYear(value);
              setState(() {});
            },
            suggestionsCallback: (search) {
              fetchCarYearTypeCubit.getCarYears(
                brand: fetchCarBrandsCubit.brand ?? '',
                model: fetchCarModelsCubit.model ?? '',
              );
              // log(
              //     fetchCarYearTypeCubit.carYears
              //         .map((e) => e?.year ?? '')
              //         .where((element) =>
              //             element.toLowerCase().contains(search.toLowerCase()))
              //         .toList()
              //         .toString(),
              //     name: "lskjdflskdjflskjdf");
              // return fetchCarYearTypeCubit.carYears.map((e) => e?.year ?? '2000').toList();
              return fetchCarYearTypeCubit.carYears
                  .map((e) => e?.year ?? '')
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
