import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/medical_services/medical_service_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:shimmer/shimmer.dart';

class HealthMedicalServices extends StatelessWidget {
  const HealthMedicalServices({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthCubit, HealthState>(builder: (context, state) {
        return SizedBox(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              state.medicalServices==null?
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Label(
                    text: LocaleKeys.medicalService.localize,
                    style: Styles.headerText(),
                  ),
                ) :state.medicalServices==[]?
                  const SizedBox.shrink():Label(
                text: LocaleKeys.medicalService.localize,
                style: Styles.headerText(),
              ),
              const Sizer(),
              Expanded(
                child:state.medicalServices != null && state.medicalServices!=[]? ListView.separated(
                  separatorBuilder: (context, index) => const Sizer(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => HealthMedicalServiceCard(
                    subCategory: state.medicalServices![index],
                  ),
                  itemCount: state.medicalServices!.length,
                ):state.medicalServices == null?Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Sizer(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    itemCount: 10,
                  ),
                ):const SizedBox.shrink(),
              ),
              const Sizer(),
            ],
          ),
        );

    });
  }
}
