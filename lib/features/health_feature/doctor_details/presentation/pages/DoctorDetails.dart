
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';

import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/appointments.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/fees_card.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/header.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/reviews.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/loaders/default_loader.dart';
import '../../../../../core/widget/custom_scaffold.dart';

class DoctorDetailsParams {
  final String doctorId;
  final bool? fromSearch;
  final String? subCategoryId;
  final String? type;
  DoctorDetailsParams(
      {required this.doctorId,
      this.fromSearch = false,
      this.type,
      this.subCategoryId});
}

class DoctorDetailsView extends StatefulWidget {
  DoctorDetailsParams? params;
  DoctorDetailsView({super.key, payload}) {
    print("objectitemId$payload");
    if (payload is DoctorDetailsParams) {
      params = payload;
    } else {

      params = DoctorDetailsParams(
          doctorId: payload['doctorId'],
          subCategoryId: payload['subCategoryId'],
          type: payload['type'],
          fromSearch: false);
    }
  }
  @override
  State<DoctorDetailsView> createState() => _DoctorDetailsViewState();
}

class _DoctorDetailsViewState extends State<DoctorDetailsView> {
  @override
  void initState() {
    print("initSubCat${widget.params?.subCategoryId}");
    context.read<DoctorDetailsCubit>().loadData(widget.params!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child:HomeAppbar(
          isWithBackArrow: true,
          onBackPressed: ()=>context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const DLoader();
            } else {
              return ListView(
                children: [
                  const DoctorDetailsAccountHeader(),
                  const Sizer(),
                   DoctorDetailsCard(type:widget.params?.type??''),
                  const DoctorDetailsAppointmentsCard(),
                  DoctorDetailsReviewsWidget(
                    doctorId: widget.params?.doctorId ?? '',
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
