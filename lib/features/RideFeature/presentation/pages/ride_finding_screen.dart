import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import 'widgets/font_manager.dart';
import 'widgets/map_section.dart';
import 'widgets/ride_finding_card.dart';

class RideFindingScreen extends StatelessWidget {
  const RideFindingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final Color textColor  = context.isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      body: SharedScaffold(
        mainCategoryId: 2,
        body: Stack(
          children: [
            const MapSection(),
             Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildStackedAvatars(),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  "3",
                                  style: TextStyle(
                                    fontSize: FontSize.s14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  LocaleKeys.driversDisplayYourRequest.localize,
                                  style: TextStyle(
                                    fontSize: FontSize.s14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  RideFindingCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildStackedAvatars() {
    final images = [
      "https://maps.gstatic.com/tactile/pane/default_geocode-2x.png",
      "https://maps.gstatic.com/tactile/pane/default_geocode-2x.png",
      "https://maps.gstatic.com/tactile/pane/default_geocode-2x.png",
    ];

    return SizedBox(
      width: 60,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(images[0]),
            ),
          ),
          Positioned(
            left: 20,
            child: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(images[1]),
            ),
          ),
          Positioned(
            left: 40,
            child: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(images[2]),
            ),
          ),
        ],
      ),
    );
  }
}