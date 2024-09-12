// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
//
// import '../cubit/stories_cubit.dart';
//
// class StatusPrivacyScreen extends StatefulWidget {
//   @override
//   _StatusPrivacyScreenState createState() => _StatusPrivacyScreenState();
// }
//
// class _StatusPrivacyScreenState extends State<StatusPrivacyScreen> {
//   String _selectedPrivacyOption = 'My contacts';
//   List<String> _selectedContacts = [];
//
//   final List<String> _allContacts = [
//     'John Doe',
//     'Jane Smith',
//     'Jane ',
//     '1 Smith',
//     'Jane Smith',
//     'Bob Johnson',
//     'Alice Brown',
//     'Charlie Davis',
//     'Eva Green',
//     'Frank White'
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Status Privacy',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: AppColors.PRIMARY_COLOR,
//         actions: [
//           IconButton(
//             icon: const Icon(
//               FontAwesomeIcons.check,
//               color: Colors.white70,
//             ),
//             onPressed: () {
//               // context
//               //     .read<StoryCubit>()
//               //     .updateStoryPrivacy('followers', users: []);
//               for (var element in _selectedContacts) {
//                 log(element.toString());
//               }
//             },
//           ),
//           IconButton(
//             icon: const Icon(
//               Icons.info_outline,
//               color: Colors.white70,
//             ),
//             onPressed: _showHelpDialog,
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                 child: IntrinsicHeight(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildPrivacyOptionsSection(),
//                         const SizedBox(height: 20),
//                         _buildContactSelector(),
//                         const Spacer(),
//                         const Divider(),
//                         _buildShareAcrossAccountsSection(),
//                         const Spacer(),
//                         _buildFooterMessage(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPrivacyOptionsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Who can see my status updates',
//           style: Theme.of(context).textTheme.headline6,
//         ),
//         const SizedBox(height: 16),
//         ..._buildPrivacyOptions(),
//       ],
//     );
//   }
//
//   List<Widget> _buildPrivacyOptions() {
//     return ['My contacts', 'My contacts except...', 'Only share with...']
//         .map((option) => _buildPrivacyOption(option))
//         .toList();
//   }
//
//   Widget _buildPrivacyOption(String title) {
//     int? exclusionCount =
//         _selectedPrivacyOption == title ? _selectedContacts.length : null;
//     return Card(
//       child: RadioListTile<String>(
//         title: Text(title),
//         subtitle: exclusionCount != null &&
//                 _selectedPrivacyOption != 'My contacts'
//             ? Text(
//                 '${exclusionCount == 1 ? '1 contact' : '$exclusionCount contacts'} selected')
//             : null,
//         value: title,
//         groupValue: _selectedPrivacyOption,
//         onChanged: (String? value) {
//           setState(() => _selectedPrivacyOption = value!);
//         },
//       ),
//     );
//   }
//
//   Widget _buildContactSelector() {
//     return Visibility(
//       visible: _selectedPrivacyOption != 'My contacts',
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Select Contacts:',
//             style: Theme.of(context).textTheme.subtitle1,
//           ),
//           const SizedBox(height: 8),
//           Container(
//             height: 200, // Set a fixed height or use a more responsive approach
//             child: ListView.builder(
//               itemCount: _allContacts.length,
//               itemBuilder: (context, index) {
//                 return _buildContactListTile(_allContacts[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContactListTile(String contact) {
//     bool isSelected = _selectedContacts.contains(contact);
//     return CheckboxListTile(
//       title: Text(contact),
//       value: isSelected,
//       onChanged: (bool? value) {
//         setState(() {
//           if (value == true) {
//             _selectedContacts.add(contact);
//           } else {
//             _selectedContacts.remove(contact);
//           }
//         });
//       },
//     );
//   }
//
//   Widget _buildShareAcrossAccountsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Share my status updates across my accounts',
//           style: Theme.of(context).textTheme.subtitle1,
//         ),
//         const SizedBox(height: 8),
//         _buildFacebookLink(),
//       ],
//     );
//   }
//
//   Widget _buildFacebookLink() {
//     return Card(
//       child: ListTile(
//         leading: const Icon(Icons.facebook, color: Colors.blue),
//         title: const Text('Mostafa '),
//         subtitle: const Text('Facebook'),
//         trailing: const Icon(Icons.link),
//         onTap: () {
//           // Handle linking logic
//         },
//       ),
//     );
//   }
//
//   Widget _buildFooterMessage() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: Text(
//         "Changes to your privacy settings will affect all of your statuses.",
//         style: Theme.of(context).textTheme.caption,
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
//
//   void _showHelpDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Privacy Settings Help'),
//         content: const SingleChildScrollView(
//           child: ListBody(
//             children: [
//               Text('Choose who can see your status updates:'),
//               SizedBox(height: 8),
//               Text('• My contacts: All your contacts can see your status.'),
//               Text(
//                   '• My contacts except...: Select contacts who won\'t see your status.'),
//               Text(
//                   '• Only share with...: Choose specific contacts to share your status.'),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../data/models/followers_model.dart';
import '../cubit/stories_cubit.dart';

class StatusPrivacyScreen extends StatefulWidget {
  @override
  _StatusPrivacyScreenState createState() => _StatusPrivacyScreenState();
}

class _StatusPrivacyScreenState extends State<StatusPrivacyScreen> {
  String _selectedPrivacyOption = 'My contacts';
  List<String> _selectedContacts = [];

  final List<String> _allContacts = [
    'John Doe',
    'Jane Smith',
    'Jane ',
    '1 Smith',
    'Jane Smith',
    'Bob Johnson',
    'Alice Brown',
    'Charlie Davis',
    'Eva Green',
    'Frank White'
  ];

  @override
  void initState() {
    // TODO: implement initState
    context.read<StoryCubit>().fetchFollowers();
    super.initState();
  }

  String? getPrivacyOption(String option) {
    if (option == 'My contacts') return 'followers';
    if (option == 'My contacts except...') return 'except';
    if (option == 'Only share with...') return 'only-with';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Status Privacy',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.PRIMARY_COLOR,
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.check,
              color: Colors.white70,
            ),
            onPressed: () {
              log(_selectedPrivacyOption.toString());

              _selectedContacts.forEach((element) {
                log(element.toString());
              });

              log(getPrivacyOption(_selectedPrivacyOption)!.toString());


              context
                  .read<StoryCubit>()
                  .updateStoryPrivacy(getPrivacyOption(_selectedPrivacyOption)!,
                      users: _selectedContacts)
                  .then((value) => Navigator.pop(context));
              for (var element in _selectedContacts) {
                log(element.toString());
              }
              log(serviceLocator<UserCubit>().state.data!.id.toString());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.size.width * 0.05,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPrivacyOptionsSection(isLargeScreen),
                        SizedBox(height: mediaQuery.size.height * 0.03),
                        _buildContactSelector(mediaQuery),
                        const Divider(),
                        const Spacer(),
                        _buildFooterMessage(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPrivacyOptionsSection(bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Who can see my status updates',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: isLargeScreen ? 24 : 18,
              ),
        ),
        const SizedBox(height: 16),
        ..._buildPrivacyOptions(),
      ],
    );
  }

  List<Widget> _buildPrivacyOptions() {
    return ['My contacts', 'My contacts except...', 'Only share with...']
        .map((option) => _buildPrivacyOption(option))
        .toList();
  }

  Widget _buildPrivacyOption(String title) {
    int? exclusionCount =
        _selectedPrivacyOption == title ? _selectedContacts.length : null;
    return Card(
      child: RadioListTile<String>(
        title: Text(title),
        subtitle: exclusionCount != null &&
                _selectedPrivacyOption != 'My contacts'
            ? Text(
                '${exclusionCount == 1 ? '1 contact' : '$exclusionCount contacts'} selected')
            : null,
        value: title,
        groupValue: _selectedPrivacyOption,
        onChanged: (String? value) {
          setState(() => _selectedPrivacyOption = value!);
        },
      ),
    );
  }

  Widget _buildContactSelector(MediaQueryData mediaQuery) {
    final isLargeScreen = mediaQuery.size.width > 600;

    return Visibility(
      visible: _selectedPrivacyOption != 'My contacts',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Contacts:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: isLargeScreen ? 20 : 16,
                ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<StoryCubit, StoryState>(
            builder: (context, state) {
              return SizedBox(
                height: mediaQuery.size.height * 0.3,
                // Adjust height dynamically
                child: ListView.builder(
                  itemCount: state.followers.length,
                  itemBuilder: (context, index) {
                    return _buildContactListTile(state.followers[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactListTile(Follower contact) {
    bool isSelected =
        _selectedContacts.contains(contact.followerId.id.toString());
    return CheckboxListTile(
      title: Text(capitalizeAndSplit2Only(
          "${contact.followerId.firstName} ${contact.followerId.lastName}")),
      value: isSelected,
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            log("a");
            _selectedContacts.add(contact.followerId.id.toString());
          } else {
            log("b");
            _selectedContacts.remove(contact.followerId.id.toString());
          }
        });
      },
    );
  }

  Widget _buildFooterMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Flexible(
            child: Text(
              "Changes to your privacy settings will affect all of your statuses.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 12,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: Colors.black,
            ),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Settings Help'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: [
              Text('Choose who can see your status updates:'),
              SizedBox(height: 8),
              Text('• My contacts: All your contacts can see your status.'),
              Text(
                  '• My contacts except...: Select contacts who won\'t see your status.'),
              Text(
                  '• Only share with...: Choose specific contacts to share your status.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
