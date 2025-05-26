import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/enums/support_status_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_support_details_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_widget/custom_support_text_form_field.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class SupportRideParams {
  final String tripId;
  final String tripType;
  final String userType;
  final String driverId;
  final String clientId;

  SupportRideParams({required this.tripId, required this.driverId, required this.clientId, required this.tripType, required this.userType});
}

class SupportRideScreen extends StatefulWidget {
  const SupportRideScreen({super.key, required this.params});
  final SupportRideParams params;
  @override
  State<SupportRideScreen> createState() => _SupportRideScreenState();
}

class _SupportRideScreenState extends State<SupportRideScreen> {
  final TextEditingController problemController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  @override
  initState() {
    context.read<DashboardsCubit>().getEmergencyDetails(context, widget.params);
    super.initState();
  }

  bool is_sent_request = false;
  var form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.support.localize),
        leadingWidth: 50.w,
      ),
      body: BlocBuilder<DashboardsCubit, DashboardsState>(builder: (context, state) {
        var cubit = context.read<DashboardsCubit>();
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if(state.supportStatus == RequestEmergencyStatus.approved.status){
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    LocaleKeys.clientDetails.localize,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLabel(LocaleKeys.clientName.localize),
                CustomSupportTextField(enabled: false,validator: (String? value) {  },hintText: LocaleKeys.enterYourName.localize, controller: TextEditingController(text: state.supportDetails?.name??'')),
                const SizedBox(height: 16),
                _buildLabel(LocaleKeys.clientPhone.localize),
                CustomSupportTextField(enabled: false,validator: (String? value) {  },hintText: LocaleKeys.enterYourPhoneNumber.localize, controller: TextEditingController(text: state.supportDetails?.phone??'')),
                const SizedBox(height: 16),
                _buildLabel(LocaleKeys.email.localize),
                CustomSupportTextField(enabled: false,validator: (String? value) {  },hintText: LocaleKeys.enterYourEmail.localize, controller: TextEditingController(text: state.supportDetails?.email??'')),
                const SizedBox(height: 16),
                _buildLabel(LocaleKeys.deviceID.localize),
                CustomSupportTextField(enabled: false,validator: (String? value) {  },hintText: LocaleKeys.enterYourDeviceID.localize, controller: TextEditingController(text: state.supportDetails?.deviceId??'')),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    // context.push(Routes.emergencyContactsScreen);
                  },
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: Text(LocaleKeys.locationLog.localize),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.all(20.h),
          child: Form(
            key: form,
            child: Column(
              children: [
                CustomSupportTextField(
                  hintText: LocaleKeys.writeYourProblem.localize,
                  enabled: state.supportStatus == RequestEmergencyStatus.noRequest.status,
                  controller: cubit.supportDescriptionController, validator: (String? value) {
                    if (value!.isEmpty) {
                      return context.isArabic? 'الرجاء ادخال المشكلة' : 'Please enter your problem';
                    }
                    return null;
                },
                ),
                SizedBox(height: 16.h),
                CustomSupportTextField(
                  hintText: LocaleKeys.writeYourPhoneNumber.localize,
                  enabled: state.supportStatus == RequestEmergencyStatus.noRequest.status,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: cubit.supportPhoneController, validator: (String? value) {
                    if (value!.isEmpty) {
                      return context.isArabic? 'الرجاء ادخال رقم الهاتف' : 'Please enter your phone number';
                    }
                    return null;
                },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: state.isLoadingSubmitRequest? const Center(child: CircularProgressIndicator()): ElevatedButton(
                    onPressed: () {
                      if(state.supportStatus == RequestEmergencyStatus.noRequest.status){
                        if(form.currentState!.validate()){
                          cubit.requestEmergencySupport(context: context, clientId: widget.params.clientId, driverId: widget.params.driverId, tripId: widget.params.tripId);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.supportStatus == RequestEmergencyStatus.pending.status ? AppColors.PRIMARY_COLOR.withOpacity(.7) : AppColors.PRIMARY_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      state.supportStatus == RequestEmergencyStatus.pending.status ? LocaleKeys.requestSent.localize : LocaleKeys.requestEmergencySupport.localize,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                if (state.supportStatus == RequestEmergencyStatus.pending.status)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          LocaleKeys.waitingApproval.localize,
                          style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
