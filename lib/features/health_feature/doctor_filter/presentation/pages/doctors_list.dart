import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/doctors_list_cubit/doctors_list_cubit.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../widgets/doctor_card.dart';

class DoctorsListParams{
  final bool fromHome;
  final String subCategoryId;

  DoctorsListParams({required this.fromHome, required this.subCategoryId});
}
class DoctorsListView extends StatefulWidget {
  const DoctorsListView({super.key,required this.params});
  final DoctorsListParams params;
  @override
  State<DoctorsListView> createState() => _DoctorsListViewState();
}

class _DoctorsListViewState extends State<DoctorsListView> {
  @override
  void initState() {
    widget.params.fromHome==true?context.read<DoctorsListCubit>().loadDataFromSubCategory(widget.params.subCategoryId):context.read<DoctorsListCubit>().loadData(widget.params.fromHome);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorsListCubit, DoctorsListState>(
      listener: (context, state) {
        if (state is DoctorsListError) {
          showErrorMessage(context, state.message);
        }
      },
      child: Scaffold(
        appBar: BackAppBar(
          label: LocaleKeys.doctorList.localize,
        ),
        body: BlocBuilder<DoctorsListCubit, DoctorsListState>(
            builder: (context, state) {
          switch (state) {
            case DoctorsListLoaded _:
              if (state.doctors.isNotEmpty) {
                return ListView.separated(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10.h),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => DoctorCard(
                          doctor: state.doctors[index],
                        ),
                    separatorBuilder: (context, index) => const Sizer(),
                    itemCount: state.doctors.length);
              } else {
                return Center(child: Text(LocaleKeys.noDoctorsFound.localize));
              }

            default:
              return const Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }
}
