import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_widget/custom_support_text_form_field.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class SupportRideScreen extends StatefulWidget {
  @override
  State<SupportRideScreen> createState() => _SupportRideScreenState();
}

class _SupportRideScreenState extends State<SupportRideScreen> {
  final TextEditingController problemController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  bool is_sent_request = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.support.localize),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomSupportTextField(hintText: LocaleKeys.writeYourProblem.localize, controller: problemController),
            const SizedBox(height: 16),
            CustomSupportTextField(hintText: LocaleKeys.writeYourPhoneNumber.localize, controller: phoneController),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  is_sent_request = !is_sent_request;
                  setState(() {

                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:is_sent_request?AppColors.PRIMARY_COLOR.withOpacity(.7): AppColors.PRIMARY_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  is_sent_request?LocaleKeys.requestSent.localize: LocaleKeys.requestEmergencySupport.localize,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 6,),
            if(is_sent_request)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Text(LocaleKeys.waitingApproval.localize,  style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),),
              ],),
            ),

            const SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
              context.push( Routes.supportClientDetailsScreen);
              },
              child: const Text("go to client screen",style: TextStyle(
                color: Colors.red,
              ),),
            )

          ],
        ),
      ),
    );
  }
}
