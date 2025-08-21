import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_subscription_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/my_subscription_list_view.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class MySubscriptionSection extends StatefulWidget {
  const MySubscriptionSection({super.key, required this.subscriptions});

  final List<WalletSubscriptionEntity> subscriptions;

  @override
  _MySubscriptionSectionState createState() => _MySubscriptionSectionState();
}

class _MySubscriptionSectionState extends State<MySubscriptionSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? const Color(0xff333333)
            : const Color(0xffD9D9D9),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Label(
              text: LocaleKeys.subscriptions.localize,
              style: Styles.headerText(height: 1.60),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Label(
                text: LocaleKeys.active.localize,
                style: Styles.mediumText(
                  fontWeight: FontWeight.w600,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                  height: 1.60,
                ),
              ),
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? MediaQuery.sizeOf(context).height * 0.2 : 0,
            child: _isExpanded
                ? MySubscriptionListView(subscriptions: widget.subscriptions)
                : null,
          ),
          Row(
            children: [
              // if (!_isExpanded)
              //   Label(
              //     text: LocaleKeys.active.localize,
              //     style: Styles.mediumText(
              //       fontWeight: FontWeight.w600,
              //       color: context.isDarkMode ? Colors.white : Colors.black,
              //       height: 1.60,
              //     ),
              //   ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  ManageVibration.vibrate();
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Row(
                  children: [
                    Label(
                      text: _isExpanded
                          ? LocaleKeys.showLess.localize
                          : LocaleKeys.showMore.localize,
                      style: Styles.smallText(
                        fontWeight: FontWeight.w300,
                        fontSize: 24,
                        color: context.isDarkMode ? Colors.white : Colors.black,
                        height: 1.60,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Icon(_isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
