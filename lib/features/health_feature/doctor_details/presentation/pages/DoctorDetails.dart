import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/address.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/appointments.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/divider.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/earn.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/fees_card.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/header.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/reviews.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/waiting.dart';
import '../../../../../res/strings/labels.dart';

class DoctorDetails extends StatefulWidget {
  final DoctorEntity doctor;
  const DoctorDetails({super.key, required this.doctor});

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  @override
  void initState() {
    context.read<DoctorDetailsCubit>().doctor = widget.doctor;
    context.read<DoctorDetailsCubit>().loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Labels.details),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: const [
            DoctorDetailsAccountHeader(),
            DoctorDetailsDivider(),
            DoctorDetailsFeesCard(),
            DoctorDetailsDivider(),
            DoctorDetailsWaitingTimeCard(),
            DoctorDetailsDivider(),
            DoctorDetailsAddressCard(),
            DoctorDetailsDivider(),
            DoctorDetailsAppointmentsCard(),
            DoctorDetailsDivider(),
            DoctoDetailsEarnCard(),
            DoctorDetailsDivider(),
            DoctorDetailsReviewsWidget(),
          ],
        ),
      ),
    );
  }
}
