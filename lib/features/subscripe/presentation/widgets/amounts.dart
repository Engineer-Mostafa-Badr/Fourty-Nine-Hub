import 'package:flutter/material.dart';
import '../../../../common/widgets/stateless/buttons/elevated_button.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/enums/wallet_types_enums.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/format_numbers.dart';
import '../../../payment/presentation/pages/payment_view.dart';
import '../../domain/entities/subscription_amount_entity.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../helpers/manage_vibration.dart';

class SubscriptoinAmountsWidget extends StatefulWidget {
  final WalletTypes walletType;
  final List<SubscriptionAmountEntity> amounts;
  final bool hideRedTitle;

  const SubscriptoinAmountsWidget({
    super.key,
    required this.amounts,
    required this.walletType,
    this.hideRedTitle = false,
  });

  @override
  State<SubscriptoinAmountsWidget> createState() =>
      _SubscriptoinAmountsWidgetState();
}

class _SubscriptoinAmountsWidgetState extends State<SubscriptoinAmountsWidget> {
  num? groupValue;

  String newIndex = '';
  num newAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          // left: 19.5,
          // right: 19.5,
          // top: 8,
          // bottom: 16,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.hideRedTitle)
            Label(
              text: LocaleKeys.insufficientAmount.localize,
              style: Styles.headerText(
                color: const Color(0xffF45560),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(
            height: 8,
          ),
          Text(
            LocaleKeys.selectAmountToCharge.localize,
            style: Styles.mediumText(),
          ),
          const SizedBox(
            height: 8,
          ),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 4,
              childAspectRatio: 169 / 32,
            ),
            padding: EdgeInsets.zero,
            itemCount: widget.amounts.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Radio(
                    value: widget.amounts[index].amount,
                    groupValue: groupValue,
                    activeColor: context.isDarkMode
                        ? const Color(0xffD6DADE)
                        : const Color(0xff212529),
                    onChanged: (value) {
                      setState(() {
                        groupValue = value!;
                        print(widget.amounts[index].id);
                        newIndex = widget.amounts[index].id;
                        newAmount = widget.amounts[index].amount;
                        print("${widget.amounts[index].amount}");
                      });
                    },
                  ),
                  Expanded(
                    child: Container(
                      // width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: ShapeDecoration(
                        color: context.isDarkMode
                            ? const Color(0xFFCACFF4)
                            : const Color(0xFF0B1035),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Label(
                          text: FormatNumbers().formatNumberByComma(
                            widget.amounts[index].amount.toString(),
                            isArabic: context.isArabic,
                          ),
                          style: Styles.mediumText(
                            color: context.isDarkMode
                                ? const Color(0xff0D0D0D)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: BadgedLabel(
                  //     label: widget.amounts[index].amount.toString(),
                  //     overFlow: TextOverflow.ellipsis,
                  //     max: 1,
                  //     padding: const EdgeInsets.all(0),
                  //     margin: 0,
                  //   ),
                  // ),
                ],
              );
            },
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedAppButton(
                  label: LocaleKeys.chargeNow.localize,
                  // backColor: context.isDarkMode
                  //     ? const Color(0xffCACFF4)
                  //     : Theme.of(context).primaryColor,
                  radius: 15,
                  textStyle: Styles.mediumText(
                    fontWeight: FontWeight.w500,
                    fontSize: 36,
                    color: context.isDarkMode
                        ? const Color(0xff0D0D0D)
                        : Colors.white,
                  ),
                  onPressed: () {
                    ManageVibration.vibrate();
                    if (groupValue != null) {
                      context.pushNamed(Routes.PAYMENT,
                          extra: PaymobLink(
                              amountId: newIndex,
                              // providerId: "667331f44fbaddc4357d612b",
                              amount: newAmount));
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: ElevatedAppButton(
                  label: LocaleKeys.cancel.localize,
                  backColor: context.isDarkMode
                      ? const Color(0xff333333)
                      : const Color(0xffD9D9D9),
                  radius: 15,
                  textStyle: Styles.mediumText(
                    fontWeight: FontWeight.w500,
                    fontSize: 36,
                  ),
                  onPressed: () {
                    ManageVibration.vibrate();
                    context.pop();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
