import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/hex_color_helper.dart';
import 'package:fourtyninehub/features/account_taps/privacy/presentation/cubit/privacy_cubit.dart';
import 'package:fourtyninehub/features/account_taps/privacy/presentation/cubit/privacy_state.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../core/widget/custom_text_no_login.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../domain/entities/privacy_status_enum.dart';
import '../../domain/entities/search_users_entity.dart';
import '../../domain/useCase/update_communication_privacy_use_case.dart';
import '../../domain/useCase/update_connection_privacy_use_case.dart';
import '../../domain/useCase/update_except_from_privacy_use_case.dart';
import '../../domain/useCase/update_media_privacy_use_case.dart';
import '../../domain/useCase/update_only_with_privacy_use_case.dart';
import '../../domain/useCase/update_personal_privacy_use_case.dart';
import '../widgets/privacy_muti_select_item.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class PrivacyView extends StatelessWidget {
   PrivacyView({super.key});




  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      enableCustomAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.privacy.localize,
          enableCustomAppBar: true,
        ),
      ),
      body: context.read<UserCubit>().isLoggedIn
          ? BlocProvider<PrivacyCubit>(
              create: (BuildContext context) => serviceLocator()..loadData(),
              child: BlocBuilder<PrivacyCubit, PrivacyState>(
                builder: (BuildContext context, state) {
                  if(state.status == PrivacyStates.loading ){
                    return const Center(child: CustomCircularProgressIndicator());
                  }
                  if(state.personalPrivacyEntity == null ){
                    return Center(child: Text("No Data",style: TextStyle(color: Colors.white,fontSize: 35),),);
                  }
                  if (state.status == PrivacyStates.success) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 8,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            PrivacyMultiSelectItem(
                              label: LocaleKeys.country.localize,
                              privacy: state.personalPrivacyEntity?.country ?? '',
                              name:  mapPrivacyFeatureToString(PrivacyFeature.country),
                              onChoose: (PrivacyStatus value, List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.country;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {
                                  String mappedPrivacy = mapPrivacyStatusToString(value);

                                  // 🔹 Ensure 'except-from' is not sent
                                  if (mappedPrivacy == "except-from") {
                                    mappedPrivacy = "only-me"; // Change this to an appropriate default value
                                  }

                                  print("The Value I send: $mappedPrivacy");

                                  context.read<PrivacyCubit>().updateDataPersonalPrivacy(
                                    params: UpdatePersonalPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mappedPrivacy, // The new privacy option
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                              },
                            ),

                            PrivacyMultiSelectItem(
                              label: LocaleKeys.phone.localize,
                              name:  mapPrivacyFeatureToString(PrivacyFeature.phoneNumber),
                              privacy:
                                  state.personalPrivacyEntity?.phoneNumber ??
                                      '',
                              onChoose: (PrivacyStatus value, List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.phoneNumber;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {


                                  context
                                      .read<PrivacyCubit>()
                                      .updateDataPersonalPrivacy(
                                    params: UpdatePersonalPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),
                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.email),
                              label: LocaleKeys.email.localize,
                              privacy:
                                  state.personalPrivacyEntity?.email ?? '',
                              onChoose: (PrivacyStatus value,
                                 List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.email;
                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {

                                  context
                                      .read<PrivacyCubit>()
                                      .updateDataPersonalPrivacy(
                                    params: UpdatePersonalPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),
                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.birthDay),
                              label: LocaleKeys.birthDate.localize,
                              privacy:
                                  state.personalPrivacyEntity?.birthDay ?? '',
                              onChoose: (PrivacyStatus value,
                                 List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.birthDay;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {

                                  context
                                      .read<PrivacyCubit>()
                                      .updateDataPersonalPrivacy(
                                    params: UpdatePersonalPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),

                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.job),
                              label: LocaleKeys.job.localize,
                              privacy: state.personalPrivacyEntity?.job ?? '',
                              onChoose: (PrivacyStatus value,
                                 List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.job;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {

                                  context
                                      .read<PrivacyCubit>()
                                      .updateDataPersonalPrivacy(
                                    params: UpdatePersonalPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),


                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.city),
                              label: LocaleKeys.city.localize,
                              privacy:
                                  state.personalPrivacyEntity?.city ?? '',
                              onChoose: (PrivacyStatus value, List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.language;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {


                                  context.read<PrivacyCubit>().updateDataPersonalPrivacy(
                                    params: UpdatePersonalPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                              // onChoose: (PrivacyStatus value,
                              //    List<String>? selectedUsers) {
                              //   PrivacyFeature feature = PrivacyFeature.city;
                              //   if (value == PrivacyStatus.onlyWith) {
                              //     context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                              //       params: UpdateOnlyWithPrivacyParams(
                              //         allowedUsers: selectedUsers ?? [],
                              //         feature: mapPrivacyFeatureToString(feature),
                              //       ),
                              //     ).then((_) {
                              //       context.read<PrivacyCubit>().loadData();
                              //     });
                              //   }
                              //   else if (value == PrivacyStatus.exceptFrom) {
                              //     context.read<PrivacyCubit>().updateExceptFromPrivacy(
                              //       params: UpdateExceptFromPrivacyParams(
                              //         allowedUsers: selectedUsers ?? [],
                              //         feature: mapPrivacyFeatureToString(feature),
                              //       ),
                              //     ).then((_) {
                              //       context.read<PrivacyCubit>().loadData();
                              //     });
                              //   }
                              //   else {
                              //     String mappedPrivacy =
                              //     mapPrivacyStatusToString(value);
                              //
                              //     if (mappedPrivacy == "except-from") {
                              //       mappedPrivacy = "only-me";
                              //     }
                              //     context
                              //         .read<PrivacyCubit>()
                              //         .updateDataPersonalPrivacy(
                              //       params: UpdatePersonalPrivacyParams(
                              //         privacyCountry: state
                              //             .personalPrivacyEntity
                              //             ?.country ??
                              //             '',
                              //         privacyEmail: state
                              //             .personalPrivacyEntity
                              //             ?.email ??
                              //             '',
                              //         privacyPhone: state
                              //             .personalPrivacyEntity
                              //             ?.phoneNumber ??
                              //             '',
                              //         privacyGender: state
                              //             .personalPrivacyEntity
                              //             ?.gender ??
                              //             '',
                              //         privacyCity:
                              //         mappedPrivacy,
                              //         privacyJob: state
                              //             .personalPrivacyEntity?.job ??
                              //             '',
                              //         privacyBirthDay: state
                              //             .personalPrivacyEntity
                              //             ?.birthDay ??
                              //             '',
                              //         privacyLanguage: state
                              //             .personalPrivacyEntity
                              //             ?.language ??
                              //             '',
                              //       ),
                              //     );
                              //   }
                              // },
                            ),

                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.gender),
                              label: LocaleKeys.gender.localize,
                              privacy:
                                  state.personalPrivacyEntity?.gender ?? '',
                              onChoose: (PrivacyStatus value,
                                 List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.gender;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {

                                  context
                                      .read<PrivacyCubit>()
                                      .updateDataPersonalPrivacy(
                                    params: UpdatePersonalPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),
                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.language),
                              label: LocaleKeys.language.localize,
                              privacy:
                                  state.personalPrivacyEntity?.language ?? '',
                              onChoose: (PrivacyStatus value,
                                 List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.language;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {

                                  context
                                      .read<PrivacyCubit>()
                                      .updateDataPersonalPrivacy(
                                    params: UpdatePersonalPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),
                            // not made
                            // PrivacyMultiSelectItem(
                            //     label: LocaleKeys.socialStatus.localize,
                            //     privacy:
                            //         state.privacy?.privacySocialStatus ?? '',
                            //     onChoose: (PrivacyStatus value,
                            //        List<String>?
                            //             selectedUsers) {}),


                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.lastSeen),
                              label: LocaleKeys.lastSeen.localize,
                              privacy: state.communicationPrivacyEntity?.lastSeen ?? '',
                              onChoose: (PrivacyStatus value,
                                 List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.lastSeen;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {
                                  context
                                      .read<PrivacyCubit>()
                                      .updateDataCommunicationPrivacy(
                                    params:
                                    UpdateCommunicationPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),

                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.friendsList),
                              label: LocaleKeys.friendsList.localize,
                              privacy: state
                                      .connectionPrivacyEntity?.friendsList ??
                                  '',
                              onChoose: (PrivacyStatus value,
                                 List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.friendsList;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {
                                  context
                                      .read<PrivacyCubit>()
                                      .updateDataConnectionPrivacy(
                                    params: UpdateConnectionPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),

                                    ),
                                  );
                                }
                              },
                            ),
                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.followerList),
                              label: LocaleKeys.followerList.localize,
                              privacy: state.connectionPrivacyEntity
                                      ?.followerList ??
                                  '',
                              onChoose: (PrivacyStatus value,
                                 List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.followerList;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {
                                  context
                                      .read<PrivacyCubit>()
                                      .updateDataConnectionPrivacy(
                                    params: UpdateConnectionPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),
                            // PrivacyMultiSelectItem(
                            //     label: LocaleKeys.activity.localize,
                            //     privacy: state.privacy?.privacyActivity ?? '',
                            //     onChoose: (PrivacyStatus value,
                            //        List<String>?
                            //             selectedUsers) {}),
                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.receiveCalls),
                              label: LocaleKeys.call.localize,
                              privacy: state.communicationPrivacyEntity
                                      ?.receiveCalls ??
                                  '',
                              onChoose: (PrivacyStatus value,
                                 List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.receiveCalls;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {
                                context
                                    .read<PrivacyCubit>()
                                    .updateDataCommunicationPrivacy(
                                      params:
                                          UpdateCommunicationPrivacyParams(
                                            feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                            newPrivacyOption: mapPrivacyStatusToString(value),
                                      ),
                                    );
                                }
                              },
                            ),

                            ///
                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.receiveAnonymousMessages),
                              label: LocaleKeys.anonymousMessage.localize,
                              privacy: state.communicationPrivacyEntity
                                      ?.receiveAnonymousMessages ??
                                  '',
                              onChoose: (PrivacyStatus value,
                                 List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.receiveAnonymousMessages;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {
                                  context
                                      .read<PrivacyCubit>()
                                      .updateDataCommunicationPrivacy(
                                    params:
                                    UpdateCommunicationPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),
                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.receiveGreetMessages),
                              label: LocaleKeys.greetMessage.localize,
                              privacy: state.communicationPrivacyEntity
                                      ?.receiveGreetMessages ??
                                  '',
                              onChoose: (PrivacyStatus value,
                                 List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.receiveGreetMessages;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {
                                  context
                                      .read<PrivacyCubit>()
                                      .updateDataCommunicationPrivacy(
                                    params:
                                    UpdateCommunicationPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),
                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.receiveSocialMessages),
                              label: LocaleKeys.socialMessage.localize,
                              privacy: state.communicationPrivacyEntity
                                      ?.receiveSocialMessages ??
                                  '',
                              onChoose: (PrivacyStatus value,
                                 List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.receiveSocialMessages;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {
                                  context
                                      .read<PrivacyCubit>()
                                      .updateDataCommunicationPrivacy(
                                    params:
                                    UpdateCommunicationPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),

                            ///

                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.randomAppearance),
                              label: LocaleKeys.randomAppearance.localize,
                              privacy: state.connectionPrivacyEntity
                                      ?.randomAppearance ??
                                  '',
                              onChoose: (PrivacyStatus value,
                                 List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.randomAppearance;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {
                                  context
                                      .read<PrivacyCubit>()
                                      .updateDataConnectionPrivacy(
                                    params: UpdateConnectionPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),

                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.friendRequests),

                              label: LocaleKeys.friendRequest.localize,
                              privacy: state.connectionPrivacyEntity
                                      ?.friendRequests ??
                                  '',
                              onChoose: (PrivacyStatus value,
                                 List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.friendRequests;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {
                                  context
                                      .read<PrivacyCubit>()
                                      .updateDataConnectionPrivacy(
                                    params: UpdateConnectionPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),


                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.followerRequests),

                              label: LocaleKeys.followRequest.localize,
                              privacy: state.connectionPrivacyEntity?.followerRequests ?? '',
                              onChoose: (PrivacyStatus value, List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.followerRequests;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {


                                  context.read<PrivacyCubit>().updateDataConnectionPrivacy(
                                    params: UpdateConnectionPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),

                            ///
                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.showPosts),

                              label: LocaleKeys.showPosts.localize,
                              privacy: state.mediaPrivacyEntity?.showPosts ?? '',
                              onChoose: (PrivacyStatus value, List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.showPosts;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {


                                  context.read<PrivacyCubit>().updateDataMediaPrivacy(
                                    params: UpdateMediaPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),
                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.showStories),

                              label: LocaleKeys.showStories.localize,
                              privacy: state.mediaPrivacyEntity?.showStories ?? '',
                              onChoose: (PrivacyStatus value, List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.showStories;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {


                                  context.read<PrivacyCubit>().updateDataMediaPrivacy(
                                    params: UpdateMediaPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),
                            PrivacyMultiSelectItem(
                              name: mapPrivacyFeatureToString(PrivacyFeature.showReels),
                              label: LocaleKeys.showReels.localize,
                              privacy: state.mediaPrivacyEntity?.showReels ?? '',
                              onChoose: (PrivacyStatus value, List<String>? selectedUsers) {
                                PrivacyFeature feature = PrivacyFeature.showReels;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {


                                  context.read<PrivacyCubit>().updateDataMediaPrivacy(
                                    params: UpdateMediaPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),
                            PrivacyMultiSelectItem(
                              name:  mapPrivacyFeatureToString(PrivacyFeature.writeComments),
                              label: LocaleKeys.writeComments.localize,
                              privacy: state.mediaPrivacyEntity?.writeComments ?? '',
                              onChoose: (PrivacyStatus value, List<String>? selectedUsers) {
                                 PrivacyFeature feature = PrivacyFeature.writeComments;

                                if (value == PrivacyStatus.onlyWith) {
                                  context.read<PrivacyCubit>().updateOnlyWithPrivacy(
                                    params: UpdateOnlyWithPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else if (value == PrivacyStatus.exceptFrom) {
                                  context.read<PrivacyCubit>().updateExceptFromPrivacy(
                                    params: UpdateExceptFromPrivacyParams(
                                      allowedUsers: selectedUsers ?? [],
                                      feature: mapPrivacyFeatureToString(feature),
                                    ),
                                  ).then((_) {
                                    context.read<PrivacyCubit>().loadData();
                                  });
                                }
                                else {


                                  context.read<PrivacyCubit>().updateDataMediaPrivacy(
                                    params: UpdateMediaPrivacyParams(
                                      feature: mapPrivacyFeatureToString(feature), // The feature being updated
                                      newPrivacyOption: mapPrivacyStatusToString(value),
                                    ),
                                  );
                                }
                              },
                            ),

                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const Center(child: CustomCircularProgressIndicator());
                },
              ),
            )
          : const CustomNotLogged(),
    );
  }
}
