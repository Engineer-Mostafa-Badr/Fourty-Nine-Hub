import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/basic_info_part_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/part_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/parts_socket_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/cubit/check_part_active_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/user_info_card_register_ride_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../RideRequest/data/models/driver_ride_model/driver_ride_model.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class BasicInfoPartScreen extends StatelessWidget {
  BasicInfoPartScreen({super.key, this.model});
  final PartsSocketModel? model;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var rideRegisterCubit = context.read<RegisterRiderCubit>();
    return SharedScaffold(
      mainCategoryId: 1,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
                minHeight: MediaQuery.of(context).size.height * 0.9),
            child: Column(
              children: [
                const Sizer(),
                UserInfoCardRegisterRideWidget(
                  model: DriverRideModel(
                      image: BasicInfoPartModel.fromJson(
                              model?.basicInfo?.part.toJson())
                          .image,
                      driverFirstName: BasicInfoPartModel.fromJson(
                              model?.basicInfo?.part.toJson())
                          .firstName,
                      driverLastName: BasicInfoPartModel.fromJson(
                              model?.basicInfo?.part.toJson())
                          .lastName,
                      birthDate: BasicInfoPartModel.fromJson(
                              model?.basicInfo?.part.toJson())
                          .birthDate,
                      phone: BasicInfoPartModel.fromJson(
                              model?.basicInfo?.part.toJson())
                          .phoneNumber),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppButton(
                    color: Colors.white,
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () async {
      ManageVibration.vibrate();
                      log(model?.basicInfo?.part.toJson()
                          .toString()??"lskdf", name: "lkdkdkddkdkdk");
                      if (formKey.currentState?.validate() == true) {
                        PartsSocketModel model = PartsSocketModel(
                            basicInfo: PartModel(
                                part: BasicInfoPartModel(
                                  birthDate: rideRegisterCubit.model.birthDate,
                                  firstName:
                                      rideRegisterCubit.model.driverFirstName,
                                  image: rideRegisterCubit.model.driverImage,
                                  lastName:
                                      rideRegisterCubit.model.driverLastName,
                                  phoneNumber: rideRegisterCubit.model.phone,
                                ),
                                active: true));

                        await CacheManager.saveSocketPartModel(model);
                        log(model.toJson().toString(),
                            name: "lskdjflskdjfdkdkdkkkkk");
                        PartsSocketModel? checkModel =
                            await CacheManager.getSocketPartModel();
                        context
                            .read<CheckPartActiveCubit>()
                            .check();
                        context.pop();
                      }
                    },
                    label: LocaleKeys.submit,
                  ),
                ),
                const Sizer(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}