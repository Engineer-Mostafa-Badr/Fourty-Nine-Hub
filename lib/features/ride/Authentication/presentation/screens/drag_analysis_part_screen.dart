import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/picture_optional_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/criminal_record_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/drag_analysis_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/expiration_date_driver_license_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/technical_examination_register_card_widget.dart';

class DragAnalysisPartScreen extends StatelessWidget {
  const DragAnalysisPartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: SingleChildScrollView(
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
          ],
        ),
      ),
    );
  }
}
