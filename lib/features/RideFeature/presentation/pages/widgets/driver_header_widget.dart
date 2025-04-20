import 'package:flutter/material.dart';

import 'font_manager.dart';


class DriverHeaderWidget extends StatelessWidget {
  final String rideStatus;
  final String carModel;
  final String carImageUrl;
  final String carName;
  final String carNumber;

  const DriverHeaderWidget({
    super.key,
    required this.rideStatus,
    required this.carModel,
    required this.carImageUrl,
    required this.carName,
    required this.carNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rideStatus,
                  style: const TextStyle(
                    fontSize:  FontSize.s14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  carModel,
                  style: const TextStyle(
                    fontSize:  FontSize.s12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  carImageUrl,
                  width: 50,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 4),
              // Text(
              //   carName,
              //   style: const TextStyle(fontSize: 10),
              // ),
              // const SizedBox(height: 2),
              Text(
                carNumber,
                style: const TextStyle(
                  fontSize:  FontSize.s12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

