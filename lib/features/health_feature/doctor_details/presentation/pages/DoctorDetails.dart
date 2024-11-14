import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/address.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/appointments.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/fees_card.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/header.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/reviews.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/waiting.dart';
import '../../../../../res/strings/labels.dart';

class DoctorDetailsParams{
  final String doctorId;
  final bool fromSearch;
  DoctorDetailsParams({required this.doctorId,required this.fromSearch});
}

class DoctorDetailsView extends StatefulWidget {
  final DoctorDetailsParams params;
  const DoctorDetailsView({super.key, required this.params});

  @override
  State<DoctorDetailsView> createState() => _DoctorDetailsViewState();
}

class _DoctorDetailsViewState extends State<DoctorDetailsView> {
  @override
  void initState() {
    context.read<DoctorDetailsCubit>().loadData(widget.params);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: Labels.details,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
          buildWhen: (previous, current) =>
              current is DoctorDetailsLoaded || current is DoctorDetailsInitial,
          builder: (context, state) {
            if (state is DoctorDetailsLoaded) {
              return ListView(
                children: const [
                  DoctorDetailsAccountHeader(),
                  DoctorDetailsFeesCard(),
                  DoctorDetailsWaitingTimeCard(),
                  DoctorDetailsAddressCard(),
                  DoctorDetailsAppointmentsCard(),
                  DoctorDetailsReviewsWidget(),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
