import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/debouncer.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/use_case/transfer_money_use_case.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/presentation/cubit/transfer_money_cubit.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/presentation/cubit/transfer_money_state.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/presentation/pages/transfer_money_success.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/form/text_fields/search_text_form_field.dart';
import '../../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../food_feature/create_restaurant/views/widgets/mneu/name/price_text_form_field.dart';
import '../../domain/entities/user_transfer_money_entity.dart';

class TransferMoneyView extends StatefulWidget {
  const TransferMoneyView({super.key});

  @override
  State<TransferMoneyView> createState() => _TransferMoneyViewState();
}

class _TransferMoneyViewState extends State<TransferMoneyView> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.transferMoney.localize,
        ),
      ),
      body: BlocProvider(
        create: (BuildContext context) =>
            serviceLocator<TransferMoneyCubit>()..loadData(),
        child: const TransferMoneyViewBody(),
      ),
    );
  }
}

class TransferMoneyViewBody extends StatefulWidget {
  const TransferMoneyViewBody({super.key});

  @override
  State<TransferMoneyViewBody> createState() => _TransferMoneyViewBodyState();
}

class _TransferMoneyViewBodyState extends State<TransferMoneyViewBody> {
  late final Debouncer _debounce;
  late final TextEditingController amountController;
  late final TextEditingController searchController;
  late final GlobalKey<FormState> formKey;
  final FocusNode _focusNode = FocusNode();
  // String? selectedUsername;
  // bool showUserList = false;

  String capitalize(String name) {
    if (name.isEmpty) return '';
    return '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
  }

  bool isUsernameInFilteredUsers(
      String? email, List<UserTransferMoneyEntity>? filteredUsers) {
    if (email == null || filteredUsers == null) return false;
    return filteredUsers.any((user) => user.email == email);
  }

  @override
  void initState() {
    _debounce = Debouncer();
    amountController = TextEditingController();
    searchController = TextEditingController();
    formKey = GlobalKey<FormState>();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focusNode.requestFocus());
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransferMoneyCubit, TransferMoneyState>(
      listener: (BuildContext context, state) {
        if (state.isTransferSuccess) {
          showSuccessMessage(context, LocaleKeys.moneySuccessfully.localize);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TransactionSuccessScreen(
                        dataEntity: state.dataTransfer!,
                      )));
          amountController.clear();
          searchController.clear();
          // setState(() {
          //   selectedUsername = null;
          // });
        }
        if (state.isFailure ||
            state.isTransferFailure ||
            state.isSearchUserFailure) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure!,
              context,
            ),
          );
        }
      },
      builder: (BuildContext context, state) {
        var users = state.users;
        var filteredUsers = users?.where((user) {
          return user.email
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
        }).toList();

        if (state.isLoading) {
          return const CustomLoadingSearchWidget();
        }

        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Stack(
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 44,
                      child: SearchTextFormField(
                        cursorColor: null,
                        hintStyle: Styles.headerText(
                          fontSize: 32,
                        ),
                        fillColor: Colors.transparent,
                        currentController: searchController,
                        currentFocusNode: _focusNode,
                        style: Styles.headerText(
                          fontSize: 32,
                          // color: Colors.black,
                        ),
                        margin: EdgeInsets.zero,
                        borderColor: context.isDarkMode
                            ? const Color(0xffCACFF4)
                            : Colors.black,
                        hint: LocaleKeys.transferTo.localize,
                        hintColor: context.isDarkMode
                            ? const Color(0xffCACFF4)
                            : AppColors.QUANTITY_COLOR,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            return;
                          }
                          setState(() {
                            // Show the list when the search text is not empty
                            // showUserList = value.isNotEmpty;
                            _debounce.run(() {
                              context
                                  .read<TransferMoneyCubit>()
                                  .searchUser(query: value);
                            });
                          });
                        },
                      ),
                    ),
                    // FormTextField(
                    //   height: 44,
                    //   textStyle: Styles.headerText(
                    //     fontSize: 32,
                    //     color: Colors.black,
                    //   ),
                    //   enabled: true,
                    //
                    //   // constraints: BoxConstraints(
                    //   //   maxHeight: 52.h,
                    //   //   minHeight: 52.h,
                    //   // ),
                    //   fillColor: Colors.white,
                    //   borderRadius: BorderRadius.circular(15),
                    //   noBorder: true,
                    //   style: Styles.headerText(
                    //     fontSize: 32,
                    //   ),
                    //   controller: searchController,
                    //   hint: LocaleKeys.transferTo.localize,
                    //   action: (value) {
                    //     setState(() {
                    //       // Show the list when the search text is not empty
                    //       showUserList = value.isNotEmpty;
                    //     });
                    //   },
                    // ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 44,
                      child: PriceTextFormField(
                        currentController: amountController,
                        hint: LocaleKeys.amount.localize,
                        hintStyle: Styles.headerText(
                          fontSize: 32,
                        ),
                        fillColor: Colors.transparent,
                        style: Styles.headerText(
                          fontSize: 32,
                        ),
                        borderColor: context.isDarkMode
                            ? const Color(0xffCACFF4)
                            : Colors.black,
                      ),
                    ),
                    // FormTextField(
                    //   textStyle: Styles.mediumText(
                    //     color: Theme.of(context).scaffoldBackgroundColor,
                    //   ),
                    //   type: TextInputType.number,
                    //   constraints: BoxConstraints(
                    //     maxHeight: 52.h,
                    //     minHeight: 52.h,
                    //   ),
                    //   fillColor: Theme.of(context).primaryColor,
                    //   borderRadius: BorderRadius.circular(20.r),
                    //   style: TextStyle(
                    //     fontSize: 30.sp,
                    //     color: Theme.of(context).scaffoldBackgroundColor,
                    //   ),
                    //   controller: amountController,
                    //   hint: LocaleKeys.amount.localize,
                    //   action: (v) {},
                    // ),
                    const SizedBox(
                      height: 32,
                    ),
                    if (state.isTransferLoading)
                      const Center(
                        child: CustomLoadingSearchWidget(),
                      ),
                    if (!state.isTransferLoading)
                      AppButton(
                        label: LocaleKeys.confirm.localize,
                        backColor: const Color(0xffEF333C),
                        style: Styles.headerText(
                          fontSize: 32,
                          color: context.isDarkMode
                              ? const Color(0xff0D0D0D)
                              : Colors.white,
                        ),
                        height: 44,
                        radius: 15,
                        onPressed: () {
      ManageVibration.vibrate();
                          if (formKey.currentState!.validate()) {
                            if (searchController.text.isEmpty) {
                              // If no user is selected or the user is not in the filtered list
                              showErrorMessage(
                                context,
                                LocaleKeys.pleaseSelectAUser.localize,
                              );
                              return;
                            }
                            if (num.parse(amountController.text) >
                                (state.wallet?.realAmount ?? 0)) {
                              showErrorMessage(
                                context,
                                LocaleKeys.notEnoughMoneyWallet.localize,
                              );
                              return;
                            }
                            return bottomSheet(
                              context: context,
                              isFloating: true,
                              asAlertDialog: true,
                              widget: AreYouSure(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 27,
                                  top: 28,
                                ),
                                title: LocaleKeys.alert.localize,
                                subTitle: LocaleKeys
                                    .areYouSureOfTransferMoney.localize,
                                action: () {
                                  context
                                      .read<TransferMoneyCubit>()
                                      .transferMoney(
                                        params: TransferMoneyParams(
                                          receiverUsername:
                                              state.userSelectedEmail,
                                          amount:
                                              int.parse(amountController.text),
                                        ),
                                      );
                                },
                              ),
                            );
                            // return showAreYouSure(
                            //     title: LocaleKeys.alert.localize,
                            //     subTitle:
                            //         LocaleKeys.sureWithdrawMoney.localize,
                            //     action: () {
                            //       context
                            //           .read<TransferMoneyCubit>()
                            //           .transferMoney(
                            //             params: TransferMoneyParams(
                            //               receiverUsername:
                            //                   selectedUsername!,
                            //               amount: int.parse(
                            //                   amountController.text),
                            //             ),
                            //           );
                            //     },
                            //     context: context);
                          }
                        },
                      ),
                  ],
                ),
              ),
              // if (showUserList &&
              //     filteredUsers != null &&
              //     filteredUsers.isNotEmpty)
              if (state.isSearchUserLoading) const CustomLoadingSearchWidget(),
              if (state.isSearchUserSuccess)
                Positioned(
                  top: 47,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    decoration: ShapeDecoration(
                      color: context.isDarkMode
                          ? const Color(0xff0D0D0D)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color:
                              context.isDarkMode ? Colors.white : Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20.r),
                    //   color: Theme.of(context).primaryColor,
                    // ),
                    child: ListView.builder(
                      itemCount: state.users!.length, // filteredUsers.length,
                      itemBuilder: (context, index) {
                        // var user = filteredUsers[index];
                        var user = state.users![index];
                        // String fullName =
                        //     '${capitalize(user.firstName)} ${capitalize(user.lastName)}';
                        return ListTile(
                          title: Text(
                            user.email,
                            style: Styles.headerText(),
                          ),
                          onTap: () {
      ManageVibration.vibrate();
                            searchController.text = user.email;
                            context
                                .read<TransferMoneyCubit>()
                                .selectUser(user.email);

                            // setState(() {
                            //   searchController.text = user.email;
                            //   selectedUsername = user.email;
                            //   showUserList = false;
                            // });
                          },
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );

        // if (state.isLoading) {
        //   return const CustomLoading();
        // } else if (state.isSuccess ||
        //     state.isTransferSuccess ||
        //     state.isTransferError ||
        //     state.isTransferLoading) {
        //   return Padding(
        //     padding: const EdgeInsets.only(left: 16, right: 16),
        //     child: Stack(
        //       children: [
        //         // SearchAnchor.bar(
        //         //   suggestionsBuilder: (context, controller) {
        //         //     final String input = controller.value.text;
        //         //     return filteredUsers!
        //         //         .where((user) => user.email.contains(input))
        //         //         .map(
        //         //           (filteredUser) => InkWell(
        //         //             onTap: () {
        //         //               controller.closeView(filteredUser.email);
        //         //               print(filteredUser.email);
        //         //             },
        //         //             child: Label(
        //         //               text: filteredUser.email,
        //         //             ),
        //         //           ),
        //         //         );
        //         //   },
        //         //   barBackgroundColor: WidgetStateProperty.all(Colors.white),
        //         //   viewBackgroundColor: Colors.grey,
        //         //   // elevation: WidgetStateProperty.all(0),
        //         //   // shape: WidgetStateProperty.all(RoundedRectangleBorder(
        //         //   //   borderRadius: BorderRadius.circular(15),
        //         //   // )),

        //         // ),
        //         // UserSearchField(
        //         //   controller: searchController,
        //         //   onEmailSelected: (value) {},
        //         //   onSearchChanged: (value) {},
        //         //   suggestions:
        //         //       filteredUsers?.map((user) => user.email).toList() ?? [],
        //         // ),
        //         Form(
        //           key: formKey,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               SizedBox(
        //                 height: 44,
        //                 child: SearchTextFormField(
        //                   cursorColor: null,
        //                   hintStyle: Styles.headerText(
        //                     fontSize: 32,
        //                   ),
        //                   currentController: searchController,
        //                   style: Styles.headerText(
        //                     fontSize: 32,
        //                     color: Colors.black,
        //                   ),
        //                   currentFocusNode: null,
        //                   margin: EdgeInsets.zero,
        //                   borderColor: Colors.black,
        //                   hint: LocaleKeys.transferTo.localize,
        //                   onChanged: (value) {
        //                     setState(() {
        //                       // Show the list when the search text is not empty
        //                       showUserList = value.isNotEmpty;
        //                     });
        //                   },
        //                 ),
        //               ),
        //               // FormTextField(
        //               //   height: 44,
        //               //   textStyle: Styles.headerText(
        //               //     fontSize: 32,
        //               //     color: Colors.black,
        //               //   ),
        //               //   enabled: true,
        //               //
        //               //   // constraints: BoxConstraints(
        //               //   //   maxHeight: 52.h,
        //               //   //   minHeight: 52.h,
        //               //   // ),
        //               //   fillColor: Colors.white,
        //               //   borderRadius: BorderRadius.circular(15),
        //               //   noBorder: true,
        //               //   style: Styles.headerText(
        //               //     fontSize: 32,
        //               //   ),
        //               //   controller: searchController,
        //               //   hint: LocaleKeys.transferTo.localize,
        //               //   action: (value) {
        //               //     setState(() {
        //               //       // Show the list when the search text is not empty
        //               //       showUserList = value.isNotEmpty;
        //               //     });
        //               //   },
        //               // ),
        //               const SizedBox(
        //                 height: 16,
        //               ),
        //               SizedBox(
        //                 height: 44,
        //                 child: PriceTextFormField(
        //                   currentController: amountController,
        //                   hint: LocaleKeys.amount.localize,
        //                   hintStyle: Styles.headerText(
        //                       fontSize: 32, color: Colors.black),
        //                   fillColor: Colors.white,
        //                   style: Styles.headerText(
        //                       fontSize: 32, color: Colors.black),
        //                   borderColor: Colors.black,
        //                 ),
        //               ),
        //               // FormTextField(
        //               //   textStyle: Styles.mediumText(
        //               //     color: Theme.of(context).scaffoldBackgroundColor,
        //               //   ),
        //               //   type: TextInputType.number,
        //               //   constraints: BoxConstraints(
        //               //     maxHeight: 52.h,
        //               //     minHeight: 52.h,
        //               //   ),
        //               //   fillColor: Theme.of(context).primaryColor,
        //               //   borderRadius: BorderRadius.circular(20.r),
        //               //   style: TextStyle(
        //               //     fontSize: 30.sp,
        //               //     color: Theme.of(context).scaffoldBackgroundColor,
        //               //   ),
        //               //   controller: amountController,
        //               //   hint: LocaleKeys.amount.localize,
        //               //   action: (v) {},
        //               // ),
        //               const SizedBox(
        //                 height: 32,
        //               ),
        //               if (state.isTransferLoading)
        //                 const Center(
        //                   child: CustomCircularProgressIndicator(),
        //                 ),
        //               if (!state.isTransferLoading)
        //                 AppButton(
        //                   label: LocaleKeys.confirm.localize,
        //                   style: Styles.headerText(
        //                     fontSize: 32,
        //                     color: Colors.white,
        //                   ),
        //                   height: 44,
        //                   radius: 15,
        //                   onPressed: () {
        //                     if (formKey.currentState!.validate()) {
        //                       if (selectedUsername == null ||
        //                           !isUsernameInFilteredUsers(
        //                               selectedUsername, filteredUsers)) {
        //                         // If no user is selected or the user is not in the filtered list
        //                         showErrorMessage(context,
        //                             LocaleKeys.selectValidUser.localize);
        //                       } else if (int.parse(amountController.text) <
        //                           state.wallet!.realAmount!) {
        //                         return bottomSheet(
        //                           context: context,
        //                           isFloating: true,
        //                           asAlertDialog: true,
        //                           widget: AreYouSure(
        //                             padding: const EdgeInsets.only(
        //                               left: 16,
        //                               right: 16,
        //                               bottom: 27,
        //                               top: 28,
        //                             ),
        //                             title: LocaleKeys.alert.localize,
        //                             subTitle: LocaleKeys
        //                                 .areYouSureOfTransferMoney.localize,
        //                             action: () {
        //                               context
        //                                   .read<TransferMoneyCubit>()
        //                                   .transferMoney(
        //                                     params: TransferMoneyParams(
        //                                       receiverUsername:
        //                                           selectedUsername!,
        //                                       amount: int.parse(
        //                                           amountController.text),
        //                                     ),
        //                                   );
        //                             },
        //                           ),
        //                         );
        //                         return showAreYouSure(
        //                             title: LocaleKeys.alert.localize,
        //                             subTitle: LocaleKeys
        //                                 .sureWithdrawMoney.localize,
        //                             action: () {
        //                               context
        //                                   .read<TransferMoneyCubit>()
        //                                   .transferMoney(
        //                                     params: TransferMoneyParams(
        //                                       receiverUsername:
        //                                           selectedUsername!,
        //                                       amount: int.parse(
        //                                           amountController.text),
        //                                     ),
        //                                   );
        //                             },
        //                             context: context);
        //                       } else {
        //                         showErrorMessage(
        //                           context,
        //                           LocaleKeys.notEnoughMoneyWallet.localize,
        //                         );
        //                       }
        //                     }
        //                   },
        //                 ),
        //             ],
        //           ),
        //         ),
        //         if (showUserList &&
        //             filteredUsers != null &&
        //             filteredUsers.isNotEmpty)
        //           Positioned(
        //             top: 47,
        //             left: 0,
        //             right: 0,
        //             child: Container(
        //               width: double.infinity,
        //               height: MediaQuery.sizeOf(context).height * 0.3,
        //               decoration: ShapeDecoration(
        //                 color: Colors.white,
        //                 shape: RoundedRectangleBorder(
        //                   side: const BorderSide(
        //                     width: 2,
        //                     strokeAlign: BorderSide.strokeAlignCenter,
        //                   ),
        //                   borderRadius: BorderRadius.circular(15),
        //                 ),
        //               ),
        //               // decoration: BoxDecoration(
        //               //   borderRadius: BorderRadius.circular(20.r),
        //               //   color: Theme.of(context).primaryColor,
        //               // ),
        //               child: ListView.builder(
        //                 itemCount: filteredUsers.length,
        //                 itemBuilder: (context, index) {
        //                   var user = filteredUsers[index];
        //                   // String fullName =
        //                   //     '${capitalize(user.firstName)} ${capitalize(user.lastName)}';
        //                   return ListTile(
        //                     title: Text(
        //                       user.email,
        //                       style: Styles.headerText(),
        //                     ),
        //                     onTap: () {
        //                       setState(() {
        //                         searchController.text = user.email;
        //                         selectedUsername = user.email;
        //                         showUserList = false;
        //                       });
        //                     },
        //                   );
        //                 },
        //               ),
        //             ),
        //           ),
        //       ],
        //     ),
        //   );
        // } else {
        //   final String messageFailure;
        //   if (state.failure == null) {
        //     messageFailure = LocaleKeys.somethingWentWrong.localize;
        //   } else {
        //     messageFailure = getFailureMessage(state.failure!, context);
        //   }
        //   return CustomFailureWidget(
        //     title: messageFailure,
        //     onPressed: () {
        //       // context.read<TransferMoneyCubit>().loadData();
        //     },
        //   );
        // }
      },
    );
  }
}
