import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/car_models_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/color_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/models/car_brand_model.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/models/car_year_type_model.dart';

class SelectCarModelBrandYearRideCubit extends Cubit<RiderState> {
  CarBrandModel? brand;
  CarModelsModel? model;
  CarYearTypeModel? year;
  ColorModel? color;
  SelectCarModelBrandYearRideCubit() : super(RiderInitial());

  selectBrand({CarBrandModel? value}) {
    brand = value;
  }

  selectModel({required CarModelsModel? value}) {
    model = value;
  }

  selectYear({required CarYearTypeModel? value}) {
    year = value;
  }

  selectColor({required ColorModel? value}) {
    color = value;
  }
}
