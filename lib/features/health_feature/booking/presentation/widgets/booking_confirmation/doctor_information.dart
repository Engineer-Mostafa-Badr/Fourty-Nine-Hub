import 'package:flutter/cupertino.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:intl/intl.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../doctor_details/presentation/widgets/doctor_image.dart';


class DoctorInfo extends StatelessWidget {
  final DoctorEntity doctor;
  const DoctorInfo({super.key, required this.doctor});
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DoctorImage(
          imageUrl: doctor.image ?? '',
          rating: doctor.rating,
        ),
        Label(
          text:
          '${toBeginningOfSentenceCase(doctor.firstName ?? '')} '
              '${toBeginningOfSentenceCase(doctor.lastName ?? '')}',
          style: Styles.headerText(fontWeight: FontWeight.w600),
        ),
        Label(
          text: context.isArabic
              ? doctor.subCategory.nameAr ?? ''
              : doctor.subCategory.nameEn ?? '',
          maxLines: 1,
          style: Styles.mediumText(fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
