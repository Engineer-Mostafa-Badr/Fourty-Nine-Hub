import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/doctors_list_cubit/doctors_list_cubit.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../widgets/doctor_card.dart';

class DoctorsListView extends StatefulWidget {
  const DoctorsListView({super.key});

  @override
  State<DoctorsListView> createState() => _DoctorsListViewState();
}

class _DoctorsListViewState extends State<DoctorsListView> {
  @override
  void initState() {
    context.read<DoctorsListCubit>().loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      body: _buildDoctorsWidget(),
    );
  }

  Widget _buildDoctorsWidget() {
    return BlocBuilder<DoctorsListCubit, DoctorsListState>(
        builder: (context, state) {
      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => DoctorCard(
                doctor: state.doctors![index],
              ),
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: state.doctors?.length ?? 0);
    });
  }
}
