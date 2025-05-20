import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/emergency_contact_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_widget/custom_support_text_form_field.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  @override
  initState() {
    context.read<DashboardsCubit>().getEmergencyContacts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.emergencyContacts.localize),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<DashboardsCubit, DashboardsState>(builder: (context, state) {
        var cubit = context.read<DashboardsCubit>();
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        log('state.emergencyContacts?.length${state.emergencyContacts?.length}');
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Form(
              key: cubit.firstFormKey,
              child: buildEmergencyContactItem(
                showButtons: (state.emergencyContacts?.length ?? 0) >= 1,
                nameController: cubit.firstNameController,
                phoneController: cubit.firstPhoneController,
                onEdit: () {
                  if (cubit.firstFormKey.currentState!.validate()) {
                    cubit.editEmergencyContacts(context,
                        EmergencyContactEntity(id: state.emergencyContacts?[0].id ?? '', name: cubit.firstNameController.text, phoneNumber: cubit.firstPhoneController.text), 0);
                  }
                },
              ),
            ),
            SizedBox(height: 16.h),
            if ((state.emergencyContacts?.length ?? 0) < 1)
              buildEmergencyContactButton(
                  onTap: () {
                    if(cubit.firstFormKey.currentState!.validate()){
                      cubit.addEmergencyContacts(context: context, name: cubit.firstNameController.text, phoneNumber: cubit.firstPhoneController.text, index: 1);
                    }
                  }),
            SizedBox(height: 16.h),
            Form(
              key: cubit.secondFormKey,
              child: buildEmergencyContactItem(
                showButtons: (state.emergencyContacts?.length ?? 0) >= 2,
                nameController: cubit.secondNameController,
                phoneController: cubit.secondPhoneController,
                onEdit: () {
                  if (cubit.secondFormKey.currentState!.validate()) {
                    cubit.editEmergencyContacts(context,
                        EmergencyContactEntity(id: state.emergencyContacts?[0].id ?? '', name: cubit.secondNameController.text, phoneNumber: cubit.secondPhoneController.text), 1);
                  }
                },
              ),
            ),
            SizedBox(height: 16.h),
            if ((state.emergencyContacts?.length ?? 0) < 2)
              buildEmergencyContactButton(
                  onTap: () {
                    if(cubit.secondFormKey.currentState!.validate()){
                      cubit.addEmergencyContacts(context: context, name: cubit.secondNameController.text, phoneNumber: cubit.secondPhoneController.text, index: 2);
                    }
                  }),
            SizedBox(height: 16.h),
            Form(
                key: cubit.thirdFormKey,
                child: buildEmergencyContactItem(
                  showButtons: (state.emergencyContacts?.length ?? 0) >= 3,
                  nameController: cubit.thirdNameController,
                  phoneController: cubit.thirdPhoneController,
                  onEdit: () {
                    if (cubit.thirdFormKey.currentState!.validate()) {
                      cubit.editEmergencyContacts(context,
                          EmergencyContactEntity(id: state.emergencyContacts?[0].id ?? '', name: cubit.thirdNameController.text, phoneNumber: cubit.thirdPhoneController.text), 2);
                    }
                  },
                )),
            SizedBox(height: 16.h),
            if ((state.emergencyContacts?.length ?? 0) < 3)
              buildEmergencyContactButton(
                  onTap: () {
                    if(cubit.thirdFormKey.currentState!.validate()){
                      cubit.addEmergencyContacts(context: context, name: cubit.thirdNameController.text, phoneNumber: cubit.thirdPhoneController.text, index: 3);
                    }
                  }),
            SizedBox(height: 16.h),
            Form(
                key: cubit.fourthFormKey,
                child: buildEmergencyContactItem(
                  showButtons: (state.emergencyContacts?.length ?? 0) >= 4,
                  nameController: cubit.fourthNameController,
                  phoneController: cubit.fourthPhoneController,
                  onEdit: () {
                    if (cubit.fourthFormKey.currentState!.validate()) {
                      cubit.editEmergencyContacts(
                          context,
                          EmergencyContactEntity(id: state.emergencyContacts?[0].id ?? '', name: cubit.fourthNameController.text, phoneNumber: cubit.fourthPhoneController.text),
                          3);
                    }
                  },
                )),
            SizedBox(height: 16.h),
            if ((state.emergencyContacts?.length ?? 0) < 4)
              buildEmergencyContactButton(
                  onTap: () {
                    if(cubit.fourthFormKey.currentState!.validate()){
                      cubit.addEmergencyContacts(context: context, name: cubit.fourthNameController.text, phoneNumber: cubit.fourthPhoneController.text, index: 4);
                    }
                  }),
            SizedBox(height: 16.h),
            Form(
                key: cubit.fifthFormKey,
                child: buildEmergencyContactItem(
                  showButtons: (state.emergencyContacts?.length ?? 0) >= 5,
                  nameController: cubit.fifthNameController,
                  phoneController: cubit.fifthPhoneController,
                  onEdit: () {
                    if (cubit.fifthFormKey.currentState!.validate()) {
                      cubit.editEmergencyContacts(context,
                          EmergencyContactEntity(id: state.emergencyContacts?[0].id ?? '', name: cubit.fifthNameController.text, phoneNumber: cubit.fifthPhoneController.text), 4);
                    }
                  },
                )),
            SizedBox(height: 16.h),
            if ((state.emergencyContacts?.length ?? 0) < 5)
              buildEmergencyContactButton(
                  onTap: () {
                    if(cubit.fifthFormKey.currentState!.validate()){
                      cubit.addEmergencyContacts(context: context, name: cubit.fifthNameController.text, phoneNumber: cubit.fifthPhoneController.text, index: 5);
                    }
                  }),
          ],
        );
      }),
    );
  }

  Widget buildEmergencyContactItem(
      {required TextEditingController nameController,
      required TextEditingController phoneController,
      required bool showButtons,
      GestureTapCallback? onCall,
      GestureTapCallback? onEdit,
      GestureTapCallback? onDelete}) {
    print(nameController);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 24),
      decoration: BoxDecoration(
        border: Border.all(color: context.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LocaleKeys.name.localize, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    CustomSupportTextField(
                        hintText: LocaleKeys.name.localize,
                        controller: nameController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys.enterYourName.localize;
                          }
                        }),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LocaleKeys.phone.localize, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    CustomSupportTextField(
                        hintText: LocaleKeys.phone.localize,
                        controller: phoneController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys.enterPhoneNumber.localize;
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
          if (showButtons) ...[
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                    child: ClickableWidget(
                  onTap: onCall,
                  child: Container(
                    height: 60.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: AppColors.PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: AlignmentDirectional.center,
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 40.w,
                    ),
                  ),
                )),
                SizedBox(width: 32.w),
                Expanded(
                    child: ClickableWidget(
                  onTap: onEdit,
                  child: Container(
                    width: double.infinity,
                    height: 60.h,
                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: AppColors.PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      LocaleKeys.edit.localize,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                )),
                SizedBox(width: 32.w),
                Expanded(
                    child: ClickableWidget(
                  onTap: onDelete,
                  child: Container(
                    height: 60.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: AppColors.PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: AlignmentDirectional.center,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 40.w,
                    ),
                  ),
                )),
              ],
            )
          ]
        ],
      ),
    );
  }

  Widget buildEmergencyContactButton({GestureTapCallback? onTap}) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: AppColors.PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: AlignmentDirectional.center,
        child: Text(
          LocaleKeys.addEmergencyContacts.localize,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class EmergencyContactItem extends StatelessWidget {
  final TextEditingController nameController = TextEditingController(text: "Ahmed mohammed");
  final TextEditingController phoneController = TextEditingController(text: "01578731541");

  EmergencyContactItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: context.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LocaleKeys.name.localize, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                CustomSupportTextField(hintText: LocaleKeys.name.localize, controller: nameController, validator: (String? value) {}),
              ],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LocaleKeys.phone.localize, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                CustomSupportTextField(hintText: LocaleKeys.phone.localize, controller: phoneController, validator: (String? value) {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
