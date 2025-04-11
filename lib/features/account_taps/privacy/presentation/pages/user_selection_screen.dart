import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/style/app_colors.dart';
import '../../domain/entities/privacy_status_enum.dart';
import '../../domain/useCase/remove_allowed_use_case.dart';
import '../cubit/privacy_cubit.dart';
import '../cubit/privacy_state.dart';

class UserSelectionScreen extends StatefulWidget {
  final String name;
  final PrivacyStatus status;

  const UserSelectionScreen(
      {super.key, required this.name, required this.status});

  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  List<String> selectedUserIds = [];
  String searchQuery = '';
  bool showAllowed = false;
  bool showForbidden = false;
  bool showSearch = false;

  @override
  void initState() {
    super.initState();
    context.read<PrivacyCubit>().fetchExclusionData(feature: widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.status.name == 'onlyWith'
            ? LocaleKeys.only_with.localize.split('.')[0]
            : LocaleKeys.except_from.localize.split('.')[0]),
        // centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedUserIds.clear();
                      showSearch = !showSearch;
                      showAllowed = false;
                      showForbidden = false;
                    });
                  },
                  child: const Icon(
                    Icons.search,
                    size: 30,
                  ),
                ),
                const Sizer(),
                Expanded(
                  child: _buildToggleButton("Show Allowed", showAllowed, () {
                    setState(() {
                      // if (showForbidden) {
                      //   selectedUserIds.clear();
                      //   showForbidden = false;
                      // }
                      selectedUserIds.clear();
                      showForbidden = false;
                      showAllowed = !showAllowed;
                      showSearch = false;
                    });
                  }),
                ),
                const Sizer(),
                Expanded(
                  child:
                      _buildToggleButton("Show Forbidden", showForbidden, () {
                    setState(() {
                      selectedUserIds.clear();
                      showForbidden = !showForbidden;
                      showAllowed = false;
                      showSearch = false;
                    });
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Search Field
            if (showSearch)
              TextField(
                decoration: InputDecoration(
                  labelText: LocaleKeys.search.localize,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    // Close the allowed and forbidden lists when searching
                    showAllowed = false;
                    showForbidden = false;
                    selectedUserIds
                        .clear(); // Clear selected users when searching
                  });
                  if (value.isNotEmpty) {
                    context.read<PrivacyCubit>().searchRestaurant(value);
                  }
                },
              ),
            const SizedBox(height: 16),
            // Search Results
            if (showSearch)
              Expanded(
                child: _buildSearchResults(),
              ),
            if (showAllowed || showForbidden)
              Expanded(
                child: _buildUserList(showAllowed ? "allowed" : "forbidden"),
              ),
            // Confirm Button
            if (!showSearch && !showAllowed && !showForbidden)
              Expanded(child: Container()),
            AppButton(
              height: 60,
              color: AppColors.LIGHT_COLOR,
              backColor: context.isDarkMode
                  ? AppColors.PRIMARY_COLOR_DARK
                  : AppColors.PRIMARY_COLOR,
              onPressed: () {
                log("Selected User IDs: $selectedUserIds");
                Navigator.pop(context, selectedUserIds);
              },
              label: "Confirm Selection",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(
      String text, bool isActive, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor:
            isActive ? AppColors.PRIMARY_COLOR : AppColors.BG_GRAY_COLOR,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: isActive
                  ? AppColors.SECONDARY_COLOR
                  : AppColors.PRIMARY_COLOR),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : AppColors.PRIMARY_COLOR,
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
                  scrollDirection: Axis.vertical,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final isSelected = selectedUserIds.contains(user.id);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: Image.network(
                                  user.profilePictureKey.mediaKey,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 64,
                                      height: 64,
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
                              const Sizer(),
                              Text(
                                "${user.firstName} ${user.lastName}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedUserIds.remove(user.id);
                                } else {
                                  selectedUserIds.add(user.id);
                                }
                              });
                            },
                            child: Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: isSelected
                                  ? AppColors.PRIMARY_COLOR
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (selectedUserIds.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 10),
                  child: AppButton(
                    height: 60,
                    color: AppColors.LIGHT_COLOR,
                    backColor: AppColors.PRIMARY_COLOR_DARK,
                    onPressed: () {
                      final params = RemoveAllowedParams(
                        feature: widget.name,
                        targetUserIds: selectedUserIds,
                      );
                      context
                          .read<PrivacyCubit>()
                          .removeAllowedData(params: params)
                          .then((_) {
                        context
                            .read<PrivacyCubit>()
                            .fetchExclusionData(feature: widget.name);
                        setState(() {
                          selectedUserIds.clear();
                        });
                      });
                    },
                    label: "Remove Selected Users",
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            user.image ?? '',
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 64,
                                height: 64,
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
                        const Sizer(),
                        Text(
                          "${user.firstName} ${user.lastName}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedUserIds.remove(user.id);
                          } else {
                            selectedUserIds.add(user.id!);
                          }
                        });
                      },
                      child: Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color:
                            isSelected ? AppColors.PRIMARY_COLOR : Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
              // return ListTile(
              //   leading: CircleAvatar(
              //     backgroundImage:
              //         user.image != null ? NetworkImage(user.image!) : null,
              //     child: user.image == null ? const Icon(Icons.person) : null,
              //   ),
              //   title: Text('${user.firstName} ${user.lastName}'),
              //   trailing: Icon(
              //     isSelected ? Icons.check_circle : Icons.circle_outlined,
              //     color: isSelected ? Colors.blue : Colors.grey,
              //   ),
              //   onTap: () {
              //     setState(() {
              //       if (isSelected) {
              //         selectedUserIds.remove(user.id);
              //       } else {
              //         selectedUserIds.add(user.id!);
              //       }
              //     });
              //   },
              // );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
