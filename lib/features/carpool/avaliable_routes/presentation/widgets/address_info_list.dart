import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/available_routes_card_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/numberwidget.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AddressInfoList extends StatelessWidget {
  const AddressInfoList({super.key, required this.entity});
  final CarpoolTripParam entity;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddressInfoRow(number: 1, address: entity.locations[0].locationTitle),
        AddressInfoRow(number: 2, address: entity.locations[1].locationTitle),
        AddressInfoRow(number: 3, address: entity.locations[2].locationTitle),
        AddressInfoRow(number: 4, address: entity.locations[3].locationTitle),
      ],
    );
  }
}

class AddressInfoRow extends StatelessWidget {
  const AddressInfoRow({
    super.key,
    required this.number,
    required this.address,
  });
  final int number;
  final String address;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: NumberWidget(
                number: number,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              address,
              style: Styles.headerText(fontSize: 24),
            ),
          )
        ],
      ),
    );
  }
}
