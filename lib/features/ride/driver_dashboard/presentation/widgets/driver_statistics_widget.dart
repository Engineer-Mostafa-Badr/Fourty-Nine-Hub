import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/ride/driver_dashboard/data/models/driver_statistics_model.dart';

import '../../../../../res/style/app_colors.dart';

class OrderStatisticsWidget extends StatelessWidget {
  final DriverStatisticsModel item;
  const OrderStatisticsWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildStatisticsItemWidget(
              icon: Icons.list, value: item.allTripsCount, label: 'All Trips'),
          Row(
            children: [
              Expanded(
                  child: _buildStatisticsItemWidget(
                      icon: Icons.list,
                      value: item.reviewsCount,
                      label: 'Total Reviews')),
              Expanded(
                  child: _buildStatisticsItemWidget(
                      icon: Icons.star_rounded,
                      value: item.ratingAvg,
                      label: 'Rating')),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: _buildStatisticsItemWidget(
                      icon: Icons.list,
                      value: item.reviewsCount,
                      label: 'Todays Earning')),
              Expanded(
                  child: _buildStatisticsItemWidget(
                      icon: Icons.star_rounded,
                      value: item.ratingAvg,
                      label: 'Todays Trips')),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatisticsItemWidget({
    required IconData icon,
    required num value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.PRIMARY_COLOR.withOpacity(.4),
      ),
      child: Row(
        children: [
          Icon(icon),
          Label(text: '$value - $label'),
        ],
      ),
    );
  }
}
