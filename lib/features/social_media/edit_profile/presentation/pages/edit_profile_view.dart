import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/domain/entities/edit_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/presentation/widgets/privact_icon.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
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
                          '(${state.selectedBioPrivacy})',
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
                          '(${state.selectedPhonePrivacy})',
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
                          '(${state.selectedJobPrivacy})',
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
                          '(${state.selectedCountryPrivacy})',
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
                          '(${state.selectedCityPrivacy})',
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
