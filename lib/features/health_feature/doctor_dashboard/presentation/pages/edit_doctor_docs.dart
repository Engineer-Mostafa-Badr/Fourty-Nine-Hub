import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_uploader_widget.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_id_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class EditDoctorDocsView extends StatefulWidget {
  final Function(DoctorDocsParams doctorDocsParams) onSubmit;
  final String subCategoryId;
  final String from;
  final String? frontTitle;
  final String? backTitle;
  const EditDoctorDocsView({
    super.key,
    required this.onSubmit, required this.subCategoryId, required this.from, this.frontTitle, this.backTitle,
  });

  @override
  State<EditDoctorDocsView> createState() => _EditDoctorDocsViewState();
}

class _EditDoctorDocsViewState extends State<EditDoctorDocsView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(text: LocaleKeys.uploadPhotos.localize, style: Styles.headerText()),
          const Sizer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ImageUploaderWidget(
                subCategoryId: widget.subCategoryId,
                tilte: LocaleKeys.front.localize,
                onUploaded: (data) {
                  _frontId = data.mediaId;
                },
              ),
              ImageUploaderWidget(
                tilte: LocaleKeys.back.localize,
                subCategoryId: widget.subCategoryId,
                onUploaded: (data) {
                  _backId = data.mediaId;
                },
              ),
            ],
          ),
          Sizer(
            height: 20.h,
          ),
          Label(text: LocaleKeys.expireDate.localize, style: Styles.headerText()),
          const Sizer(),
          DatePickerField(
            title: LocaleKeys.expireDate.localize,
            initialDate: now,
            minDate: now,
            maxDate: DateTime(now.year + 5, now.month, now.day),
            onDateSelected: (date) {
             setState(() {
               _expireDate = date;
             });
            },
          ),
          Sizer(
            height: 50.h,
          ),
          AppButton(
            height: 50.h,
            label: LocaleKeys.update.localize,
            onPressed: () {
              print(_frontId);
              print(_backId);
              print(_expireDate);
              print(_expireDate != null);
              if (_frontId.isEmpty || _backId.isEmpty) {
                showSuccessDialog(context, Labels.uploadPhotos);
              } else if (_expireDate == null) {
                showSuccessDialog(context, Labels.expireDate);
              } else {
                widget.onSubmit(DoctorDocsParams(
                    backImageId: _backId,
                    frontImageId: _frontId,
                    expireDate: _expireDate!, from: widget.from));
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
