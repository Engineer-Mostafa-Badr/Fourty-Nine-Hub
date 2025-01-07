import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/car_models_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/color_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/get_car_brand_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/get_car_colors_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/get_car_model_by_brand_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/get_car_year_by_model_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/CarInfo/select_car_model_brand_year_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/validation_error_widget.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/models/car_brand_model.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/data/models/car_year_type_model.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CarModelRegisterCardWidget extends StatefulWidget {
  const CarModelRegisterCardWidget({super.key});

  @override
  State<CarModelRegisterCardWidget> createState() =>
      _CarModelRegisterCardWidgetState();
}

class _CarModelRegisterCardWidgetState
    extends State<CarModelRegisterCardWidget> {
  String? selectBrand;
  String? selectModel;
  @override
  Widget build(BuildContext context) {
    var rideRegisterCubit = context.read<RegisterRiderCubit>();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: context.isDarkMode
              ? AppColors.UNSELECTED_DARK_GRAY_COLOR
              : Colors.white,
          boxShadow: context.isDarkMode
              ? []
              : [BoxShadow(color: Colors.grey.shade400, blurRadius: 30)]),
      child: Column(
        children: [
          Text(
            context.isArabic ? "معلومات السيارة" : "Car Information",
            style: Styles.headerText(fontWeight: FontWeight.w500, fontSize: 40),
          ),
          const Sizer(),
          BlocBuilder<GetCarBrandRideCubit, RiderState>(
            builder: (context, state) {
              if (state is LoadingRiderState) {
                return const CircularProgressIndicator(
                  color: AppColors.PRIMARY_COLOR,
                );
              }
              if (state is SuccessGetCarBrandRideState) {
                return FormField(
                  validator: (value) {
                    return context
                                .read<SelectCarModelBrandYearRideCubit>()
                                .brand ==
                            null
                        ? context.isArabic
                            ? "يرجى اختيار ماركة السيارة"
                            : "Please select car brand"
                        : null;
                  },
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              border: field.hasError
                                  ? Border.all(
                                      color: AppColors.SECONDARY_COLOR_DARK)
                                  : null,
                              color: context.isDarkMode
                                  ? Colors.black12
                                  : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButton<CarBrandModel>(
                                    underline: Container(),
                                    icon: Container(),
                                    hint: Text(context
                                            .read<
                                                SelectCarModelBrandYearRideCubit>()
                                            .brand
                                            ?.brand ??
                                        (context.isArabic
                                            ? "ماركة السيارة"
                                            : "Car Brand")),
                                    items: state.list
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e.brand),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      context
                                          .read<GetCarModelByBrandRideCubit>()
                                          .get(brand: value?.brand ?? "");
                                      context
                                          .read<
                                              SelectCarModelBrandYearRideCubit>()
                                          .selectBrand(value: value);
                                      rideRegisterCubit.model.vehicleBrand =
                                          value?.brand ?? "";
                                      setState(() {});
                                    },
                                    dropdownColor: context.isDarkMode
                                        ? AppColors.DARK_BLUE_COLOR
                                        : Colors.white),
                              ),
                              const Icon(Icons.keyboard_arrow_down_outlined)
                            ],
                          ),
                        ),
                        if (field.hasError)
                          ValidationErrorWidget(message: field.errorText ?? "")
                      ],
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          const Sizer(),
          BlocBuilder<GetCarModelByBrandRideCubit, RiderState>(
            builder: (context, state) {
              if (state is LoadingRiderState) {
                return const CircularProgressIndicator(
                  color: AppColors.PRIMARY_COLOR,
                );
              }
              if (state is SuccessGetCarModelByBrandRideState) {
                return FormField(
                  validator: (value) {
                    return context
                                .read<SelectCarModelBrandYearRideCubit>()
                                .model ==
                            null
                        ? context.isArabic
                            ? "يرجى اختيار موديل السيارة"
                            : "Please select car model"
                        : null;
                  },
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              border: field.hasError
                                  ? Border.all(
                                      color: AppColors.SECONDARY_COLOR_DARK)
                                  : null,
                              color: context.isDarkMode
                                  ? Colors.black12
                                  : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButton<CarModelsModel>(
                                    underline: Container(),
                                    icon: Container(),
                                    hint: Text(context
                                            .read<
                                                SelectCarModelBrandYearRideCubit>()
                                            .model
                                            ?.model ??
                                        (context.isArabic
                                            ? "موديل السيارة"
                                            : "Car Model")),
                                    items: state.list
                                        .map(
                                          (e) =>
                                              DropdownMenuItem<CarModelsModel>(
                                            value: e,
                                            child: Text(e.model ?? ""),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      context
                                          .read<
                                              SelectCarModelBrandYearRideCubit>()
                                          .selectModel(value: value);
                                      rideRegisterCubit.model.vehicleModel =
                                          value?.model ?? "";
                                      context
                                          .read<GetCarYearByModelRideCubit>()
                                          .get(
                                              brand: context
                                                      .read<
                                                          SelectCarModelBrandYearRideCubit>()
                                                      .brand
                                                      ?.brand ??
                                                  "",
                                              model: value?.model ?? "");
                                      setState(() {});
                                    },
                                    dropdownColor: context.isDarkMode
                                        ? AppColors.DARK_BLUE_COLOR
                                        : Colors.white),
                              ),
                              const Icon(Icons.keyboard_arrow_down_outlined)
                            ],
                          ),
                        ),
                        if (field.hasError)
                          ValidationErrorWidget(message: field.errorText ?? "")
                      ],
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          const Sizer(),
          BlocBuilder<GetCarYearByModelRideCubit, RiderState>(
            builder: (context, state) {
              if (state is LoadingRiderState) {
                return const CircularProgressIndicator(
                  color: AppColors.PRIMARY_COLOR,
                );
              }
              if (state is SuccessGetCarYearTypeRideState) {
                return FormField(
                  validator: (value) {
                    return context
                                .read<SelectCarModelBrandYearRideCubit>()
                                .year ==
                            null
                        ? context.isArabic
                            ? "يرجى اختيار سنة السيارة"
                            : "Please select car year"
                        : null;
                  },
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              border: field.hasError
                                  ? Border.all(
                                      color: AppColors.SECONDARY_COLOR_DARK)
                                  : null,
                              color: context.isDarkMode
                                  ? Colors.black12
                                  : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButton<CarYearTypeModel>(
                                    underline: Container(),
                                    icon: Container(),
                                    hint: Text(context
                                            .read<
                                                SelectCarModelBrandYearRideCubit>()
                                            .year
                                            ?.year ??
                                        (context.isArabic ? "السنة" : "Year")),
                                    items: state.list
                                        .map(
                                          (e) => DropdownMenuItem<
                                              CarYearTypeModel>(
                                            value: e,
                                            child: Text(e.year ?? ""),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      rideRegisterCubit.model.vehicleYear =
                                          value?.year ?? "";
                                      context
                                          .read<
                                              SelectCarModelBrandYearRideCubit>()
                                          .selectYear(value: value);
                                      setState(() {});
                                    },
                                    dropdownColor: context.isDarkMode
                                        ? AppColors.DARK_BLUE_COLOR
                                        : Colors.white),
                              ),
                              const Icon(Icons.keyboard_arrow_down_outlined)
                            ],
                          ),
                        ),
                        if (field.hasError)
                          ValidationErrorWidget(message: field.errorText ?? "")
                      ],
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          if (context.read<SelectCarModelBrandYearRideCubit>().brand != null &&
              context.read<SelectCarModelBrandYearRideCubit>().model != null &&
              context.read<SelectCarModelBrandYearRideCubit>().year != null)
            Column(
              children: [
                const Sizer(),
                BlocBuilder<GetCarColorsRideCubit, RiderState>(
                  builder: (context, state) {
                    if (state is LoadingRiderState) {
                      return const CircularProgressIndicator(
                        color: AppColors.PRIMARY_COLOR,
                      );
                    }
                    if (state is SuccessGetCarColorsRideState) {
                      return FormField(
                        validator: (value) {
                          return context
                                      .read<SelectCarModelBrandYearRideCubit>()
                                      .color ==
                                  null
                              ? context.isArabic
                                  ? "يرجى اختيار لون السيارة"
                                  : "Please select car color"
                              : null;
                        },
                        builder: (field) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                    border: field.hasError
                                        ? Border.all(
                                            color:
                                                AppColors.SECONDARY_COLOR_DARK)
                                        : null,
                                    color: context.isDarkMode
                                        ? Colors.black12
                                        : Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButton<ColorModel>(
                                          underline: Container(),
                                          icon: Container(),
                                          hint: context
                                                      .read<
                                                          SelectCarModelBrandYearRideCubit>()
                                                      .color ==
                                                  null
                                              ? Text(context.isArabic
                                                  ? "لون السيارة"
                                                  : "Car Color")
                                              : Row(
                                                  children: [
                                                    Container(
                                                      width: 25,
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .PRIMARY_COLOR),
                                                          color: Color(int.tryParse(
                                                                  '0xff${context.read<SelectCarModelBrandYearRideCubit>().color?.code?.split("#").last}') ??
                                                              0xFFFFFFFF),
                                                          shape:
                                                              BoxShape.circle),
                                                    ),
                                                    const Sizer(),
                                                    Text(context
                                                            .read<
                                                                SelectCarModelBrandYearRideCubit>()
                                                            .color
                                                            ?.nameArabic ??
                                                        "")
                                                  ],
                                                ),
                                          items: state.list
                                              .map(
                                                (e) => DropdownMenuItem<
                                                    ColorModel>(
                                                  value: e,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 25,
                                                        height: 25,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .PRIMARY_COLOR),
                                                            color: Color(int.parse(
                                                                '0xff${e.code?.split("#").last}')),
                                                            shape: BoxShape
                                                                .circle),
                                                      ),
                                                      const Sizer(),
                                                      Text(e.nameArabic ?? "")
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            rideRegisterCubit.model
                                                .vehicleColor = value?.id ?? "";
                                            context
                                                .read<
                                                    SelectCarModelBrandYearRideCubit>()
                                                .selectColor(value: value);
                                            setState(() {});
                                          },
                                          dropdownColor: context.isDarkMode
                                              ? AppColors.DARK_BLUE_COLOR
                                              : Colors.white),
                                    ),
                                    const Icon(
                                        Icons.keyboard_arrow_down_outlined)
                                  ],
                                ),
                              ),
                              if (field.hasError)
                                ValidationErrorWidget(
                                    message: field.errorText ?? "")
                            ],
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            )
        ],
      ),
    );
  }
}
