import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_subscription_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/expandable_subscription.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
        color: const Color(0xffD9D9D9),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Label(
              text: LocaleKeys.subscriptions.localize,
              style: Styles.headerText(),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Label(
                text: 'Active',
                style: Styles.mediumText(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          _isExpanded
              ? Column(
                  // Add your expanded content here
                  children: widget.subscriptions
                      .where((s) => s.isActive == true)
                      .map(
                        (s) => ExpandableSubscription(
                          subscription: s,
                        ),
                      )
                      .toList(),

                  // children: List.generate(5, (index) {
                  //   return const ExpandableSubscription();
                  // }),
                )
              : const SizedBox(),
          Row(
            children: [
              if (!_isExpanded)
                Label(
                  text: 'Active Subscription',
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Row(
                  children: [
                    Label(
                      text: _isExpanded ? 'Show Less' : 'Show More',
                      style: Styles.smallText(
                        fontWeight: FontWeight.w300,
                        fontSize: 24,
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
