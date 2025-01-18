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

class BasicInfoPartScreen extends StatelessWidget {
  const BasicInfoPartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var rideRegisterCubit = context.read<RegisterRiderCubit>();
    return SharedScaffold(
      mainCategoryId: 1,
      body: Column(
        children: [
          const Sizer(),
          const UserInfoCardRegisterRideWidget(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppButton(
              color: Colors.white,
              backColor: AppColors.PRIMARY_COLOR,
              onPressed: () async {
                PartsSocketModel model = PartsSocketModel(
                    basicInfo: PartModel(
                        part: BasicInfoPartModel(
                          birthDate: rideRegisterCubit.model.birthDate,
                          firstName: rideRegisterCubit.model.driverFirstName,
                          image: rideRegisterCubit.model.driverImage,
                          lastName: rideRegisterCubit.model.driverLastName,
                          phoneNumber: rideRegisterCubit.model.phone,
                        ),
                        active: true));
                await CacheManager.saveSocketPartModel(model);
                PartsSocketModel? checkModel =
                    await CacheManager.getSocketPartModel();
                context
                    .read<CheckPartActiveCubit>()
                    .check(model: checkModel ?? PartsSocketModel());
                context.pop();
              },
              label: LocaleKeys.submit,
            ),
          ),
          const Sizer(
            height: 50,
          )
        ],
      ),
    );
  }
}
