import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/domain/entities/edit_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/form/text_fields/default_text_form_field.dart';
import '../../../../../common/widgets/stateful/picker/date_picker.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../widgets/gover_dropdown.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({
    super.key,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final userNameTextController = TextEditingController();
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final phoneTextController = TextEditingController();

  final cityTextController = TextEditingController();
  final birthDateTextController = TextEditingController();
  final jobTextController = TextEditingController();
  final referrerTextController = TextEditingController();
  final bioTextController = TextEditingController();
  final statusController = TextEditingController();
  String country = LocaleKeys.country.localize;
  String? gender;

  @override
  void initState() {
    // context.read<EditProfileCubit>().state.copyWith(status: EditProfileStates.initial);
    print(context.read<UserCubit>().state.data);
    // context.read<EditProfileCubit>().fetchRideGovernorates();
    userNameTextController.text =
        "${context.read<UserCubit>().state.data?.username}" ?? '';
    // nameTextController.text =
    //     "${context.read<UserCubit>().state.data?.firstName} ${context.read<UserCubit>().state.data?.lastName}" ??
    //         '';
    firstNameTextController.text =
        context.read<UserCubit>().state.data?.firstName ?? '';
    lastNameTextController.text =
        context.read<UserCubit>().state.data?.lastName ?? '';
    phoneTextController.text =
        context.read<UserCubit>().state.data?.phone ?? '';
    if (context.read<UserCubit>().state.data?.country == null) {
      cityTextController.text = LocaleKeys.country.localize;
    } else if (context.read<UserCubit>().state.data?.country == '') {
      cityTextController.text = LocaleKeys.country.localize;
    } else {
      cityTextController.text = context.read<UserCubit>().state.data!.country!;
    }
    country = cityTextController.text;
    context.read<EditProfileCubit>().state.selectedCountry = country;
    // DateFormat('hh:mm a')
    //     .format(DateTime.parse(
    //     context.read<UserCubit>().state.data!.birthday.toString().substring(0, 19)))
    //     .toString();
    birthDateTextController.text = DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(context
                .read<UserCubit>()
                .state
                .data!
                .birthday
                .toString()
                .substring(0, 19)))
            .toString() ??
        '';
    jobTextController.text = context.read<UserCubit>().state.data?.job ?? '';
    bioTextController.text = context.read<UserCubit>().state.data?.bio ?? '';
    context
        .read<EditProfileCubit>()
        .initGender(context.read<UserCubit>().state.data?.gender ?? '');

    gender = context.read<UserCubit>().state.data?.gender ?? 'male';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<EditProfileCubit>();
    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state.status == EditProfileStates.success) {
          showSuccessMessage(
              context, LocaleKeys.editProfileDataSuccessfully.localize);
        }
      },
      builder: (context, state) {
        return CustomScaffold(
          appBar: BackAppBar(
            label: LocaleKeys.editProfile.localize,
            textColor: context.isDarkMode ? Colors.black : Colors.white,
            iconColor: context.isDarkMode ? Colors.black : Colors.white,
            // enableCustomAppBar: true,
            automaticallyImplyLeading: false,
          ),
          enableCustomAppBar: true,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // padding: const EdgeInsets.all(15),
                // shrinkWrap: true,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.userName.localize,
                    style: Styles.headerText(fontSize: 30),
                  ),
                  const Sizer(),
                  // FormTextField(
                  //     hint: '${LocaleKeys.userName.localize}....',
                  //     action: (v) {
                  //       setState(() {});
                  //     },
                  //     prefix: const Icon(Icons.edit),
                  //     controller: userNameTextController),
                  DefaultTextFormField(
                    fillColor: Colors.transparent,
                    currentController: userNameTextController,
                    hint: LocaleKeys.userName.localize,
                    borderColor: context.isDarkMode
                        ? const Color(0xffCACFF4)
                        : AppColors.PRIMARY_COLOR,
                  ),
                  const Sizer(),
                  Text(
                    LocaleKeys.firstName.localize,
                    style: Styles.headerText(fontSize: 30),
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    fillColor: Colors.transparent,
                    currentController: firstNameTextController,
                    hint: LocaleKeys.name.localize,
                    borderColor: context.isDarkMode
                        ? const Color(0xffCACFF4)
                        : AppColors.PRIMARY_COLOR,
                  ),

                  const Sizer(),
                  Text(
                    LocaleKeys.lastName.localize,
                    style: Styles.headerText(fontSize: 30),
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    fillColor: Colors.transparent,
                    currentController: lastNameTextController,
                    hint: LocaleKeys.name.localize,
                    borderColor: context.isDarkMode
                        ? const Color(0xffCACFF4)
                        : AppColors.PRIMARY_COLOR,
                  ),
                  const Sizer(),
                  Text(
                    LocaleKeys.gender.localize,
                    style: Styles.headerText(fontSize: 30),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          activeColor:
                              context.isDarkMode ? Color(0xffCACFF4) : null,
                          title: Text(context.isArabic ? 'ذكر' : 'Male'),
                          value: 'male',
                          groupValue: gender,
                          onChanged: (String? value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          activeColor:
                              context.isDarkMode ? Color(0xffCACFF4) : null,
                          title: Text(context.isArabic ? 'انثى' : 'Female'),
                          value: 'female',
                          groupValue: gender,
                          onChanged: (String? value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Sizer(),
                  Text(
                    LocaleKeys.bio.localize,
                    style: Styles.headerText(fontSize: 30),
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    fillColor: Colors.transparent,
                    currentController: bioTextController,
                    hint: LocaleKeys.bio.localize,
                    borderColor: context.isDarkMode
                        ? const Color(0xffCACFF4)
                        : AppColors.PRIMARY_COLOR,
                  ),
                  const Sizer(),
                  Text(
                    LocaleKeys.job.localize,
                    style: Styles.headerText(fontSize: 30),
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    fillColor: Colors.transparent,
                    currentController: jobTextController,
                    hint: LocaleKeys.job.localize,
                    borderColor: context.isDarkMode
                        ? const Color(0xffCACFF4)
                        : AppColors.PRIMARY_COLOR,
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Text(
                        LocaleKeys.phoneNumber.localize,
                        style: Styles.headerText(fontSize: 30),
                      ),
                      const Sizer(),
                      if (state.selectedPhonePrivacy != null)
                        Text(
                          '(${state.selectedPhonePrivacy == 'public' ? LocaleKeys.public.localize : state.selectedPhonePrivacy == 'friends' ? LocaleKeys.friends.localize : state.selectedPhonePrivacy == 'followers' ? LocaleKeys.followers.localize : state.selectedPhonePrivacy == 'friendsAndFollowers' ? LocaleKeys.friendsAndFollowers.localize : state.selectedPhonePrivacy == 'onlyMe' ? LocaleKeys.onlyMe.localize : ''})',
                          style: Styles.headerText(fontSize: 22),
                        ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Expanded(
                        child: DefaultTextFormField(
                          fillColor: Colors.transparent,
                          currentController: phoneTextController,
                          hint: LocaleKeys.phone.localize,
                          borderColor: context.isDarkMode
                              ? const Color(0xffCACFF4)
                              : AppColors.PRIMARY_COLOR,
                        ),
                      ),

                      // FormTextField(
                      //     hint: '${LocaleKeys.phone.localize} ....',
                      //     action: (v) {
                      //       setState(() {});
                      //     },
                      //     prefix: const Icon(Icons.phone),
                      //     controller: phoneTextController),
                      // ),
                      // PrivacyIcon(selectPrivacy: (name) {
                      //   controller.selectPhonePrivacy(privacy: name);
                      // })
                    ],
                  ),
                  const Sizer(),
                  Text(
                    LocaleKeys.birthDate.localize,
                    style: Styles.headerText(fontSize: 30),
                  ),
                  const Sizer(),
                  DatePickerField(
                    initialDate: DateTime(2000, 1, 1),
                    minDate: DateTime(1950, 1, 1),
                    maxDate: DateTime.now(),
                    onDateSelected: (DateTime? date) {
                      print(date.toString());
                      birthDateTextController.text =
                          '${date!.day}/${date.month}/${date.year}';
                      DateFormat format = DateFormat("dd/MM/yyyy");
                      DateTime dateTime =
                          format.parse(birthDateTextController.text);
                      print(dateTime.toString());
                    },
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    borderColor: context.isDarkMode
                        ? const Color(0xffCACFF4)
                        : AppColors.PRIMARY_COLOR,
                    borderWidth: 1,
                    title: birthDateTextController.text,
                    textStyle: Styles.mediumText(),
                  ),
                  const Sizer(),
                  Text(
                    // LocaleKeys.country.localize,
                    LocaleKeys.governorate.localize,
                    style: Styles.headerText(fontSize: 30),
                  ),
                  const Sizer(),
                  GoverDropdown(
                    country: country,
                  ),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: DefaultTextFormField(
                  //         fillColor: Colors.transparent,
                  //         currentController: countryTextController,
                  //         hint: LocaleKeys.country.localize,
                  //         onTap: () async {},
                  //         enabled: false,
                  //         // prefixIcon: const Icon(Icons.family_restroom,color: Colors.green,),
                  //         suffixIcon:
                  //             const Icon(Icons.keyboard_arrow_down_outlined),
                  //       ),
                  //       // FormTextField(
                  //       //     hint: '${LocaleKeys.country.localize} ....',
                  //       //     action: (v) {
                  //       //       setState(() {});
                  //       //     },
                  //       //     prefix: const Icon(Icons.language),
                  //       //     controller: countryTextController),
                  //     ),
                  //     // PrivacyIcon(selectPrivacy: (name) {
                  //     //   controller.selectCountryPrivacy(privacy: name);
                  //     // })
                  //   ],
                  // ),
                  // const Sizer(),
                  // Row(
                  //   children: [
                  //     Text(
                  //       LocaleKeys.city.localize,
                  //       style: Styles.headerText(fontSize: 30),
                  //     ),
                  //     const Sizer(),
                  //     if (state.selectedCityPrivacy != null)
                  //       Text(
                  //         '(${state.selectedCityPrivacy == 'public' ? LocaleKeys.public.localize : state.selectedCityPrivacy == 'friends' ? LocaleKeys.friends.localize : state.selectedCityPrivacy == 'followers' ? LocaleKeys.friends.localize : state.selectedCityPrivacy == 'friendsAndFollowers' ? LocaleKeys.friendsAndFollowers.localize : state.selectedCityPrivacy == 'onlyMe' ? LocaleKeys.onlyMe.localize : ''})',
                  //         style: Styles.headerText(fontSize: 22),
                  //       ),
                  //   ],
                  // ),
                  // const Sizer(),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: FormTextField(
                  //           hint: '${LocaleKeys.city.localize} ....',
                  //           action: (v) {
                  //             setState(() {});
                  //           },
                  //           prefix: const Icon(Icons.location_on),
                  //           controller: cityTextController),
                  //     ),
                  //     PrivacyIcon(
                  //       selectPrivacy: (name) {
                  //         controller.selectCityPrivacy(privacy: name);
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // const Sizer(),
                  // Row(
                  //   children: [
                  //     Text(
                  //       LocaleKeys.maritalStatus.localize,
                  //       style: Styles.headerText(fontSize: 30),
                  //     ),
                  //     if (state.selectedStatusPrivacy != null) ...[
                  //       const Sizer(),
                  //       Text(
                  //         '(${state.selectedStatusPrivacy == 'public' ? LocaleKeys.public.localize : state.selectedStatusPrivacy == 'friends' ? LocaleKeys.friends.localize : state.selectedStatusPrivacy == 'followers' ? LocaleKeys.followers.localize : state.selectedStatusPrivacy == 'friendsAndFollowers' ? LocaleKeys.friendsAndFollowers.localize : state.selectedStatusPrivacy == 'onlyMe' ? LocaleKeys.onlyMe.localize : ''})',
                  //         style: Styles.headerText(fontSize: 22),
                  //       )
                  //     ],
                  //   ],
                  // ),
                  // const Sizer(),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: InkWell(
                  //         onTap: () async {
                  //           final res = await CustomVerticalSheetItem.normal<
                  //               MaritalStatus>(context, [
                  //             CustomSheetModel(
                  //                 text: LocaleKeys.single.localize,
                  //                 value: MaritalStatus.single,
                  //                 image: Assets.single),
                  //             CustomSheetModel(
                  //                 text: LocaleKeys.married.localize,
                  //                 value: MaritalStatus.married,
                  //                 image: Assets.married),
                  //             CustomSheetModel(
                  //                 text: LocaleKeys.divorced.localize,
                  //                 value: MaritalStatus.divorced,
                  //                 image: Assets.divorced),
                  //             CustomSheetModel(
                  //                 text: LocaleKeys.widowed.localize,
                  //                 value: MaritalStatus.widowed,
                  //                 image: Assets.widowed),
                  //           ]);
                  //           print(res?.name);
                  //           print("============>");
                  //           statusController.text = res?.name == 'single'
                  //               ? LocaleKeys.single.localize
                  //               : res?.name == 'married'
                  //                   ? LocaleKeys.married.localize
                  //                   : res?.name == 'divorced'
                  //                       ? LocaleKeys.divorced.localize
                  //                       : res?.name == 'widowed'
                  //                           ? LocaleKeys.widowed.localize
                  //                           : '';
                  //           controller.selectMaritalStatus(
                  //               status: res?.name ?? 'single');
                  //         },
                  //         child: FormTextField(
                  //           hint: '${LocaleKeys.maritalStatus.localize}....',
                  //           controller: statusController,
                  //           onTap: () async {},
                  //           enabled: false,
                  //           prefix: const Icon(Icons.family_restroom),
                  //           suffix:
                  //               const Icon(Icons.keyboard_arrow_down_outlined),
                  //         ),
                  //       ),
                  //     ),
                  //     PrivacyIcon(selectPrivacy: (name) {
                  //       controller.selectStatusPrivacy(privacy: name);
                  //     })
                  //   ],
                  // ),
                  // const Spacer(),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         child: InkWell(
                  //       onTap: () {
                  //         setState(() {
                  //           state.isMale = true;
                  //         });
                  //       },
                  //       child: Container(
                  //         padding: const EdgeInsets.all(10),
                  //         decoration: BoxDecoration(
                  //             color: state.isMale == true
                  //                 ? AppColors.PRIMARY_COLOR
                  //                 : Colors.white,
                  //             borderRadius: BorderRadius.circular(15),
                  //             border: Border.all(color: AppColors.PRIMARY_COLOR)),
                  //         alignment: AlignmentDirectional.center,
                  //         child: Text(
                  //           LocaleKeys.maleUser.localize,
                  //           style: Styles.mediumText(
                  //               color: state.isMale == false
                  //                   ? AppColors.PRIMARY_COLOR
                  //                   : Colors.white),
                  //         ),
                  //       ),
                  //     )),
                  //     const Sizer(),
                  //     Expanded(
                  //       child: InkWell(
                  //         onTap: () {
                  //           setState(() {
                  //             state.isMale = false;
                  //           });
                  //         },
                  //         child: Container(
                  //           padding: const EdgeInsets.all(10),
                  //           decoration: BoxDecoration(
                  //               color: state.isMale == false
                  //                   ? AppColors.PRIMARY_COLOR
                  //                   : Colors.white,
                  //               borderRadius: BorderRadius.circular(15),
                  //               border:
                  //                   Border.all(color: AppColors.PRIMARY_COLOR)),
                  //           alignment: AlignmentDirectional.center,
                  //           child: Text(
                  //             LocaleKeys.femaleUser.localize,
                  //             style: Styles.mediumText(
                  //                 color: state.isMale == true
                  //                     ? AppColors.PRIMARY_COLOR
                  //                     : Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Spacer(),
                  const Sizer(
                    height: 30,
                  ),
                  state.status == EditProfileStates.loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : InkWell(
                          onTap: () async {
                            DateFormat format = DateFormat("dd/MM/yyyy");
                            DateTime dateTime =
                                format.parse(birthDateTextController.text);
                            String oldDate = DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse((context
                                            .read<UserCubit>()
                                            .state
                                            .data
                                            ?.birthday ??
                                        '')
                                    .toString()
                                    .substring(0, 19)))
                                .toString();
                            if (getIfEditedAnyThing(oldDate: oldDate)) {
                              showErrorMessage(context,
                                  LocaleKeys.editSomethingFirst.localize);
                              return;
                            }
                            await controller.editProfile(
                              EditProfileEntity(
                                // state.selectedBioPrivacy ?? 'public',
                                // state.selectedPhonePrivacy ?? 'public',
                                // state.selectedJobPrivacy ?? 'public',
                                // state.selectedCountryPrivacy ?? 'public',
                                // state.selectedCityPrivacy ?? 'public',
                                // firstName: nameTextController.text.split(' ')[0],
                                // lastName: nameTextController.text.split(' ')[1],
                                firstName: firstNameTextController.text,
                                lastName: lastNameTextController.text,
                                bio: bioTextController.text,
                                phone: phoneTextController.text,
                                job: jobTextController.text,
                                country: state.selectedCountry!,
                                // country: '',
                                city: cityTextController.text,
                                birthday: dateTime.toString(),
                                // maritalPrivacy:
                                //     state.selectedStatusPrivacy ?? 'public',
                                maritalStatus: state.selectedStatus ?? 'single',
                                isMale: gender == 'male' ? true : false,
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20.h),
                            decoration: BoxDecoration(
                              color: context.isDarkMode
                                  ? Color(0xff333333)
                                  : Color(0xffD9D9D9),
                              borderRadius: BorderRadius.circular(15),
                              // border:
                              //     Border.all(color: AppColors.PRIMARY_COLOR)
                            ),
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              LocaleKeys.save.localize,
                              style: Styles.mediumText(
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : AppColors.PRIMARY_COLOR),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool getIfEditedAnyThing({required String oldDate}) {
    return userNameTextController.text ==
            (context.read<UserCubit>().state.data?.username ?? '') &&
        firstNameTextController.text ==
            (context.read<UserCubit>().state.data?.firstName ?? '') &&
        lastNameTextController.text ==
            (context.read<UserCubit>().state.data?.lastName ?? '') &&
        phoneTextController.text ==
            (context.read<UserCubit>().state.data?.phone ?? '') &&
        birthDateTextController.text == oldDate &&
        bioTextController.text ==
            (context.read<UserCubit>().state.data?.bio ?? '') &&
        jobTextController.text ==
            (context.read<UserCubit>().state.data?.job ?? '') &&
        cityTextController.text ==
            (context.read<UserCubit>().state.data?.city ?? '') &&
        gender == context.read<UserCubit>().state.data?.gender;
  }
}
