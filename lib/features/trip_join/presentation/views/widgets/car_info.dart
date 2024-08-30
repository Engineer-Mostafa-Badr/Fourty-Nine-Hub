import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/fetch_car_brands/fetch_car_brands_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/fetch_car_models/fetch_car_models_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/fetch_car_year_type/fetch_car_year_type_cubit.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CarInfo extends StatefulWidget {
  const CarInfo({
    super.key,
  });

  @override
  State<CarInfo> createState() => _CarInfoState();
}

class _CarInfoState extends State<CarInfo> {
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
    return CustomCard(
      title: 'Car Info',
      children: [
        const Sizer(),
        Text('Car Brand',
            style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
        TypeAheadField<String>(
          builder: (context, controller, focusNode) {
            controller.text = fetchCarBrandsCubit.brand ?? '';
            return TextField(
              controller: controller,
              focusNode: focusNode,
              // autofocus: true,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                fillColor: Colors.transparent,
                hintText: 'Brand',
              ),
              onChanged: (value) {
                fetchCarBrandsCubit.brand = value;
                // print(' ============ $value');
                fetchCarModelsCubit.fetchCarModel(brand: value);
                fetchCarBrandsCubit.fetchCarBrand(search: value);
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
        const Sizer(),
        Text('Car Model',
            style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
        TypeAheadField<String>(
          builder: (context, controller, focusNode) {
            controller.text = fetchCarModelsCubit.model ?? '';
            return TextField(
              controller: controller,
              focusNode: focusNode,
              // autofocus: true,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                fillColor: Colors.transparent,
                hintText: 'Model',
              ),
              onChanged: (value) {
                fetchCarModelsCubit.model = value;
                if (value.length == 1) {
                  fetchCarModelsCubit.fetchCarModel(
                      brand: fetchCarBrandsCubit.brand ?? '');
                }
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
        const Sizer(),
        Text('Year',
            style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
        TypeAheadField<String>(
          builder: (context, controller, focusNode) {
            controller.text = fetchCarYearTypeCubit.year ?? '';
            return TextField(
              controller: controller,
              focusNode: focusNode,
              // autofocus: true,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
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
            fetchCarYearTypeCubit.year = value;
            setState(() {});
          },
          suggestionsCallback: (search) {
            fetchCarYearTypeCubit.getCarYears(
              brand: fetchCarBrandsCubit.brand ?? '',
              model: fetchCarModelsCubit.model ?? '',
            );
            return fetchCarYearTypeCubit.carYears
                .map((e) => e?.year ?? '2000')
                .toList();
            // return fetchCarYearTypeCubit.carYears
            //     .map((e) => e?.year ?? '')
            //     .where((element) => element.toLowerCase().contains(search.toLowerCase()))
            //     .toList();
          },
        ),
        const Sizer(),
      ],
    );
  }
}
