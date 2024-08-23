import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/register/driver_register/presentation/widgets/upload_image.dart';

class UploadNationalID extends StatelessWidget {
  final int length, index;
  final String label;
  const UploadNationalID(
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
            children: [
              LinearProgressIndicator(
                value: index / length,
                minHeight: 5,
                borderRadius: BorderRadius.circular(10),
              ),
              UploadImageWidget(
                  icon: FontAwesomeIcons.idCard,
                  action: () {},
                  label: 'Upload National ID (Front Image)'),
              UploadImageWidget(
                  icon: FontAwesomeIcons.idCardClip,
                  action: () {},
                  label: 'Upload National ID (Back Image)'),
            ],
          ),
        ),
      ),
    );
  }
}
