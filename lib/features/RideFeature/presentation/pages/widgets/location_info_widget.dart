import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import 'font_manager.dart';
class LocationInfoWidget extends StatelessWidget {
  final String from;
  final String to;
  final bool? hasTitle;

  const LocationInfoWidget({
    super.key,
    required this.from,
    required this.to,
    this.hasTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(hasTitle==true)...[Text(context.isArabic?'رحلتك الحالية':'Your current ride',style: TextStyle(fontSize: FontSize.s16),),
          const SizedBox(height: 8)],
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  from,
                  style: const TextStyle(fontSize:  FontSize.s14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  to,
                  style: const TextStyle(fontSize:  FontSize.s14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
