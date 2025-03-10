import 'package:flutter/material.dart';

import 'font_manager.dart';
class LocationInfoWidget extends StatelessWidget {
  final String from;
  final String to;

  const LocationInfoWidget({
    Key? key,
    required this.from,
    required this.to,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                from,
                style: const TextStyle(fontSize:  FontSize.s14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 2),
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
