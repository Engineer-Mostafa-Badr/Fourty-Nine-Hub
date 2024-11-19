import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_brands/fetch_car_brands_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_models/fetch_car_models_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_year_type/fetch_car_year_type_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

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
                  label: Text(LocaleKeys.brand.tr()),
                  isDense: true,
                  // Added this
                  contentPadding: const EdgeInsets.all(14),
                ),
                onChanged: (value) {
                  if (context.isUserLoggedIn) {
                    riderCubit.pickBrand(value);
                    fetchCarModelsCubit.fetchCarModel(brand: value);
                    fetchCarBrandsCubit.fetchCarBrand(search: value);
                  } else {
                    context.push(Routes.LOGIN);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.carBrandRequired.tr();
                  }
                  return null;
                },
              );
            },
            itemBuilder: (context, value) {
              return ListTile(
                  title: Text(
                value,
                style: const TextStyle(color: Colors.black),
              ));
            },
            onSelected: (value) {
              if (context.isUserLoggedIn) {
                fetchCarBrandsCubit.brand = value;
                setState(() {});
              } else {
                context.push(Routes.LOGIN);
              }
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
                  label: Text(LocaleKeys.model.tr()),
                  isDense: true,
                  // Added this
                  contentPadding: const EdgeInsets.all(14),
                ),
                onChanged: (value) {
                  if (context.isUserLoggedIn) {
                    riderCubit.pickModel(value);
                    if (value.length == 1) {
                      fetchCarModelsCubit.fetchCarModel(
                          brand: fetchCarBrandsCubit.brand ?? '');
                    }
                  } else {
                    context.push(Routes.LOGIN);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.carModelRequired.tr();
                  }
                  return null;
                },
              );
            },
            itemBuilder: (context, value) {
              return ListTile(
                  title: Text(
                value,
                style: const TextStyle(color: Colors.black),
              ));
            },
            onSelected: (value) {
              // print(' ============== $value');
              if (context.isUserLoggedIn) {
                fetchCarModelsCubit.model = value;
                setState(() {});
              } else {
                context.push(Routes.LOGIN);
              }
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
              controller.text = fetchCarYearTypeCubit.year??"";
              return TextField(
                controller: controller,
                focusNode: focusNode,
                // autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  fillColor: Colors.transparent,
                  hintText: LocaleKeys.Year.tr(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (context.isUserLoggedIn) {
                    fetchCarYearTypeCubit.year = value;
                  } else {
                    context.push(Routes.LOGIN);
                  }
                },
              );
            },
            itemBuilder: (context, value) {
              return ListTile(
                  title: Text(
                value,
                style: const TextStyle(color: Colors.black),
              ));
            },
            onSelected: (value) {
              if (context.isUserLoggedIn) {
                log(value.toString());
                riderCubit.pickYear(value);
                setState(() {});
              } else {
                context.push(Routes.LOGIN);
              }
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
