import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/update_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/presentation/cubit/privacy_cubit.dart';
import 'package:fourtyninehub/features/account_taps/privacy/presentation/cubit/privacy_state.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../domain/entities/privacy_status_enum.dart';
import '../widgets/privacy_muti_select_item.dart';
import '../widgets/privacy_switch_item.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  BackAppBar(
          label: LocaleKeys.privacy.localize,
        ),
        body: BlocProvider<PrivacyCubit>(
          create: (BuildContext context) => serviceLocator()..loadData(),
          child: BlocBuilder<PrivacyCubit, PrivacyState>(
            builder: (BuildContext context, state) {
              if (state.status == PrivacyStates.success) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.country.localize,
                          privacy: state.privacy?.privacyCountry ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                    UpdatePrivacyParams(
                                        privacyCountry:mapPrivacyStatusToString(value),
                                      privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                      privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                      privacyPhone: state.privacy?.privacyPhone ?? '',
                                      privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                      privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                      privacyJob: state.privacy?.privacyJob ?? '',
                                      privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                      privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                      privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                      privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                      privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                      privacyEmail: state.privacy?.privacyEmail ?? '',
                                      privacyCity: state.privacy?.privacyCity ?? '',
                                      privacyCall: state.privacy?.privacyCall ?? '',
                                      privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                      privacyActivity: state.privacy?.privacyActivity ?? '',
                                    ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.phone.localize,
                          privacy: state.privacy?.privacyPhone ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: mapPrivacyStatusToString(value),
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall: state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.email.localize,
                          privacy: state.privacy?.privacyEmail ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: mapPrivacyStatusToString(value),
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall: state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.birthDate.localize,
                          privacy: state.privacy?.privacyBirthDay ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall: state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: mapPrivacyStatusToString(value),
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.socialStatus.localize,
                          privacy: state.privacy?.privacySocialStatus ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: mapPrivacyStatusToString(value),
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall: state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.job.localize,
                          privacy: state.privacy?.privacyJob ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: mapPrivacyStatusToString(value),
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall: state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.city.localize,
                          privacy: state.privacy?.privacyCity ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: mapPrivacyStatusToString(value),
                                  privacyCall: state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.gender.localize,
                          privacy: state.privacy?.privacyIsMale ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: mapPrivacyStatusToString(value),
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall: state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.language.localize,
                          privacy: state.privacy?.privacyLanguage ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: mapPrivacyStatusToString(value),
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall: state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.receiveMessages.localize,
                          privacy: state.privacy?.privacyReceiveMessages ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: mapPrivacyStatusToString(value),
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall: state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.lastSeen.localize,
                          privacy: state.privacy?.privacyLastSeen ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: mapPrivacyStatusToString(value),
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall: state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.friendsList.localize,
                          privacy: state.privacy?.privacyFriendList ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: mapPrivacyStatusToString(value),
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall: state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.followerList.localize,
                          privacy: state.privacy?.privacyFollowerList ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: mapPrivacyStatusToString(value),
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall: state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.activity.localize,
                          privacy: state.privacy?.privacyActivity ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall: state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity:  mapPrivacyStatusToString(value),
                                ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: LocaleKeys.call.localize,
                          privacy: state.privacy?.privacyCall ?? '',
                          onChoose: (PrivacyStatus value) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall:mapPrivacyStatusToString(value),
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                        PrivacySwitchItem(
                          label: LocaleKeys.friendRequest.localize,
                          privacy: state.privacy?.privacyFriendRequest ?? false,
                          onPress: (v) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: v,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: state.privacy?.privacyFollowRequest ??false,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall:state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                        PrivacySwitchItem(
                          label: LocaleKeys.followRequest.localize,
                          privacy: state.privacy?.privacyFollowRequest ?? true,
                          onPress: (v) {
                            context.read<PrivacyCubit>().updateDataPrivacy(
                                params:
                                UpdatePrivacyParams(
                                  privacyCountry:state.privacy?.privacyCountry ?? '',
                                  privacySocialStatus: state.privacy?.privacyPhone ?? '',
                                  privacyReceiveMessages: state.privacy?.privacyReceiveMessages ?? '',
                                  privacyPhone: state.privacy?.privacyPhone ?? '',
                                  privacyLastSeen: state.privacy?.privacyLastSeen ?? '',
                                  privacyLanguage: state.privacy?.privacyLanguage ?? '',
                                  privacyJob: state.privacy?.privacyJob ?? '',
                                  privacyIsMale: state.privacy?.privacyIsMale ?? '',
                                  privacyFriendRequest: state.privacy?.privacyFriendRequest ??false,
                                  privacyFriendList: state.privacy?.privacyFriendList ?? '',
                                  privacyFollowRequest: v,
                                  privacyFollowerList: state.privacy?.privacyFollowerList ?? '',
                                  privacyEmail: state.privacy?.privacyEmail ?? '',
                                  privacyCity: state.privacy?.privacyCity ?? '',
                                  privacyCall:state.privacy?.privacyCall ?? '',
                                  privacyBirthDay: state.privacy?.privacyBirthDay ?? '',
                                  privacyActivity: state.privacy?.privacyActivity ?? '',
                                ));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }

}
