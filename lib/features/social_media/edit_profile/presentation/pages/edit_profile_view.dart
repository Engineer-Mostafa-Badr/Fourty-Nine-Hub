import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/custom_sheet/custom_vertical_sheet_item.dart';
import 'package:fourtyninehub/common/widgets/stateless/custom_sheet/sheet_vertical_item.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/entities/privacy_status_enum.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/domain/entities/edit_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/presentation/widgets/privact_icon.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/src/components/screen_util/core/size_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({
    super.key,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final cityTextController = TextEditingController();
  final countryTextController = TextEditingController();
  final jobTextController = TextEditingController();
  final referrerTextController = TextEditingController();
  final bioTextController = TextEditingController();
  final statusController = TextEditingController();

  @override
  void initState() {
    firstNameTextController.text =
        context.read<UserCubit>().state.data?.firstName ?? '';
    lastNameTextController.text =
        context.read<UserCubit>().state.data?.lastName ?? '';
    phoneTextController.text =
        context.read<UserCubit>().state.data?.phone ?? '';
    cityTextController.text = context.read<UserCubit>().state.data?.city ?? '';
    countryTextController.text =
        context.read<UserCubit>().state.data?.country ?? '';
    jobTextController.text = context.read<UserCubit>().state.data?.job ?? '';
    bioTextController.text = context.read<UserCubit>().state.data?.bio ?? '';
    context
        .read<EditProfileCubit>()
        .initGender(context.read<UserCubit>().state.data?.gender ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<EditProfileCubit>();
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state.status == EditProfileStates.success) {
          showSuccessMessage(context, "Edit Profile Data Successfully");
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: const BackAppBar(
                label: 'Edit Profile',
              ),
              body: ListView(
                padding: EdgeInsets.all(15.zW),
                shrinkWrap: true,
                children: [
                  Text(
                    'First Name',
                    style: Styles.headerText(fontSize: 30),
                  ),
                  const Sizer(),
                  FormTextField(
                      hint: 'First Name....',
                      action: (v) {
                        setState(() {});
                      },
                      prefix: const Icon(Icons.edit),
                      controller: firstNameTextController),
                  const Sizer(),
                  Text(
                    'Last Name',
                    style: Styles.headerText(fontSize: 30),
                  ),
                  const Sizer(),
                  FormTextField(
                      hint: 'Last Name ....',
                      action: (v) {
                        setState(() {});
                      },
                      prefix: const Icon(Icons.edit),
                      controller: lastNameTextController),
                  const Sizer(),
                  Row(
                    children: [
                      Text(
                        'Bio',
                        style: Styles.headerText(fontSize: 30),
                      ),
                      const Sizer(),
                      if (state.selectedBioPrivacy != null)
                        Text(
                          '(${state.selectedBioPrivacy=='public'?'Public':state.selectedBioPrivacy=='friends'?'Friends':state.selectedBioPrivacy=='followers'?'Followers':state.selectedBioPrivacy=='friendsAndFollowers'?'Friends / Followers':state.selectedBioPrivacy=='onlyMe'?'Only Me':''})',
                          style: Styles.headerText(fontSize: 22),
                        ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Expanded(
                        child: FormTextField(
                            hint: 'Bio ....',
                            height: 80,
                            maxLength: 100,
                            action: (v) {
                              setState(() {});
                            },
                            prefix: const Icon(Icons.edit),
                            controller: bioTextController),
                      ),
                      PrivacyIcon(
                        selectPrivacy: (name) {
                          controller.selectBioPrivacy(privacy: name);
                        },
                      ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Text(
                        'Phone Number',
                        style: Styles.headerText(fontSize: 30),
                      ),
                      const Sizer(),
                      if (state.selectedPhonePrivacy != null)
                        Text(
                          '(${state.selectedPhonePrivacy=='public'?'Public':state.selectedPhonePrivacy=='friends'?'Friends':state.selectedPhonePrivacy=='followers'?'Followers':state.selectedPhonePrivacy=='friendsAndFollowers'?'Friends / Followers':state.selectedPhonePrivacy=='onlyMe'?'Only Me':''})',
                          style: Styles.headerText(fontSize: 22),
                        ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Expanded(
                        child: FormTextField(
                            hint: 'Phone ....',
                            action: (v) {
                              setState(() {});
                            },
                            prefix: const Icon(Icons.phone),
                            controller: phoneTextController),
                      ),
                      PrivacyIcon(selectPrivacy: (name) {
                        controller.selectPhonePrivacy(privacy: name);
                      })
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Text(
                        'Job',
                        style: Styles.headerText(fontSize: 30),
                      ),
                      const Sizer(),
                      if (state.selectedJobPrivacy != null)
                        Text(
                          '(${state.selectedJobPrivacy=='public'?'Public':state.selectedJobPrivacy=='friends'?'Friends':state.selectedJobPrivacy=='followers'?'Followers':state.selectedJobPrivacy=='friendsAndFollowers'?'Friends / Followers':state.selectedJobPrivacy=='onlyMe'?'Only Me':''})',
                          style: Styles.headerText(fontSize: 22),
                        ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Expanded(
                        child: FormTextField(
                            hint: 'Job ....',
                            action: (v) {
                              setState(() {});
                            },
                            prefix: const Icon(Icons.work),
                            controller: jobTextController),
                      ),
                      PrivacyIcon(selectPrivacy: (name) {
                        controller.selectJobPrivacy(privacy: name);
                      })
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Text(
                        'Country',
                        style: Styles.headerText(fontSize: 30),
                      ),
                      const Sizer(),
                      if (state.selectedCountryPrivacy != null)
                        Text(
                          '(${state.selectedCountryPrivacy=='public'?'Public':state.selectedCountryPrivacy=='friends'?'Friends':state.selectedCountryPrivacy=='followers'?'Followers':state.selectedCountryPrivacy=='friendsAndFollowers'?'Friends / Followers':state.selectedCountryPrivacy=='onlyMe'?'Only Me':''})',
                          style: Styles.headerText(fontSize: 22),
                        ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Expanded(
                        child: FormTextField(
                            hint: 'Country ....',
                            action: (v) {
                              setState(() {});
                            },
                            prefix: const Icon(Icons.language),
                            controller: countryTextController),
                      ),
                      PrivacyIcon(selectPrivacy: (name) {
                        controller.selectCountryPrivacy(privacy: name);
                      })
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Text(
                        'City',
                        style: Styles.headerText(fontSize: 30),
                      ),
                      const Sizer(),
                      if (state.selectedCityPrivacy != null)
                        Text(
                          '(${state.selectedCityPrivacy=='public'?'Public':state.selectedCityPrivacy=='friends'?'Friends':state.selectedCityPrivacy=='followers'?'Followers':state.selectedCityPrivacy=='friendsAndFollowers'?'Friends / Followers':state.selectedCityPrivacy=='onlyMe'?'Only Me':''})',
                          style: Styles.headerText(fontSize: 22),
                        ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Expanded(
                        child: FormTextField(
                            hint: 'City ....',
                            action: (v) {
                              setState(() {});
                            },
                            prefix: const Icon(Icons.location_on),
                            controller: cityTextController),
                      ),
                      PrivacyIcon(
                        selectPrivacy: (name) {
                          controller.selectCityPrivacy(privacy: name);
                        },
                      ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Text(
                        'Marital Status',
                        style: Styles.headerText(fontSize: 30),
                      ),
                      if (state.selectedStatusPrivacy != null)
                        ...[
                          const Sizer(),
                          Text(
                          '(${state.selectedStatusPrivacy=='public'?'Public':state.selectedStatusPrivacy=='friends'?'Friends':state.selectedStatusPrivacy=='followers'?'Followers':state.selectedStatusPrivacy=='friendsAndFollowers'?'Friends / Followers':state.selectedStatusPrivacy=='onlyMe'?'Only Me':''})',
                          style: Styles.headerText(fontSize: 22),
                        )],
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: ()async{
                            final res =
                            await CustomVerticalSheetItem.normal<MaritalStatus>(context, [
                              CustomSheetModel(
                                text: "Single",
                                value: MaritalStatus.single,
                                iconData: Icons.language,
                              ),
                              CustomSheetModel(
                                text: "Married",
                                value: MaritalStatus.married,
                                iconData: Icons.family_restroom,
                              ),
                              CustomSheetModel(
                                text: "Divorced",
                                value: MaritalStatus.divorced,
                                iconData: Icons.accessibility_sharp,
                              ),
                              CustomSheetModel(
                                text: "Widowed",
                                value: MaritalStatus.widowed,
                                iconData: Icons.supervised_user_circle_outlined,
                              ),
                            ]);
                            print(res?.name);
                            print("============>");
                            statusController.text=res?.name=='single'?'Single':res?.name=='married'?'Married':res?.name=='divorced'?'Divorced':res?.name=='widowed'?'Widowed':'';
                            controller.selectMaritalStatus(status:res?.name ?? 'single');
                          },
                          child: FormTextField(
                              hint: 'Marital Status....',
                            controller: statusController,
                            onTap: ()async{

                            },
                            enabled: false,
                              prefix: const Icon(Icons.family_restroom),
                              suffix: const Icon(Icons.keyboard_arrow_down_outlined),
                          ),
                        ),
                      ),
                      PrivacyIcon(selectPrivacy: (name) {
                        controller.selectStatusPrivacy(privacy: name);
                      })
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          setState(() {
                            state.isMale = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.zR),
                          decoration: BoxDecoration(
                              color: state.isMale == true
                                  ? AppColors.PRIMARY_COLOR
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15.zR),
                              border:
                                  Border.all(color: AppColors.PRIMARY_COLOR)),
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            'Male',
                            style: Styles.mediumText(
                                color: state.isMale == false
                                    ? AppColors.PRIMARY_COLOR
                                    : Colors.white),
                          ),
                        ),
                      )),
                      const Sizer(),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              state.isMale = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.zR),
                            decoration: BoxDecoration(
                                color: state.isMale == false
                                    ? AppColors.PRIMARY_COLOR
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15.zR),
                                border:
                                    Border.all(color: AppColors.PRIMARY_COLOR)),
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              'Female',
                              style: Styles.mediumText(
                                  color: state.isMale == true
                                      ? AppColors.PRIMARY_COLOR
                                      : Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Sizer(),
                  state.status == EditProfileStates.loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : InkWell(
                          onTap: () async {
                            await controller.editProfile(
                              EditProfileEntity(
                                  state.selectedBioPrivacy ?? 'public',
                                  state.selectedPhonePrivacy ?? 'public',
                                  state.selectedJobPrivacy ?? 'public',
                                  state.selectedCountryPrivacy ?? 'public',
                                  state.selectedCityPrivacy ?? 'public',
                                  firstName: firstNameTextController.text,
                                  lastName: lastNameTextController.text,
                                  bio: bioTextController.text,
                                  phone: phoneTextController.text,
                                  job: jobTextController.text,
                                  country: countryTextController.text,
                                  city: cityTextController.text,
                                  maritalPrivacy: state.selectedStatusPrivacy??'public',
                                  maritalStatus: state.selectedStatus??'single',
                                  isMale: state.isMale),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.zW, vertical: 20.zH),
                            decoration: BoxDecoration(
                                color: AppColors.PRIMARY_COLOR,
                                borderRadius: BorderRadius.circular(15.zR),
                                border:
                                    Border.all(color: AppColors.PRIMARY_COLOR)),
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              'Edit',
                              style: Styles.mediumText(color: Colors.white),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
