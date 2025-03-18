import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
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

class EditProfileView extends StatefulWidget {
  const EditProfileView({
    super.key,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final userNameTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final phoneTextController = TextEditingController();

  final cityTextController = TextEditingController();
  final countryTextController = TextEditingController();
  final birthDateTextController = TextEditingController();

  final jobTextController = TextEditingController();
  final referrerTextController = TextEditingController();
  final bioTextController = TextEditingController();
  final statusController = TextEditingController();

  @override
  void initState() {
    print(context.read<UserCubit>().state.data);
    userNameTextController.text =
        "${context.read<UserCubit>().state.data?.username}" ??
            '';
    nameTextController.text =
        "${context.read<UserCubit>().state.data?.firstName} ${context.read<UserCubit>().state.data?.lastName}" ??
            '';
    phoneTextController.text =
        context.read<UserCubit>().state.data?.phone ?? '';
    cityTextController.text = context.read<UserCubit>().state.data?.city ?? '';
    countryTextController.text =
        context.read<UserCubit>().state.data?.country ?? '';

    birthDateTextController.text =
        context.read<UserCubit>().state.data?.birthday.toString() ?? '';
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
        return CustomScaffold(
          appBar: BackAppBar(
            label: LocaleKeys.editProfile.localize,
            enableCustomAppBar: true,
          ),
          enableCustomAppBar: true,
          body: Padding(
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

                ),
                const Sizer(),
                Text(
                  LocaleKeys.name.localize,
                  style: Styles.headerText(fontSize: 30),
                ),
                const Sizer(),
                DefaultTextFormField(
                  fillColor: Colors.transparent,
                  currentController: nameTextController,
                  hint: LocaleKeys.name.localize,
                ),

                // FormTextField(
                //     hint: '${LocaleKeys.name.localize} ....',
                //     action: (v) {
                //       setState(() {});
                //     },
                //     prefix: const Icon(Icons.edit),
                //     controller: nameTextController),
                // const Sizer(),
                // Row(
                //   children: [
                //     Text(
                //       LocaleKeys.bio.localize,
                //       style: Styles.headerText(fontSize: 30),
                //     ),
                //     const Sizer(),
                //     if (state.selectedBioPrivacy != null)
                //       Text(
                //         '(${state.selectedBioPrivacy == 'public' ? LocaleKeys.public.localize : state.selectedBioPrivacy == 'friends' ? LocaleKeys.friends.localize : state.selectedBioPrivacy == 'followers' ? LocaleKeys.followers.localize : state.selectedBioPrivacy == 'friendsAndFollowers' ? LocaleKeys.friendsAndFollowers.localize : state.selectedBioPrivacy == 'onlyMe' ? LocaleKeys.onlyMe.localize : ''})',
                //         style: Styles.headerText(fontSize: 22),
                //       ),
                //   ],
                // ),
                // const Sizer(),
                // Row(
                //   children: [
                //     Expanded(
                //       child: FormTextField(
                //           hint: '${LocaleKeys.bio.localize} ....',
                //           action: (v) {
                //             setState(() {});
                //           },
                //           prefix: const Icon(Icons.edit),
                //           controller: bioTextController),
                //     ),
                //     PrivacyIcon(
                //       selectPrivacy: (name) {
                //         controller.selectBioPrivacy(privacy: name);
                //       },
                //     ),
                //   ],
                // ),
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
                // const Sizer(),
                // Row(
                //   children: [
                //     Text(
                //       LocaleKeys.job.localize,
                //       style: Styles.headerText(fontSize: 30),
                //     ),
                //     const Sizer(),
                //     if (state.selectedJobPrivacy != null)
                //       Text(
                //         '(${state.selectedJobPrivacy == 'public' ? LocaleKeys.public.localize : state.selectedJobPrivacy == 'friends' ? LocaleKeys.friends.localize : state.selectedJobPrivacy == 'followers' ? LocaleKeys.followers.localize : state.selectedJobPrivacy == 'friendsAndFollowers' ? LocaleKeys.friendsAndFollowers.localize : state.selectedJobPrivacy == 'onlyMe' ? LocaleKeys.onlyMe.localize : ''})',
                //         style: Styles.headerText(fontSize: 22),
                //       ),
                //   ],
                // ),
                // const Sizer(),
                // Row(
                //   children: [
                //     Expanded(
                //       child: FormTextField(
                //           hint: '${LocaleKeys.job.localize} ....',
                //           action: (v) {
                //             setState(() {});
                //           },
                //           prefix: const Icon(Icons.work),
                //           controller: jobTextController),
                //     ),
                //     PrivacyIcon(selectPrivacy: (name) {
                //       controller.selectJobPrivacy(privacy: name);
                //     })
                //   ],
                // ),
                const Sizer(),
                Text(
                  LocaleKeys.birthDate.localize,
                  style: Styles.headerText(fontSize: 30),
                ),
                const Sizer(),
                DatePickerField(
                  initialDate: DateTime.now(),
                  minDate: DateTime.now().subtract(const Duration(days: 10)),
                  maxDate: DateTime.now().subtract(const Duration(days: 10)),
                  onDateSelected: (DateTime? date) {
                    print(date.toString());
                    birthDateTextController.text =
                        '${date!.year}-${date.month}-${date.day}';
                  },
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  borderColor: AppColors.PRIMARY_COLOR,
                  borderWidth: 1,
                  title: birthDateTextController.text,
                ),
                // DefaultTextFormField(
                //   hint: LocaleKeys.birthDate.localize,
                //   currentController: birthDateTextController,
                //   onTap: () async {
                //     // showDatePicker(context: context, firstDate: t, lastDate: lastDate)
                //   },
                //   enabled: false,
                //   fillColor: Colors.transparent,
                //   // prefixIcon: const Icon(Icons.family_restroom,color: Colors.green,),
                //   suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
                // ),
                const Sizer(),
                Row(
                  children: [
                    Text(
                      LocaleKeys.country.localize,
                      style: Styles.headerText(fontSize: 30),
                    ),
                    // const Sizer(),
                    // if (state.selectedCountryPrivacy != null)
                    //   Text(
                    //     '(${state.selectedCountryPrivacy == 'public' ? LocaleKeys.public.localize : state.selectedCountryPrivacy == 'friends' ? LocaleKeys.friends.localize : state.selectedCountryPrivacy == 'followers' ? LocaleKeys.followers.localize : state.selectedCountryPrivacy == 'friendsAndFollowers' ? LocaleKeys.friendsAndFollowers.localize : state.selectedCountryPrivacy == 'onlyMe' ? LocaleKeys.onlyMe.localize : ''})',
                    //     style: Styles.headerText(fontSize: 22),
                    //   ),
                  ],
                ),
                const Sizer(),
                Row(
                  children: [
                    Expanded(
                      child: DefaultTextFormField(
                        fillColor: Colors.transparent,
                        currentController: countryTextController,
                        hint: LocaleKeys.country.localize,
                        onTap: () async {},
                        enabled: false,
                        // prefixIcon: const Icon(Icons.family_restroom,color: Colors.green,),
                        suffixIcon:
                            const Icon(Icons.keyboard_arrow_down_outlined),
                      ),
                      // FormTextField(
                      //     hint: '${LocaleKeys.country.localize} ....',
                      //     action: (v) {
                      //       setState(() {});
                      //     },
                      //     prefix: const Icon(Icons.language),
                      //     controller: countryTextController),
                    ),
                    // PrivacyIcon(selectPrivacy: (name) {
                    //   controller.selectCountryPrivacy(privacy: name);
                    // })
                  ],
                ),
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
                Spacer(),
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
                              firstName:
                                  nameTextController.text.split(' ')[0],
                              lastName: nameTextController.text.split(' ')[1],
                              bio: bioTextController.text,
                              phone: phoneTextController.text,
                              job: jobTextController.text,
                              country: countryTextController.text,
                              city: cityTextController.text,
                              birthday: birthDateTextController.text,
                              maritalPrivacy:
                                  state.selectedStatusPrivacy ?? 'public',
                              maritalStatus: state.selectedStatus ?? 'single',
                              isMale: state.isMale,),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20.h),
                          decoration: BoxDecoration(
                            color: Color(0xffD9D9D9),
                            borderRadius: BorderRadius.circular(15),
                            // border:
                            //     Border.all(color: AppColors.PRIMARY_COLOR)
                          ),
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            LocaleKeys.save.localize,
                            style: Styles.mediumText(
                                color: AppColors.PRIMARY_COLOR),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
