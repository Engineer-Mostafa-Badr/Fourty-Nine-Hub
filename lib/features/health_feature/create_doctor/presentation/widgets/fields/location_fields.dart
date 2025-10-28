import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/custom_text_field_health.dart';

class CreateDoctorLocationFields extends StatelessWidget {
  const CreateDoctorLocationFields({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorLoginCubit = context.read<CreateDoctorCubit>();
    return Row(
      children: [
        Expanded(
          child: CustomTextFieldHealth(
            hintText:
                context.isArabic ? 'خط العرض (اختياري)' : 'Latitude (Optional)',
            controller: TextEditingController(
              text: doctorLoginCubit.address.latitude?.toString() ?? '',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              final lat = double.tryParse(value);
              doctorLoginCubit.address.latitude = lat;
              debugPrint('Latitude: $lat');
            },
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final lat = double.tryParse(value);
                if (lat == null || lat < -90 || lat > 90) {
                  return context.isArabic
                      ? 'خط العرض يجب أن يكون بين -90 و 90'
                      : 'Latitude must be between -90 and 90';
                }
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomTextFieldHealth(
            hintText: context.isArabic
                ? 'خط الطول (اختياري)'
                : 'Longitude (Optional)',
            controller: TextEditingController(
              text: doctorLoginCubit.address.longitude?.toString() ?? '',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              final lng = double.tryParse(value);
              doctorLoginCubit.address.longitude = lng;
              debugPrint('Longitude: $lng');
            },
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final lng = double.tryParse(value);
                if (lng == null || lng < -180 || lng > 180) {
                  return context.isArabic
                      ? 'خط الطول يجب أن يكون بين -180 و 180'
                      : 'Longitude must be between -180 and 180';
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
