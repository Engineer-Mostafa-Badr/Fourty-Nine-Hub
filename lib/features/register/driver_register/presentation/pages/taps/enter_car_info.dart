import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/register/driver_register/presentation/widgets/upload_image.dart';

import '../../../../../../common/widgets/form/text_fields/default_text_form_field.dart';
import '../../../../../../common/widgets/stateless/appbar/back_appbar.dart';

class EnterCarInfo extends StatelessWidget {
  final int length, index;
  final String label;
  final controller = TextEditingController();
  final focusNode = FocusNode();
  EnterCarInfo(
      {super.key,
      required this.length,
      required this.index,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: label,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: index / length,
                minHeight: 5,
                borderRadius: BorderRadius.circular(10),
              ),
              const Sizer(),
              FormTextField(
                action: (String v) {},
                // prefix: ,
                label: 'Name',
                prefix: const Icon(Icons.person),
                info: 'This name will appear to clients',
              ),
              const Sizer(),
              FormTextField(
                action: (String v) {},
                // prefix: ,
                label: 'Phone Number',
                prefix: const Icon(Icons.phone_android_rounded),
              ),
              const Sizer(),
              _buildCategoriesWidget(),
              const Sizer(),
              Row(
                children: [
                  const Expanded(child: Label(text: 'Car Module')),
                  const Sizer(),
                  Expanded(
                      child: FormTextField(
                    action: (v) {},
                    label: 'Mark',
                  )),
                  const Sizer(),
                  Expanded(
                      child: FormTextField(
                    action: (v) {},
                    label: 'Type',
                  )),
                ],
              ),
              const Sizer(),
              Row(
                children: [
                  const Expanded(child: Label(text: 'Metal Plate')),
                  const Sizer(),
                  Expanded(
                      child: FormTextField(
                    action: (v) {},
                    label: 'Chars',
                    type: TextInputType.text,
                  )),
                  const Sizer(),
                  Expanded(
                      child: FormTextField(
                    action: (v) {},
                    label: 'Numbers',
                    type: TextInputType.number,
                  )),
                ],
              ),
              const Sizer(),
              Row(
                children: [
                  const Expanded(child: Label(text: 'KM Price')),
                  Expanded(
                      flex: 2,
                      child: FormTextField(
                          hint: 'xx', label: 'Price', action: (v) {}))
                ],
              ),
              Row(
                children: [
                  const Expanded(child: Label(text: 'Air Conditioner')),
                  Switch(value: false, onChanged: (v) {})
                ],
              ),
              const Label(text: 'Car Images'),
              Row(
                children: [
                  Expanded(
                      child: UploadImageWidget(action: () {}, label: 'Front')),
                  // const Sizer(),
                  Expanded(
                      child: UploadImageWidget(action: () {}, label: 'Back')),
                  // const Sizer(),
                  Expanded(
                      child: UploadImageWidget(action: () {}, label: 'Right')),
                  // const Sizer(),
                  Expanded(
                      child: UploadImageWidget(action: () {}, label: 'Left')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesWidget() {
    return GridView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 4),
        itemBuilder: (context, index) {
          return Row(
            children: [
              Checkbox(value: false, onChanged: (v) {}),
              const Expanded(child: Label(text: 'Captain')),
            ],
          );
        });
  }
}
