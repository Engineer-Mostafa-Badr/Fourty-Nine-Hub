import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_personal_info/edit_doctor_personal_info_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/personal_info/edit_doctor_address.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/personal_info/edit_doctor_name_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/personal_info/edit_doctor_phone_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/personal_info/edit_doctor_speciality_filed.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditDoctorPersonalInfoView extends StatefulWidget {
  const EditDoctorPersonalInfoView({super.key, required this.doctor});
  final DoctorEntity doctor;
  @override
  State<EditDoctorPersonalInfoView> createState() => _EditDoctorPersonalInfoViewState();
}

class _EditDoctorPersonalInfoViewState extends State<EditDoctorPersonalInfoView> {

  @override
  void initState() {

    context.read<EditDoctorPersonalInfoCubit>().init(widget.doctor);
    // Future.delayed(Duration(milliseconds: 500),() async {
    //   await context.read<EditDoctorPersonalInfoCubit>().onSelectInitialGovernorate(widget.d.address.governorateId);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.edit.localize,
      ),
      body: BlocBuilder<EditDoctorPersonalInfoCubit,EditDoctorPersonalInfoState>(
        builder: (context,state) {
          print("widget.doctor.address.governorateId${widget.doctor.address.governorateId}");
          return state.isLoading?const Center(child: CircularProgressIndicator(),):ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const EditDoctorSpecialityField(),
              Sizer(
                height: 30.h,
              ),
              const EditDoctorNameField(),
              Sizer(
                height: 30.h,
              ),
              const EditDoctorPhoneField(

              ),
              Sizer(
                height: 30.h,
              ),
              const EditDoctorAddressField(),
              Sizer(
                height: 60.h,
              ),
              AppButton(
                label: LocaleKeys.update.localize,
                // height: 50.h,
                onPressed: () {
                  context.read<EditDoctorPersonalInfoCubit>().updateDoctorPersonalInfo(context);
                },
              )
            ],
          );
        }
      ),
    );
  }
}
