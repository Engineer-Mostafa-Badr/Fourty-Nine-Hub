import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/saftey_card.dart';

class BuildSafetyItem extends StatelessWidget {
  const BuildSafetyItem({super.key, required this.item});
  final ProtectionItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(item.image??''),
          SizedBox(height: 8),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
