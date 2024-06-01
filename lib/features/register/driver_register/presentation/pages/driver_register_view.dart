import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/default_button.dart';
import 'package:fourtyninehub/features/register/driver_register/presentation/pages/taps/enter_car_info.dart';
import 'package:fourtyninehub/features/register/driver_register/presentation/pages/taps/thank_you.dart';
import 'package:fourtyninehub/features/register/driver_register/presentation/pages/taps/upload_car_license_images.dart';
import 'package:fourtyninehub/features/register/driver_register/presentation/pages/taps/upload_national_id.dart';

class DriverRegister extends StatelessWidget {
  const DriverRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // TODO prevent from pop up show error state
        return (await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to close register'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Yes'),
                  ),
                ],
              ),
            )) ??
            false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView(
                children: [
                  EnterCarInfo(
                    length: 4,
                    index: 1,
                    label: 'Enter Car Info',
                  ),
                  const UploadCarLicenseImages(
                    length: 4,
                    index: 2,
                    label: 'Upload License Images',
                  ),
                  const UploadNationalID(
                    length: 4,
                    index: 3,
                    label: 'Upload National ID',
                  ),
                  const ThankYou(
                      label: 'Finished',
                      title: 'Thank you for your registeration!',
                      subTitle: 'We will contact you once your form is accepted!'),
                ],
              ),
            ),
            DefaultButton(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              onPressed: () {},
              label: 'Next',
            ),
          ],
        ),
      ),
    );
  }
}
