// import 'dart:developer';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:fourtyninehub/core/localization/locale_keys.g.dart'; // Import localization keys
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import '../../../tinder/data/shared/shared.dart';
// import '../../data/models/followers_model.dart';
// import '../cubit/stories_cubit.dart';

// class StatusPrivacyScreen extends StatefulWidget {
//   const StatusPrivacyScreen({super.key});

//   @override
//   _StatusPrivacyScreenState createState() => _StatusPrivacyScreenState();
// }

// class _StatusPrivacyScreenState extends State<StatusPrivacyScreen> {
//   String _selectedPrivacyOption =
//       LocaleKeys.my_contacts.tr(); // Localized string
//   final Set<String> _excludedContacts = {};
//   final Set<String> _includedContacts = {};

//   late List<String> _privacyOptions;

//   @override
//   void initState() {
//     super.initState();

//     context.read<StoryCubit>().fetchFollowers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     _privacyOptions = [
//       LocaleKeys.my_contacts.tr(),
//       LocaleKeys.my_contacts_except.tr(),
//       LocaleKeys.only_share_with.tr(),
//       context.isArabic ? 'الأصدقاء' : 'Friends',
//       context.isArabic ? 'الأصدقاء والمتابعين' : 'Friends and followers',
//       context.isArabic ? 'عام' : 'Public',
//     ];
//     return CustomScaffold(
//       appBar: AppBar(
//         title: Text(
//           context.isArabic ? 'خصوصية الحالة' : 'Story Privacy',
//           style: const TextStyle(color: Colors.white),
//         ), // Localized string
//         backgroundColor: AppColors.PRIMARY_COLOR,
//         foregroundColor: Colors.white,
//         // actions: [
//         //   IconButton(
//         //     icon: const Icon(
//         //       FontAwesomeIcons.check,
//         //       color: Colors.white,
//         //     ),
//         //     onPressed: _onSavePrivacySettings,
//         //   ),
//         // ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               _buildPrivacyOptionsSection(),
//               const SizedBox(height: 16.0),
//               const Spacer(),
//               const SizedBox(height: 16.0),
//               _buildFooterMessage(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String? getPrivacyOption(String option) {
//     if (option == LocaleKeys.my_contacts.tr()) return 'followers';
//     if (option == LocaleKeys.my_contacts_except.tr()) return 'friends-except';
//     if (option == LocaleKeys.only_share_with.tr()) return 'only-with';
//     if (option == (context.isArabic ? 'الأصدقاء' : 'Friends')) return 'friends';
//     if (option ==
//         (context.isArabic ? 'الأصدقاء والمتابعين' : 'Friends and followers')) {
//       return 'friends/followers';
//     }
//     if (option == (context.isArabic ? 'عام' : 'Public')) return 'public';
//     return null;
//   }

//   _onSavePrivacySettings() async {
//     log(_selectedPrivacyOption);

//     for (var contact
//         in _selectedPrivacyOption == LocaleKeys.my_contacts_except.tr()
//             ? _excludedContacts
//             : _includedContacts) {
//       log(contact);
//     }

//     final privacyOption = getPrivacyOption(_selectedPrivacyOption);
//     if (privacyOption != null) {
//       await context.read<StoryCubit>().updateStoryPrivacy(
//             privacyOption,
//             users: _selectedPrivacyOption == LocaleKeys.my_contacts_except.tr()
//                 ? _excludedContacts.toList()
//                 : _selectedPrivacyOption == LocaleKeys.only_share_with.tr()
//                     ? _includedContacts.toList()
//                     : null,
//           );
//       // Navigator.pop(context);
//     }
//   }

//   Widget _buildPrivacyOptionsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           LocaleKeys.who_can_see_status.tr(), // Localized string
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//         ),
//         const SizedBox(height: 16.0),
//         ..._privacyOptions.map((option) => _buildPrivacyOption(option)),
//       ],
//     );
//   }

//   Widget _buildPrivacyOption(String title) {
//     int count = 0;
//     String label = '';
//     if (title == LocaleKeys.my_contacts_except.tr()) {
//       count = _excludedContacts.length;
//       label = context.isArabic ? 'مستبعد' : 'excluded';
//     } else if (title == LocaleKeys.only_share_with.tr()) {
//       count = _includedContacts.length;
//       label = context.isArabic ? 'متضمن' : 'included';
//     }

//     return RadioListTile<String>(
//       contentPadding: const EdgeInsets.all(0),
//       activeColor: AppColors.PRIMARY_COLOR_DARK,
//       title: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(title),
//           if (count > 0)
//             GestureDetector(
//               onTap: () => _showContactSelectorBottomSheet(
//                 title,
//                 context.read<StoryCubit>(),
//                 () {
//                   // Refresh the state of the parent widget
//                   setState(() {});
//                 },
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Text(
//                   '$count $label',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.PRIMARY_COLOR_DARK,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       value: title,
//       groupValue: _selectedPrivacyOption,
//       onChanged: (String? value) async {
//         setState(() {
//           _selectedPrivacyOption = value!;
//           if (_selectedPrivacyOption == LocaleKeys.my_contacts.tr()) {
//             // _excludedContacts.clear();
//             // _includedContacts.clear();
//           }
//         });
//         if (_selectedPrivacyOption != LocaleKeys.my_contacts.tr()) {
//           if (_selectedPrivacyOption == LocaleKeys.only_share_with.tr() &&
//               _includedContacts.isEmpty) {
//             _showContactSelectorBottomSheet(
//               title,
//               context.read<StoryCubit>(),
//               () {
//                 // Refresh the state of the parent widget
//                 setState(() {});
//               },
//             );
//           } else if (_selectedPrivacyOption ==
//                   LocaleKeys.my_contacts_except.tr() &&
//               _excludedContacts.isEmpty) {
//             _showContactSelectorBottomSheet(
//               title,
//               context.read<StoryCubit>(),
//               () {
//                 // Refresh the state of the parent widget
//                 setState(() {});
//               },
//             );
//           }
//         }
//         await _onSavePrivacySettings();
//       },
//     );
//   }

//   void _showContactSelectorBottomSheet(
//       String title, StoryCubit storyCubit, VoidCallback onContactsUpdated) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
//       ),
//       builder: (BuildContext context) {
//         return BlocProvider.value(
//           value: storyCubit,
//           child: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: storyCubit.state.followers.length,
//                       itemBuilder: (context, index) {
//                         final contact = storyCubit.state.followers[index];
//                         final isSelected =
//                             title == LocaleKeys.my_contacts_except.tr()
//                                 ? _excludedContacts
//                                     .contains(contact.followerId.id.toString())
//                                 : _includedContacts
//                                     .contains(contact.followerId.id.toString());

//                         return CheckboxListTile(
//                           title: Text(
//                             capitalizeAndSplit2Only(
//                                 "${contact.followerId.firstName} ${contact.followerId.lastName}"),
//                           ),
//                           value: isSelected,
//                           onChanged: (bool? value) {
//                             setState(() {
//                               if (title == LocaleKeys.my_contacts_except.tr()) {
//                                 if (value == true) {
//                                   _excludedContacts
//                                       .add(contact.followerId.id.toString());
//                                 } else {
//                                   _excludedContacts
//                                       .remove(contact.followerId.id.toString());
//                                 }
//                               } else if (title ==
//                                   LocaleKeys.only_share_with.tr()) {
//                                 if (value == true) {
//                                   _includedContacts
//                                       .add(contact.followerId.id.toString());
//                                 } else {
//                                   _includedContacts
//                                       .remove(contact.followerId.id.toString());
//                                 }
//                               }
//                             });
//                             // Call the callback to refresh the parent screen
//                             onContactsUpdated();
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       await _onSavePrivacySettings();
//                       Navigator.pop(context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.PRIMARY_COLOR,
//                     ),
//                     child: Text(
//                       LocaleKeys.done.tr(),
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFooterMessage() {
//     return Column(
//       children: [
//         const Divider(),
//         const SizedBox(height: 8.0),
//         Row(
//           children: [
//             Expanded(
//               child: Text(
//                 LocaleKeys.privacy_settings_info.tr(), // Localized string
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../tinder/data/shared/shared.dart';
import '../cubit/stories_cubit.dart';

class StatusPrivacyScreen extends StatefulWidget {
  const StatusPrivacyScreen({super.key});

  @override
  _StatusPrivacyScreenState createState() => _StatusPrivacyScreenState();
}

class _StatusPrivacyScreenState extends State<StatusPrivacyScreen> {
  String _selectedPrivacyOption =
      LocaleKeys.my_contacts.tr(); // Localized string
  final Set<String> _excludedContacts = {};
  final Set<String> _includedContacts = {};

  late List<String> _privacyOptions;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings(); // Load cached settings
    context.read<StoryCubit>().fetchFollowers();
  }

  // Load cached privacy settings from SharedPreferences
  _loadPrivacySettings() async {
    final prefs = await SharedPreferences.getInstance();

    final cachedPrivacyOption =
        prefs.getString('selectedPrivacyOption') ?? LocaleKeys.my_contacts.tr();
    setState(() {
      _selectedPrivacyOption = cachedPrivacyOption;
    });

    final cachedExcludedContacts =
        prefs.getStringList('excludedContacts') ?? [];
    final cachedIncludedContacts =
        prefs.getStringList('includedContacts') ?? [];

    setState(() {
      _excludedContacts.addAll(cachedExcludedContacts);
      _includedContacts.addAll(cachedIncludedContacts);
    });
  }

  // Save the current privacy settings to SharedPreferences
  _savePrivacySettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('selectedPrivacyOption', _selectedPrivacyOption);
    await prefs.setStringList('excludedContacts', _excludedContacts.toList());
    await prefs.setStringList('includedContacts', _includedContacts.toList());
  }

  @override
  Widget build(BuildContext context) {
    _privacyOptions = [
      LocaleKeys.my_contacts.tr(),
      LocaleKeys.my_contacts_except.tr(),
      LocaleKeys.only_share_with.tr(),
      context.isArabic ? 'الأصدقاء' : 'Friends',
      context.isArabic ? 'الأصدقاء والمتابعين' : 'Friends and followers',
      context.isArabic ? 'عام' : 'Public',
    ];
    return CustomScaffold(
      appBar: AppBar(
        title: Text(
          context.isArabic ? 'خصوصية الحالة' : 'Story Privacy',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.PRIMARY_COLOR,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildPrivacyOptionsSection(),
                const SizedBox(height: 16.0),
                // const Spacer(),
                const SizedBox(height: 16.0),
                _buildFooterMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? getPrivacyOption(String option) {
    if (option == LocaleKeys.my_contacts.tr()) return 'followers';
    if (option == LocaleKeys.my_contacts_except.tr()) return 'friends-except';
    if (option == LocaleKeys.only_share_with.tr()) return 'only-with';
    if (option == (context.isArabic ? 'الأصدقاء' : 'Friends')) return 'friends';
    if (option ==
        (context.isArabic ? 'الأصدقاء والمتابعين' : 'Friends and followers')) {
      return 'friends/followers';
    }
    if (option == (context.isArabic ? 'عام' : 'Public')) return 'public';
    return null;
  }

  _onSavePrivacySettings() async {
    log(_selectedPrivacyOption);

    for (var contact
        in _selectedPrivacyOption == LocaleKeys.my_contacts_except.tr()
            ? _excludedContacts
            : _includedContacts) {
      log(contact);
    }

    final privacyOption = getPrivacyOption(_selectedPrivacyOption);
    if (privacyOption != null) {
      await context.read<StoryCubit>().updateStoryPrivacy(
            privacyOption,
            users: _selectedPrivacyOption == LocaleKeys.my_contacts_except.tr()
                ? _excludedContacts.toList()
                : _selectedPrivacyOption == LocaleKeys.only_share_with.tr()
                    ? _includedContacts.toList()
                    : null,
          );
      await _savePrivacySettings(); // Save privacy settings after update
    }
  }

  Widget _buildPrivacyOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.who_can_see_status.tr(), // Localized string
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16.0),
        ..._privacyOptions.map((option) => _buildPrivacyOption(option)),
      ],
    );
  }

  Widget _buildPrivacyOption(String title) {
    int count = 0;
    String label = '';
    if (title == LocaleKeys.my_contacts_except.tr()) {
      count = _excludedContacts.length;
      label = context.isArabic ? 'مستبعد' : 'excluded';
    } else if (title == LocaleKeys.only_share_with.tr()) {
      count = _includedContacts.length;
      label = context.isArabic ? 'متضمن' : 'included';
    }

    return RadioListTile<String>(
      contentPadding: const EdgeInsets.all(0),
      // activeColor: AppColors.PRIMARY_COLOR_DARK,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          if (count > 0)
            GestureDetector(
              onTap: () => _showContactSelectorBottomSheet(
                title,
                context.read<StoryCubit>(),
                () {
                  // Refresh the state of the parent widget
                  setState(() {});
                },
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '$count $label',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.PRIMARY_COLOR_DARK,
                  ),
                ),
              ),
            ),
        ],
      ),
      value: title,
      groupValue: _selectedPrivacyOption,
      onChanged: (String? value) async {
        setState(() {
          _selectedPrivacyOption = value!;
          if (_selectedPrivacyOption == LocaleKeys.my_contacts.tr()) {
            // _excludedContacts.clear();
            // _includedContacts.clear();
          }
        });
        if (_selectedPrivacyOption != LocaleKeys.my_contacts.tr()) {
          if (_selectedPrivacyOption == LocaleKeys.only_share_with.tr() &&
              _includedContacts.isEmpty) {
            _showContactSelectorBottomSheet(
              title,
              context.read<StoryCubit>(),
              () {
                // Refresh the state of the parent widget
                setState(() {});
              },
            );
          } else if (_selectedPrivacyOption ==
                  LocaleKeys.my_contacts_except.tr() &&
              _excludedContacts.isEmpty) {
            _showContactSelectorBottomSheet(
              title,
              context.read<StoryCubit>(),
              () {
                // Refresh the state of the parent widget
                setState(() {});
              },
            );
          }
        }
        await _onSavePrivacySettings();
      },
    );
  }

  // void _showContactSelectorBottomSheet(
  //     String title, StoryCubit storyCubit, VoidCallback onContactsUpdated) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
  //     ),
  //     builder: (BuildContext context) {
  //       return BlocProvider.value(
  //         value: storyCubit,
  //         child: StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return Column(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(16.0),
  //                   child: Text(
  //                     title,
  //                     style: const TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: ListView.builder(
  //                     itemCount: storyCubit.state.followers.length,
  //                     itemBuilder: (context, index) {
  //                       final contact = storyCubit.state.followers[index];
  //                       final isSelected =
  //                           title == LocaleKeys.my_contacts_except.tr()
  //                               ? _excludedContacts
  //                                   .contains(contact.followerId.id.toString())
  //                               : _includedContacts
  //                                   .contains(contact.followerId.id.toString());

  //                       return CheckboxListTile(
  //                         title: Text(
  //                           capitalizeAndSplit2Only(
  //                               "${contact.followerId.firstName} ${contact.followerId.lastName}"),
  //                         ),
  //                         value: isSelected,
  //                         onChanged: (bool? value) {
  //                           setState(() {
  //                             if (title == LocaleKeys.my_contacts_except.tr()) {
  //                               if (value == true) {
  //                                 _excludedContacts
  //                                     .add(contact.followerId.id.toString());
  //                               } else {
  //                                 _excludedContacts
  //                                     .remove(contact.followerId.id.toString());
  //                               }
  //                             } else if (title ==
  //                                 LocaleKeys.only_share_with.tr()) {
  //                               if (value == true) {
  //                                 _includedContacts
  //                                     .add(contact.followerId.id.toString());
  //                               } else {
  //                                 _includedContacts
  //                                     .remove(contact.followerId.id.toString());
  //                               }
  //                             }
  //                           });
  //                           // Call the callback to refresh the parent screen
  //                           onContactsUpdated();
  //                         },
  //                       );
  //                     },
  //                   ),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () async {
  //                     await _onSavePrivacySettings();
  //                     Navigator.pop(context);
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: AppColors.PRIMARY_COLOR,
  //                   ),
  //                   child: Text(
  //                     LocaleKeys.done.tr(),
  //                     style: const TextStyle(color: Colors.white),
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showContactSelectorBottomSheet(
      String title, StoryCubit storyCubit, VoidCallback onContactsUpdated) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: storyCubit,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: storyCubit.state.followers.length,
                      itemBuilder: (context, index) {
                        final contact = storyCubit.state.followers[index];
                        final isSelected =
                            title == LocaleKeys.my_contacts_except.tr()
                                ? _excludedContacts
                                    .contains(contact.followerId.id.toString())
                                : _includedContacts
                                    .contains(contact.followerId.id.toString());

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (title == LocaleKeys.my_contacts_except.tr()) {
                                if (isSelected) {
                                  _excludedContacts
                                      .remove(contact.followerId.id.toString());
                                } else {
                                  _excludedContacts
                                      .add(contact.followerId.id.toString());
                                }
                              } else if (title ==
                                  LocaleKeys.only_share_with.tr()) {
                                if (isSelected) {
                                  _includedContacts
                                      .remove(contact.followerId.id.toString());
                                } else {
                                  _includedContacts
                                      .add(contact.followerId.id.toString());
                                }
                              }
                            });
                            // تحديث الشاشة الرئيسية
                            onContactsUpdated();
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // صورة المستخدم
                                CircleAvatar(
                                  radius: 24.0,
                                  backgroundImage: NetworkImage(
                                    contact.followerId.image ??
                                        UIConst.profilePlaceHolder,
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                // اسم المستخدم
                                Expanded(
                                  child: Text(
                                    capitalizeAndSplit2Only(
                                        "${contact.followerId.firstName} ${contact.followerId.lastName}"),
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                // الدائرة لتحديد الحالة
                                Container(
                                  height: 24.0,
                                  width: 24.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          isSelected ? Colors.red : Colors.grey,
                                      width: 2.0,
                                    ),
                                    color:
                                        isSelected ? Colors.red : Colors.white,
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16.0,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _onSavePrivacySettings();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.PRIMARY_COLOR,
                    ),
                    child: Text(
                      LocaleKeys.done.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFooterMessage() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: Text(
                LocaleKeys.privacy_settings_info.tr(), // Localized string
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
