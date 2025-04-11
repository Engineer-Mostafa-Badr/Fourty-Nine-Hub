import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/address.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/appointments.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/fees_card.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/header.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/reviews.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/waiting.dart';

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
      print("payloadpayloadpayload $payload");
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
        child: BackAppBar(
          label: LocaleKeys.doctorDetails.localize,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView(
                children: [
                  const DoctorDetailsAccountHeader(),
                  const DoctorDetailsFeesCard(),
                  const DoctorDetailsWaitingTimeCard(),
                  const DoctorDetailsAddressCard(),
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
