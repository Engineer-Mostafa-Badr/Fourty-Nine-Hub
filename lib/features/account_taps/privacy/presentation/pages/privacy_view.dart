import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/account_taps/privacy/domain/useCase/update_privacy_use_case.dart';
import 'package:fourtyninehub/features/account_taps/privacy/presentation/cubit/privacy_cubit.dart';
import 'package:fourtyninehub/features/account_taps/privacy/presentation/cubit/privacy_state.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../domain/entities/privacy_status_enum.dart';
import '../widgets/privacy_muti_select_item.dart';
import '../widgets/privacy_switch_item.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(
          label: Labels.privacy,
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
                          label: 'Country',
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
                          label: 'Phone',
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
                          label: 'Email',
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
                          label: 'Birth Date',
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
                          label: 'Social Status',
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
                          label: 'Job',
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
                          label: 'City',
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
                          label: 'Gender',
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
                          label: 'Language',
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
                          label: 'Receive Messages',
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
                          label: 'Last Seen',
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
                          label: 'Friends List',
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
                          label: 'Followers List',
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
                          label: 'Activity',
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
                          label: 'Call',
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
                          label: 'Friend Request',
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
                          label: 'Follow',
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
