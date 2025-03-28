import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../domain/entities/privacy_status_enum.dart';
import '../../domain/useCase/remove_allowed_use_case.dart';
import '../cubit/privacy_cubit.dart';
import '../cubit/privacy_state.dart';



class PrivacyMultiSelectItem extends StatefulWidget {
  final String label;
  final String privacy;
  final Function(PrivacyStatus value, List<String>? selectedUsers) onChoose;
  final bool isFriendEnable;
  final String? name;

  const PrivacyMultiSelectItem({
    super.key,
    required this.label,
    required this.privacy,
    required this.onChoose,
    this.isFriendEnable = true,
    this.name
  });

  @override
  State<PrivacyMultiSelectItem> createState() => _PrivacyMultiSelectItemState();
}

class _PrivacyMultiSelectItemState extends State<PrivacyMultiSelectItem> {
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
            PrivacyStatus currentStatus = privacyToPrivacyStatus(widget.privacy);

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
                        Label(text: 'Here ${widget.privacy}'),
                        Label(text: 'Here ${widget.name}'),

                        Label(text: 'Who Can See My ${widget.label}'),
                        _buildPrivacyOption(context, setState, title: 'Public', value: PrivacyStatus.public, currentStatus: currentStatus),
                        _buildPrivacyOption(context, setState, title: 'Friends', value: PrivacyStatus.friends, currentStatus: currentStatus),
                        _buildPrivacyOption(context, setState, title: 'Contacts', value: PrivacyStatus.contacts, currentStatus: currentStatus),
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
                selectedUsers = await showSearchUserDialog(context, name: widget.name!,);
                log("Selected Users for $selectedStatus: ${selectedUsers?.join(", ")}");
              }

              widget.onChoose(selectedStatus, selectedUsers);
            }
          },

          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Label(text: widget.label),
              ),
              Row(
                children: [
                  Label(text: getPrivacyName(privacyToPrivacyStatus(widget.privacy))),
                  const SizedBox(width: 10),
                  Icon(getPrivacyIcon(privacyToPrivacyStatus(widget.privacy)), color: Colors.grey),
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
        // Use a local variable for currentStatus to avoid mutation
        PrivacyStatus newStatus = selectedValue!;

        setState(() {
          // Update the local status in state
          currentStatus = newStatus;
        });

        List<String>? selectedUserIds;

        if (showUserDialog) {
          selectedUserIds = await showSearchUserDialog(context, name: widget.name!,);

          log("Users selected for $newStatus: $selectedUserIds");
        }

        widget.onChoose(newStatus, selectedUserIds);

        Navigator.pop(context);
      },
      title: Label(text: title),
    );
  }


  Future<List<String>?> showSearchUserDialog(BuildContext context, {required String name}) async {
    final selectedUserIds = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => serviceLocator<PrivacyCubit>(),
          child: UserSelectionScreen(name: name),
        ),
      ),
    );

    return selectedUserIds;
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

class UserSelectionScreen extends StatefulWidget {
  final String name;

  const UserSelectionScreen({Key? key, required this.name}) : super(key: key);

  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  List<String> selectedUserIds = [];
  String searchQuery = '';
  bool showAllowed = false;
  bool showForbidden = false;

  @override
  void initState() {
    super.initState();
    context.read<PrivacyCubit>().fetchExclusionData(feature: widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Users"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildToggleButton("Show Allowed", showAllowed, () {
                  setState(() {
                    if (showForbidden) {
                      selectedUserIds.clear();
                      showForbidden = false;
                    }
                    showAllowed = !showAllowed;
                  });
                }),
                _buildToggleButton("Show Forbidden", showForbidden, () {
                  setState(() {
                    if (showAllowed) {
                      selectedUserIds.clear();
                      showAllowed = false;
                    }
                    showForbidden = !showForbidden;
                  });
                }),
              ],
            ),
            const SizedBox(height: 16),

            if (showAllowed || showForbidden)
              Expanded(
                flex: 2,
                child: _buildUserList(showAllowed ? "allowed" : "forbidden"),
              ),

            // Search Field
            TextField(
              onTap: (){
                setState(() {

                  showAllowed = false;
                  showForbidden = false;
                  selectedUserIds.clear();
                });
              },
              decoration: const InputDecoration(
                labelText: "Search Users",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  // Close the allowed and forbidden lists when searching
                  showAllowed = false;
                  showForbidden = false;
                  selectedUserIds.clear(); // Clear selected users when searching
                });
                if (value.isNotEmpty) {
                  context.read<PrivacyCubit>().searchRestaurant(value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Search Results
            Expanded(
              flex: 3,
              child: _buildSearchResults(),
            ),

            // Confirm Button

            AppButton(
              height: 60,
              color: AppColors.LIGHT_COLOR,
              backColor: context.isDarkMode ? AppColors.PRIMARY_COLOR_DARK : AppColors.PRIMARY_COLOR,
              onPressed: () {
                log("Selected User IDs: ${selectedUserIds}");
                Navigator.pop(context, selectedUserIds);
              },
              label: "Confirm Selection",

            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isActive ? Colors.blue.withOpacity(0.2) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.blue),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.blue : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUserList(String type) {
    return BlocBuilder<PrivacyCubit, PrivacyState>(
      builder: (context, state) {
        if (state.status == PrivacyStates.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == PrivacyStates.success) {
          final users = type == "allowed"
              ? state.exclusionEntity?.data?.allowedUsers ?? []
              : state.exclusionEntity?.data?.forbiddenUsers ?? [];

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final isSelected = selectedUserIds.contains(user.id);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedUserIds.remove(user.id);
                          } else {
                            selectedUserIds.add(user.id);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    user.profilePictureKey?.mediaKey ?? "",
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                if (isSelected)
                                  const Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.blue,
                                      size: 24,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${user.firstName} ${user.lastName}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (type == "forbidden")
                              const Icon(Icons.block, color: Colors.red),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (selectedUserIds.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 0,bottom: 10),
                  child: AppButton(
                    height: 60,
                    color: AppColors.LIGHT_COLOR,
                    backColor: AppColors.PRIMARY_COLOR_DARK,
                    onPressed: () {
                      final params = RemoveAllowedParams(
                        feature: widget.name,
                        targetUserIds: selectedUserIds,
                      );
                      context.read<PrivacyCubit>().removeAllowedData(params: params).then((_) {
                        context.read<PrivacyCubit>().fetchExclusionData(feature: widget.name);
                        setState(() {
                          selectedUserIds.clear();
                        });
                      });
                    },

                    label:"Remove Selected Users",
                  ),
                ),
            ],
          );
        }

        if (state.status == PrivacyStates.error) {
          return const Center(child: Text('An error occurred.'));
        }

        return const Center(child: Text('No data available.'));
      },
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<PrivacyCubit, PrivacyState>(
      builder: (context, state) {
        if (state.status == PrivacyStates.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == PrivacyStates.error) {
          return const Center(child: Text("Error fetching users"));
        }

        if (searchQuery.isNotEmpty && state.searchUsers != null) {
          final filteredUsers = state.searchUsers!.where((user) {
            final userName = '${user.firstName} ${user.lastName}'.toLowerCase();
            return userName.contains(searchQuery.toLowerCase());
          }).toList();

          if (filteredUsers.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          return ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              final isSelected = selectedUserIds.contains(user.id);

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.image != null ? NetworkImage(user.image!) : null,
                  child: user.image == null ? const Icon(Icons.person) : null,
                ),
                title: Text('${user.firstName} ${user.lastName}'),
                trailing: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? Colors.blue : Colors.grey,
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
        }

        return const SizedBox.shrink();
      },
    );
  }
}




