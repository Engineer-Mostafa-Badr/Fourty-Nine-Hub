import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_uploader_widget.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_id_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class EditDoctorDocsView extends StatelessWidget {
  final Function(DoctorDocsParams doctorDocsParams) onSubmit;
  EditDoctorDocsView({
    super.key,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(text: Labels.uploadPhotos, style: Styles.headerText()),
          Sizer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ImageUploaderWidget(
                subCategoryId: '1',
                tilte: Labels.front,
                onUploaded: (data) {
                  _frontId = data.mediaId;
                },
              ),
              ImageUploaderWidget(
                tilte: Labels.back,
                subCategoryId: '5',
                onUploaded: (data) {
                  _backId = data.mediaId;
                },
              ),
            ],
          ),
          Sizer(
            height: 20.h,
          ),
          Label(text: Labels.expireDate, style: Styles.headerText()),
          Sizer(),
          DatePickerField(
            title: Labels.expireDate,
            initialDate: now,
            minDate: now,
            maxDate: DateTime(now.year + 5, now.month, now.day),
            onDateSelected: (date) {
              _expireDate = date;
            },
          ),
          Sizer(
            height: 50.h,
          ),
          AppButton(
            height: 50.h,
            label: Labels.update,
            onPressed: () {
              if (_frontId.isEmpty || _backId.isEmpty) {
                showSuccessDialog(context, Labels.uploadPhotos);
              } else if (_expireDate != null) {
                showSuccessDialog(context, Labels.expireDate);
              } else {
                onSubmit(DoctorDocsParams(
                    backImageId: _backId,
                    frontImageId: _frontId,
                    expireDate: _expireDate!));
              }
            },
          )
        ],
      ),
    );
  }

  String _frontId = '';
  String _backId = '';
  DateTime? _expireDate;
  final now = DateTime.now();
}
