import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/divider.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/rate_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class DoctorDetailsReviewsWidget extends StatelessWidget {
  const DoctorDetailsReviewsWidget({super.key, required this.doctorId});
  final String doctorId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.patientsReviews.localize,
            style: Styles.headerText(),
          ),
          const Sizer(),
          BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
            builder: (context, state) {
              var cubit = context.read<DoctorDetailsCubit>();
              if(cubit.rates.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 50.h),
                  child: Center(child: Text(LocaleKeys.noReviews.localize)),
                );
              }else{
                return Column(
                  children: [
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cubit.rates.length>2?2:cubit.rates.length,
                      separatorBuilder: (context, index) =>
                      const DoctorDetailsDivider(),
                      itemBuilder: (context, index) =>
                          UserDoctorRateCard(rate: cubit.rates[index]),
                    ),
                    const Sizer(),
                    if(cubit.rates.length>2)AppButton(label: LocaleKeys.viewAll.localize, onPressed: (){
                      context.push(Routes.DOCTORREVIEWS,extra: doctorId);
                    },style: Styles.headerText(color: Colors.white),)
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
