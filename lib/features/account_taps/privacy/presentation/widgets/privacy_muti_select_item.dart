import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/custom_show_dialog.dart';
import '../../../../../common/widgets/stateless/custom_sheet/custom_vertical_sheet_item.dart';
import '../../../../../common/widgets/stateless/custom_sheet/sheet_vertical_item.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../domain/entities/privacy_status_enum.dart';
import '../../domain/entities/search_users_entity.dart';
import '../cubit/privacy_cubit.dart';
import '../cubit/privacy_state.dart';

// class PrivacyMultiSelectItem extends StatelessWidget {
//   final String label;
//   final String privacy;
//   final Function(PrivacyStatus value) onChoose;
//   final bool isFriendEnable;
//
//   const PrivacyMultiSelectItem({
//     super.key,
//     required this.label,
//     required this.privacy,
//     required this.onChoose,
//     this.isFriendEnable = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(10),
//         onTap: () async {
//           PrivacyStatus currentStatus = privacyToPrivacyStatus(privacy);
//
//           final res = await showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//               content: StatefulBuilder(
//                 builder: (context, setState) {
//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Label(text: 'Who Can See My $label'),
//                       _buildPrivacyOption(
//                         context,
//                         setState,
//                         title: LocaleKeys.public.localize,
//                         value: PrivacyStatus.public,
//                         currentStatus: currentStatus,
//                       ),
//                       _buildPrivacyOption(
//                         context,
//                         setState,
//                         title: LocaleKeys.friends.localize,
//                         value: PrivacyStatus.friends,
//                         currentStatus: currentStatus,
//                       ),
//                       _buildPrivacyOption(
//                         context,
//                         setState,
//                         title: LocaleKeys.followers.localize,
//                         value: PrivacyStatus.followers,
//                         currentStatus: currentStatus,
//                       ),
//                       _buildPrivacyOption(
//                         context,
//                         setState,
//                         title: '${LocaleKeys.friends.localize} / ${LocaleKeys.followers.localize}',
//                         value: PrivacyStatus.friendsAndFollowers,
//                         currentStatus: currentStatus,
//                       ),
//                       _buildPrivacyOption(
//                         context,
//                         setState,
//                         title: LocaleKeys.onlyMe.localize,
//                         value: PrivacyStatus.onlyMe,
//                         currentStatus: currentStatus,
//                       ),
//                       _buildPrivacyOption(
//                         context,
//                         setState,
//                         title: LocaleKeys.contacts.localize,
//                         value: PrivacyStatus.contacts,
//                         currentStatus: currentStatus,
//                       ),
//                       _buildPrivacyOption(
//                         context,
//                         setState,
//                         title: LocaleKeys.only_with.localize,
//                         value: PrivacyStatus.onlyWith,
//                         currentStatus: currentStatus,
//                         showUserDialog: true,
//                       ),
//                       _buildPrivacyOption(
//                         context,
//                         setState,
//                         title: LocaleKeys.except_from.localize,
//                         value: PrivacyStatus.exceptFrom,
//                         currentStatus: currentStatus,
//                         showUserDialog: true,
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           );
//
//           if (res != null) {
//             final selectedStatus = res as PrivacyStatus;
//             onChoose(selectedStatus);
//             log(selectedStatus.toString());
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Label(
//                   text: label,
//                   style: TextStyle(fontSize: 35, fontWeight: FontWeight.w400),
//                 ),
//               ),
//               Row(
//                 children: [
//                   Label(
//                     text: getPrivacyName(privacyToPrivacyStatus(privacy)),
//                     style: TextStyle(
//                       fontSize: 30,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Icon(
//                     getPrivacyIcon(privacyToPrivacyStatus(privacy)),
//                     color: Colors.grey,
//                   ),
//                 ],
//               ),
//               SizedBox(width: 15),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPrivacyOption(
//       BuildContext context,
//       StateSetter setState, {
//         required String title,
//         required PrivacyStatus value,
//         required PrivacyStatus currentStatus,
//         bool showUserDialog = false,
//       }) {
//     return RadioListTile<PrivacyStatus>(
//       value: value,
//       groupValue: currentStatus,
//       onChanged: (selectedValue) async {
//         setState(() {
//           currentStatus = selectedValue!;
//         });
//
//         log('Selected Privacy: $currentStatus');
//
//         if (showUserDialog) {
//           final selectedUsers = await showSearchUserDialog(context);
//           if (selectedUsers != null && selectedUsers.isNotEmpty) {
//             log('Selected Users: ${selectedUsers.map((e) => e.id).toList()}');
//           }
//         }
//
//       onChoose(currentStatus, selectedUsers);//         Navigator.pop(context);
//       },
//       title: Label(text: title),
//     );
//   }
//
//   PrivacyStatus privacyToPrivacyStatus(String privacy) {
//     switch (privacy) {
//       case 'only-me':
//         return PrivacyStatus.onlyMe;
//       case 'public':
//         return PrivacyStatus.public;
//       case 'friends':
//         return PrivacyStatus.friends;
//       case 'followers':
//         return PrivacyStatus.followers;
//       case 'friends-and-followers':
//         return PrivacyStatus.friendsAndFollowers;
//       case 'contacts':
//         return PrivacyStatus.contacts;
//       case 'only-with':
//         return PrivacyStatus.onlyWith;
//       case 'friends-except':
//         return PrivacyStatus.exceptFrom;
//       default:
//         return PrivacyStatus.public;
//     }
//   }
//
//   Future<List<SearchUsersEntity>?> showSearchUserDialog(BuildContext context) async {
//     List<SearchUsersEntity> selectedUsers = [];
//
//     return await showModalBottomSheet<List<SearchUsersEntity>>(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return BlocProvider(
//           create: (_) => serviceLocator<PrivacyCubit>(),
//           child: StatefulBuilder(
//             builder: (context, setState) {
//               return Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       decoration: InputDecoration(
//                         labelText: "Search Users",
//                         prefixIcon: Icon(Icons.search),
//                         border: OutlineInputBorder(),
//                       ),
//                       onChanged: (value) {
//                         if (value.isNotEmpty) {
//                           context.read<PrivacyCubit>().searchRestaurant(value);
//                         }
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     Expanded(
//                       child: BlocBuilder<PrivacyCubit, PrivacyState>(
//                         builder: (context, state) {
//                           if (state.status == PrivacyStates.loading) {
//                             return Center(child: CircularProgressIndicator());
//                           }
//                           if (state.status == PrivacyStates.error) {
//                             return Center(child: Text("Error fetching users"));
//                           }
//                           if (state.searchUsers == null || state.searchUsers!.isEmpty) {
//                             return Center(child: Text("No users found"));
//                           }
//
//
//                           return ListView.builder(
//                             itemCount: state.searchUsers!.length,
//                             itemBuilder: (context, index) {
//                               final user = state.searchUsers![index];
//                               final isSelected = selectedUsers.contains(user);
//
//                               return ListTile(
//                                 title: Text(user.firstName!),
//                                 subtitle: Text(user.lastName!),
//                                 trailing: Icon(
//                                   isSelected ? Icons.check_circle : Icons.circle_outlined,
//                                   color: isSelected ? Colors.blue : null,
//                                 ),
//                                 onTap: () {
//                                   setState(() {
//                                     if (isSelected) {
//                                       selectedUsers.remove(user);
//                                     } else {
//                                       selectedUsers.add(user);
//                                     }
//                                   });
//                                 },
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         print("Selected Users: ${selectedUsers.map((user) => '${user.firstName} ${user.lastName} (ID: ${user.id})').toList()}");
//                         // Navigator.pop(context, selectedUsers);
//                       },
//                       child: Text("Confirm Selection"),
//                     ),
//
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   String getPrivacyName(PrivacyStatus status) {
//     switch (status) {
//       case PrivacyStatus.onlyMe:
//         return LocaleKeys.onlyMe.localize;
//       case PrivacyStatus.public:
//         return LocaleKeys.public.localize;
//       case PrivacyStatus.friends:
//         return LocaleKeys.friends.localize;
//       case PrivacyStatus.followers:
//         return LocaleKeys.followers.localize;
//       case PrivacyStatus.friendsAndFollowers:
//         return '${LocaleKeys.friends.localize} / ${LocaleKeys.followers.localize}';
//       case PrivacyStatus.exceptFrom:
//         return LocaleKeys.except_from.localize;
//       case PrivacyStatus.onlyWith:
//         return LocaleKeys.only_with.localize;
//       case PrivacyStatus.contacts:
//         return LocaleKeys.contacts.localize;
//     }
//   }
//
//   IconData getPrivacyIcon(PrivacyStatus status) {
//     return Icons.privacy_tip;
//   }
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivacyMultiSelectItem extends StatelessWidget {
  final String label;
  final String privacy;
  final Function(PrivacyStatus value, List<String>? selectedUsers) onChoose;
  final bool isFriendEnable;

  const PrivacyMultiSelectItem({
    super.key,
    required this.label,
    required this.privacy,
    required this.onChoose,
    this.isFriendEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
          onTap: () async {
            PrivacyStatus currentStatus = privacyToPrivacyStatus(privacy);

            final res = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(text: 'Who Can See My $label'),
                        _buildPrivacyOption(context, setState, title: 'Public', value: PrivacyStatus.public, currentStatus: currentStatus),
                        _buildPrivacyOption(context, setState, title: 'Friends', value: PrivacyStatus.friends, currentStatus: currentStatus),
                        _buildPrivacyOption(context, setState, title: 'Followers', value: PrivacyStatus.followers, currentStatus: currentStatus),
                        _buildPrivacyOption(context, setState, title: 'Only Me', value: PrivacyStatus.onlyMe, currentStatus: currentStatus),
                        _buildPrivacyOption(context, setState, title: 'Friends And Followers', value: PrivacyStatus.friendsAndFollowers, currentStatus: currentStatus),
                        _buildPrivacyOption(context, setState, title: 'Only With', value: PrivacyStatus.onlyWith, currentStatus: currentStatus, showUserDialog: true),
                        _buildPrivacyOption(context, setState, title: 'Except From', value: PrivacyStatus.exceptFrom, currentStatus: currentStatus, showUserDialog: true),
                      ],
                    );
                  },
                ),
              ),
            );

            if (res != null) {
              final selectedStatus = res as PrivacyStatus;
              List<String>? selectedUsers;

              if (selectedStatus == PrivacyStatus.onlyWith || selectedStatus == PrivacyStatus.exceptFrom) {
                selectedUsers = await showSearchUserDialog(context);
                log("Selected Users for $selectedStatus: ${selectedUsers?.join(", ")}");
              }

              onChoose(selectedStatus, selectedUsers);
            }
          },

          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Label(text: label),
              ),
              Row(
                children: [
                  Label(text: getPrivacyName(privacyToPrivacyStatus(privacy))),
                  const SizedBox(width: 10),
                  Icon(getPrivacyIcon(privacyToPrivacyStatus(privacy)), color: Colors.grey),
                ],
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyOption(
      BuildContext context,
      StateSetter setState, {
        required String title,
        required PrivacyStatus value,
        required PrivacyStatus currentStatus,
        bool showUserDialog = false,
      }) {
    return RadioListTile<PrivacyStatus>(
      value: value,
      groupValue: currentStatus,
      activeColor: Colors.grey,
      onChanged: (selectedValue) async {
        setState(() {
          currentStatus = selectedValue!;
        });

        List<String>? selectedUserIds;

        if (showUserDialog) {
          selectedUserIds = await showSearchUserDialog(context);

          log("Users selected for $value: $selectedUserIds");
        }

        onChoose(currentStatus, selectedUserIds);

        Navigator.pop(context);
      },
      title: Label(text: title),
    );
  }

  Future<List<String>?> showSearchUserDialog(BuildContext context) async {
    List<String> selectedUserIds = [];

    return await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider(
          create: (_) => serviceLocator<PrivacyCubit>(),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Search Users",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          context.read<PrivacyCubit>().searchRestaurant(value);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: BlocBuilder<PrivacyCubit, PrivacyState>(
                        builder: (context, state) {
                          if (state.status == PrivacyStates.loading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (state.status == PrivacyStates.error) {
                            return const Center(child: Text("Error fetching users"));
                          }
                          if (state.searchUsers == null || state.searchUsers!.isEmpty) {
                            return const Center(child: Text("No users found"));
                          }

                          return ListView.builder(
                            itemCount: state.searchUsers!.length,
                            itemBuilder: (context, index) {
                              final user = state.searchUsers![index];
                              final isSelected = selectedUserIds.contains(user.id);

                              return ListTile(
                                title: Text(user.firstName!),
                                subtitle: Text(user.lastName!),
                                trailing: Icon(
                                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                                  color: isSelected ? Colors.blue : null,
                                ),
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedUserIds.remove(user.id);
                                    } else {
                                      selectedUserIds.add(user.id!);
                                    }
                                  });
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        log("Final Selected Users: ${selectedUserIds}");
                        Navigator.pop(context, selectedUserIds);
                      },
                      child: const Text("Confirm Selection"),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  PrivacyStatus privacyToPrivacyStatus(String privacy) {
    switch (privacy) {
      case 'only-me':
        return PrivacyStatus.onlyMe;
      case 'public':
        return PrivacyStatus.public;
      case 'friends':
        return PrivacyStatus.friends;
      case 'followers':
        return PrivacyStatus.followers;
      case 'friends-and-followers':
        return PrivacyStatus.friendsAndFollowers;
      case 'contacts':
        return PrivacyStatus.contacts;
      case 'only-with':
        return PrivacyStatus.onlyWith;
      case 'except-from':
        return PrivacyStatus.exceptFrom;
      default:
        return PrivacyStatus.public;
    }
  }

  String getPrivacyName(PrivacyStatus status) {
    switch (status) {
      case PrivacyStatus.onlyMe:
        return LocaleKeys.onlyMe.localize;
        case PrivacyStatus.exceptFrom:
        return LocaleKeys.except_from.localize;
      case PrivacyStatus.public:
        return LocaleKeys.public.localize;
      case PrivacyStatus.friends:
        return LocaleKeys.friends.localize;
      case PrivacyStatus.followers:
        return LocaleKeys.followers.localize;
      case PrivacyStatus.friendsAndFollowers:
        return '${LocaleKeys.friends.localize} / ${LocaleKeys.followers.localize}';
      case PrivacyStatus.exceptFrom:
        return LocaleKeys.except_from.localize;
      case PrivacyStatus.onlyWith:
        return LocaleKeys.only_with.localize;
      case PrivacyStatus.contacts:
        return LocaleKeys.contacts.localize;
    }
  }

  IconData getPrivacyIcon(PrivacyStatus status) {
    switch (status) {
      case PrivacyStatus.onlyMe:
        return Icons.lock;
      case PrivacyStatus.public:
        return Icons.language;
      case PrivacyStatus.friends:
        return Icons.family_restroom;
      case PrivacyStatus.followers:
        return Icons.accessibility_sharp;
      case PrivacyStatus.friendsAndFollowers:
        return Icons.supervised_user_circle_outlined;
      case PrivacyStatus.exceptFrom:
        return Icons.supervised_user_circle_outlined;
      case PrivacyStatus.onlyWith:
        return Icons.supervised_user_circle_outlined;
      case PrivacyStatus.contacts:
        return Icons.supervised_user_circle_outlined;
    }
  }
}

