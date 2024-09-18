import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/use_case/transfer_money_use_case.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/presentation/cubit/transfer_money_cubit.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/presentation/cubit/transfer_money_state.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../domain/entities/user_transfer_money_entity.dart';

class TransferMoneyView extends StatefulWidget {
  const TransferMoneyView({super.key});

  @override
  State<TransferMoneyView> createState() => _TransferMoneyViewState();
}

class _TransferMoneyViewState extends State<TransferMoneyView> {
  var amountController = TextEditingController();
  var searchController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String? selectedUsername;
  bool showUserList = false;

  String capitalize(String name) {
    if (name.isEmpty) return '';
    return '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
  }

  bool isUsernameInFilteredUsers(String? username, List<UserTransferMoneyEntity>? filteredUsers) {
    if (username == null || filteredUsers == null) return false;
    return filteredUsers.any((user) => user.userName == username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.transferMoney.localize,
      ),
      body: BlocProvider<TransferMoneyCubit>(
        create: (BuildContext context) => serviceLocator()..loadData(),
        child: BlocConsumer<TransferMoneyCubit, TransferMoneyState>(
          listener: (BuildContext context, state) {
            if (state.status == StateStatus.success) {
              showSuccessMessage(
                  context, LocaleKeys.moneySuccessfully.localize);
            }
          },
          builder: (BuildContext context, state) {
            var users = state.users;
            var filteredUsers = users?.where((user) {
              String fullName =
                  '${capitalize(user.firstName)} ${capitalize(user.lastName)}';
              return fullName
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase());
            }).toList();

            return ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                    key: formKey,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormTextField(
                              textStyle: Styles.mediumText(
                                color:
                                Theme.of(context).scaffoldBackgroundColor,
                              ),
                              constraints: BoxConstraints(
                                maxHeight: 52.h,
                                minHeight: 52.h,
                              ),
                              fillColor: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(20.r),
                              style: TextStyle(
                                fontSize: 30.sp,
                                color:
                                Theme.of(context).scaffoldBackgroundColor,
                              ),
                              controller: searchController,
                              hint: 'Search...',
                              action: (value) {
                                setState(() {
                                  // Show the list when the search text is not empty
                                  showUserList = value.isNotEmpty;
                                });
                              },
                            ),
                            const Sizer(),
                            FormTextField(
                              textStyle: Styles.mediumText(
                                color:
                                Theme.of(context).scaffoldBackgroundColor,
                              ),
                              type: TextInputType.number,
                              constraints: BoxConstraints(
                                maxHeight: 52.h,
                                minHeight: 52.h,
                              ),
                              fillColor: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(20.r),
                              style: TextStyle(
                                fontSize: 30.sp,
                                color:
                                Theme.of(context).scaffoldBackgroundColor,
                              ),
                              controller: amountController,
                              hint: LocaleKeys.amount.localize,
                              action: (v) {},
                            ),
                            const Sizer(),
                            AppButton(
                              label: LocaleKeys.confirm.localize,
                              style: Styles.mediumText(
                                fontSize: 60.sp,
                                color: AppColors.AUTH_CONTAINER_COLOR,
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if (selectedUsername == null ||
                                      !isUsernameInFilteredUsers(
                                          selectedUsername, filteredUsers)) {
                                    // If no user is selected or the user is not in the filtered list
                                    showSuccessMessage(
                                        context,
                                        'User not found or not valid, please select a valid user');
                                  } else if (int.parse(amountController.text) <
                                      state.wallet!.realAmount!) {
                                    return showAreYouSure(
                                        title: LocaleKeys.alert.localize,
                                        subTitle:
                                        'Are you sure of transferring money?',
                                        action: () {
                                          context
                                              .read<TransferMoneyCubit>()
                                              .transferMoney(
                                            params: TransferMoneyParams(
                                              receiverUsername:
                                              selectedUsername!,
                                              amount: int.parse(
                                                  amountController.text),
                                            ),
                                          );
                                        },
                                        context: context);
                                  } else {
                                    showSuccessMessage(
                                      context,
                                      'Not enough money in wallet',
                                      color: AppColors.SECONDARY_COLOR,
                                    );
                                  }
                                }
                                // print(state.wallet?.realAmount);
                                // print(searchController.text);
                                // print(selectedUsername);
                              },
                            ),
                          ],
                        ),
                        if (showUserList && filteredUsers != null && filteredUsers.isNotEmpty)
                          Positioned(
                            top: 100.h,
                            left: 0,
                            right: 0,
                            child: Container(
                              width: double.infinity,
                              height: 300.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: ListView.builder(
                                itemCount: filteredUsers.length,
                                itemBuilder: (context, index) {
                                  var user = filteredUsers[index];
                                  String fullName =
                                      '${capitalize(user.firstName)} ${capitalize(user.lastName)}';
                                  return ListTile(
                                    title: Text(
                                      fullName,
                                      style: Styles.mediumText(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        searchController.text = fullName;
                                        selectedUsername = user.userName;
                                        showUserList = false;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

