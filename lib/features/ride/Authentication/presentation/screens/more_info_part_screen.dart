import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/more_info_part_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/part_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/parts_socket_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/cubit/check_part_active_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/more_information_register_card_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class MoreInfoPartScreen extends StatelessWidget {
  MoreInfoPartScreen({super.key});
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final registerRider = context.read<RegisterRiderCubit>();
    return SharedScaffold(
      mainCategoryId: 1,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Sizer(
                  height: 30,
                ),
              MoreInformationRegisterCardWidget(),
                Sizer(
                  height: 30,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: AppButton(
                      color: Colors.white,
                      backColor: AppColors.PRIMARY_COLOR,
                      label: LocaleKeys.submit.tr(),
                      onPressed: () async {
                        log("model.toJson()", name: 'lsdkfdkd029384jslkdjf');
                        if (formKey.currentState?.validate() == true) {
                          PartsSocketModel? checkModel =
                              await CacheManager.getSocketPartModel();
                          checkModel?.moreInfo = PartModel(
                              part: MoreInfoPartModel(
                                city: registerRider.model.governorateNameAr.toString(),
                                pricing: registerRider.model.pricingPerKm.toString(),
                                suscription: registerRider.model.workingType.toString()
                              ),
                              active: true);
                          await CacheManager.saveSocketPartModel(checkModel!);
              
                          context.read<CheckPartActiveCubit>().check();
                          context.pushReplacement(Routes.RIDERREGISTER);
                        }
                      },
                    ),
                  ),
                  Sizer(
                    height: 60,
                  )
            ],
          ),
        ),
      ),
    );
  }
}
