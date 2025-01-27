import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/drag_analysis_part_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/part_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/parts_socket_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/cubit/check_part_active_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/picture_optional_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/criminal_record_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/drag_analysis_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/expiration_date_driver_license_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/technical_examination_register_card_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class DragAnalysisPartScreen extends StatelessWidget {
  DragAnalysisPartScreen({super.key});
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var registerRider = context.read<RegisterRiderCubit>();
    return SharedScaffold(
      mainCategoryId: 1,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              BlocBuilder<PictureOptionalCubit, RiderState>(
                  builder: (context, state) {
                    log(state.toString(), name: "lsdjfslkdjflskjfddddkdkdkk");
                    if (state is SuccessGetPictureOptionalState) {
                      if (state.value.dragAnalytics?.open ?? false) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state.value.dragAnalytics?.open ?? false)
                              Column(
                                children: [
                                  const Sizer(
                                    height: 30,
                                  ),
                                  const DragAnalysisRegisterCardWidget(),
                                  const Sizer(
                                    height: 30,
                                  ),
                                  //
                                  ExpirationDateDriverLicenseCardRegisterWidget(
                                    onTap: (date) {
                                      context
                                          .read<RegisterRiderCubit>()
                                          .model
                                          .dragAnalysisDate = date.toString();
                                    },
                                  ),
                                ],
                              ),
                            // criminalRecord
                            if (state.value.criminalRecord?.open ?? false)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Sizer(
                                    height: 30,
                                  ),
                                  const CriminalRecordRegisterCardWidget(),
                                  const Sizer(
                                    height: 30,
                                  ),
                                  //
                                  ExpirationDateDriverLicenseCardRegisterWidget(
                                    onTap: (date) {
                                      context
                                          .read<RegisterRiderCubit>()
                                          .model
                                          .criminalRecordDate = date.toString();
                                    },
                                  ),
                                ],
                              ),
                            //technicalExamination
                            if (state.value.technicalExamination?.open ?? false)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Sizer(
                                    height: 30,
                                  ),
                                  const TechnicalExaminationRegisterCardWidget(),
                                  const Sizer(
                                    height: 30,
                                  ),
                                  //
                                  ExpirationDateDriverLicenseCardRegisterWidget(
                                    onTap: (date) {
                                      context
                                              .read<RegisterRiderCubit>()
                                              .model
                                              .technicalExaminationDate =
                                          date.toString();
                                    },
                                  ),
                                ],
                              )
                          ],
                        );
                      } else {
                        return Container(
                            // width: 150,
                            // height: 150,
                            // color: Colors.red,
                            );
                      }
                    } else {
                      return Container();
                    }
                  },
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
                        checkModel?.dragAnalysisPart = PartModel(
                            part: DragAnalysisPartModel(
                              criminal: registerRider.model.criminalRecordImage.toString(),
                              criminalDate: registerRider.model.criminalRecordDate.toString(),
                              drug: registerRider.model.dragAnalysis.toString(),
                              drugDate: registerRider.model.dragAnalysisDate.toString(),
                              technical: registerRider.model.technicalExaminationImage.toString(),
                              technicalDate: registerRider.model.technicalExaminationDate.toString()
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
