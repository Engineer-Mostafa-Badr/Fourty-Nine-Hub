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
                                        privacyCountry: value,
                                      privacyActivity: PrivacyStatus.public,
                                      privacyBirthDay: PrivacyStatus.public,
                                      privacyCall: PrivacyStatus.public,
                                      privacyCity: PrivacyStatus.public,
                                      privacyEmail: PrivacyStatus.public,
                                      privacyFollowerList:PrivacyStatus.public ,
                                      privacyFollowRequest:true ,
                                      privacyFriendList:PrivacyStatus.public ,
                                      privacyFriendRequest:true ,
                                      privacyIsMale:PrivacyStatus.public ,
                                      privacyJob:PrivacyStatus.public ,
                                      privacyLanguage:PrivacyStatus.public ,
                                      privacyLastSeen:PrivacyStatus.public ,
                                      privacyPhone:PrivacyStatus.public ,
                                      privacyReceiveMessages:PrivacyStatus.public ,
                                      privacySocialStatus:PrivacyStatus.public ,

                                    ));
                          },
                        ),
                        PrivacyMultiSelectItem(
                          label: 'Phone',
                          privacy: state.privacy?.privacyPhone ?? '',
                          onChoose: (PrivacyStatus value) {},
                        ),
                        PrivacyMultiSelectItem(
                          label: 'Email',
                          privacy: state.privacy?.privacyEmail ?? '',
                          onChoose: (PrivacyStatus value) {},
                        ),
                        PrivacyMultiSelectItem(
                          label: 'Birth Date',
                          privacy: state.privacy?.privacyBirthDay ?? '',
                          onChoose: (PrivacyStatus value) {},
                        ),
                        PrivacyMultiSelectItem(
                          label: 'Social Status',
                          privacy: state.privacy?.privacySocialStatus ?? '',
                          onChoose: (PrivacyStatus value) {},
                        ),
                        PrivacyMultiSelectItem(
                          label: 'Job',
                          privacy: state.privacy?.privacyJob ?? '',
                          onChoose: (PrivacyStatus value) {},
                        ),
                        PrivacyMultiSelectItem(
                          label: 'City',
                          privacy: state.privacy?.privacyCity ?? '',
                          onChoose: (PrivacyStatus value) {},
                        ),
                        PrivacyMultiSelectItem(
                          label: 'Gender',
                          privacy: state.privacy?.privacyIsMale ?? '',
                          onChoose: (PrivacyStatus value) {},
                        ),
                        PrivacyMultiSelectItem(
                          label: 'Language',
                          privacy: state.privacy?.privacyLanguage ?? '',
                          onChoose: (PrivacyStatus value) {},
                        ),
                        PrivacyMultiSelectItem(
                          label: 'Receive Messages',
                          privacy: state.privacy?.privacyReceiveMessages ?? '',
                          onChoose: (PrivacyStatus value) {},
                        ),
                        PrivacyMultiSelectItem(
                          label: 'Last Seen',
                          privacy: state.privacy?.privacyLastSeen ?? '',
                          onChoose: (PrivacyStatus value) {},
                        ),
                        PrivacyMultiSelectItem(
                          label: 'Friends List',
                          privacy: state.privacy?.privacyFriendList ?? '',
                          onChoose: (PrivacyStatus value) {},
                        ),
                        PrivacyMultiSelectItem(
                          label: 'Followers List',
                          privacy: state.privacy?.privacyFollowerList ?? '',
                          onChoose: (PrivacyStatus value) {},
                        ),
                        PrivacyMultiSelectItem(
                          label: 'Activity',
                          privacy: state.privacy?.privacyActivity ?? '',
                          onChoose: (PrivacyStatus value) {},
                        ),
                        // PrivacyMultiSelectItem(
                        //   label: 'Friend Request',
                        //   privacy: state.privacy?.privacyFriendRequest ??'',
                        //   onChoose: (PrivacyStatus value) {},
                        //   isFriendEnable: false,
                        // ),
                        // PrivacyMultiSelectItem(
                        //   label: 'Follow',
                        //   privacy: state.privacy?.privacyFollowRequest ??'',
                        //   onChoose: (PrivacyStatus value) {},
                        //   isFriendEnable: false,
                        // ),
                        PrivacyMultiSelectItem(
                          label: 'Call',
                          privacy: state.privacy?.privacyCall ?? '',
                          onChoose: (PrivacyStatus value) {},
                        ),
                        // PrivacySwitchItem(
                        //   label: 'Random Appearance',
                        //   privacy: PrivacyStatus.public,
                        //   onPress: (v) {},
                        // ),
                        PrivacySwitchItem(
                          label: 'Friend Request',
                          privacy: state.privacy?.privacyFriendRequest ?? false,
                          onPress: (v) {},
                        ),
                        PrivacySwitchItem(
                          label: 'Follow',
                          privacy: state.privacy?.privacyFollowRequest ?? true,
                          onPress: (v) {},
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
