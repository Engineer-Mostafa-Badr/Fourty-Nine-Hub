import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import 'font_manager.dart';

class LocationInfoWidget extends StatelessWidget {
  final String from;
  final String to;
  final String? wayPointOne;
  final String? wayPointTwo;
  final bool? hasTitle;
  final EdgeInsetsGeometry? padding;

  const LocationInfoWidget({
    Key? key,
    required this.from,
    required this.to,
    this.wayPointOne,
    this.wayPointTwo,
    this.hasTitle,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasTitle == true) ...[
            Text(
              context.isArabic ? 'رحلتك الحالية' : 'Your current ride',
              style: const TextStyle(fontSize: FontSize.s16),
            ),
            const SizedBox(height: 8)
          ],

          // Stack with stepper line
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  // From Location
                  Padding(
                    padding: EdgeInsets.only(
                      left: context.isArabic ? 0 : 32,
                      right: context.isArabic ? 32 : 0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            from,
                            style: const TextStyle(fontSize: FontSize.s14),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Waypoint One (if not null)
                  if (wayPointOne != null) ...[
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(
                        left: context.isArabic ? 0 : 32,
                        right: context.isArabic ? 32 : 0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              wayPointOne!,
                              style: const TextStyle(fontSize: FontSize.s14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Waypoint Two (if not null)
                  if (wayPointTwo != null) ...[
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(
                        left: context.isArabic ? 0 : 32,
                        right: context.isArabic ? 32 : 0,
                      ),
                      child: Row(
                        children: [

                          Expanded(
                            child: Text(
                              wayPointTwo!,
                              style: const TextStyle(fontSize: FontSize.s14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // To Location
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(
                      left: context.isArabic ? 0 : 32,
                      right: context.isArabic ? 32 : 0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            to,
                            style: const TextStyle(fontSize: FontSize.s14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Stepper Line with Dots
              Positioned(
                left: context.isArabic ? null : -10,
                right: context.isArabic ? -10 : null,
                top: 0,
                bottom: 0,
                child: _buildStepperLine(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepperLine(BuildContext context) {
    bool showWaypoint1 = wayPointOne != null;
    bool showWaypoint2 = wayPointTwo != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Green dot for "From" location
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 6,
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 3,
            ),
          ),

          const SizedBox(height: 4),

          // Connecting dots
          ...List.generate(
            3,
                (index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? Colors.grey[600]
                    : Colors.grey[400],
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Red dot for Waypoint 1 (if shown)
          if (showWaypoint1) ...[
            const SizedBox(height: 4),
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 6,
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 3,
              ),
            ),
            const SizedBox(height: 4),

            ...List.generate(
              3,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? Colors.grey[600]
                      : Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],

          // Red dot for Waypoint 2 (if shown)
          if (showWaypoint2) ...[
            const SizedBox(height: 4),
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 6,
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 3,
              ),
            ),
            const SizedBox(height: 4),
            ...List.generate(
              3,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? Colors.grey[600]
                      : Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],

          const SizedBox(height: 4),

          // Blue dot for "To" location
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 6,
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 3,
            ),
          ),
        ],
      ),
    );
  }
}