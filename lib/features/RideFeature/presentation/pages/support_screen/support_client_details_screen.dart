import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_widget/custom_support_text_form_field.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class SupportClientDetailsScreen extends StatelessWidget {
  SupportClientDetailsScreen({super.key});

  final TextEditingController nameController = TextEditingController(text: "Ahmed mohammed");
  final TextEditingController phoneController = TextEditingController(text: "01578731541");
  final TextEditingController emailController = TextEditingController(text: "Ahmedmohammed@gmail.com");
  final TextEditingController deviceIdController = TextEditingController(text: "145.545.725.75");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.support.localize),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  LocaleKeys.clientDetails.localize,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              _buildLabel(LocaleKeys.clientName.localize),
              CustomSupportTextField(validator: (String? value) {  },hintText: LocaleKeys.enterYourName.localize, controller: nameController),
              SizedBox(height: 16),
              _buildLabel(LocaleKeys.clientPhone.localize),
              CustomSupportTextField(validator: (String? value) {  },hintText: LocaleKeys.enterYourPhoneNumber.localize, controller: phoneController),
              SizedBox(height: 16),
              _buildLabel(LocaleKeys.email.localize),
              CustomSupportTextField(validator: (String? value) {  },hintText: LocaleKeys.enterYourEmail.localize, controller: emailController),
              SizedBox(height: 16),
              _buildLabel(LocaleKeys.deviceID.localize),
              CustomSupportTextField(validator: (String? value) {  },hintText: LocaleKeys.enterYourDeviceID.localize, controller: deviceIdController),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
      ManageVibration.vibrate();
                  context.push(Routes.emergencyContactsScreen);
                },
                icon: Icon(Icons.download, color: Colors.white),
                label: Text(LocaleKeys.locationLog.localize),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.PRIMARY_COLOR,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}