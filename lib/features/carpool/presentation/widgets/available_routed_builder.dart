import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/carpool/domain/entities/available_routes_card_entity.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AvailableRoutesBuilder extends StatefulWidget {
  const AvailableRoutesBuilder({super.key});

  @override
  State<AvailableRoutesBuilder> createState() => _AvailableRoutesBuilderState();
}

class _AvailableRoutesBuilderState extends State<AvailableRoutesBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final entity = cards[index];
        return AvaiableRoutesCard(entity: entity);
      },
    );
  }
}

class AvaiableRoutesCard extends StatelessWidget {
  const AvaiableRoutesCard({
    super.key,
    required this.entity,
  });

  final AvailableRoutesCardEntity entity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: CustomCard(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("40:00:00", style: Styles.mediumText(color: AppColors.SECONDARY_COLOR)),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${entity.price} EGP', style: Styles.headerText(color: AppColors.CHECK_MARK_COLOR)),
                  Text("per seat", style: Styles.mediumText()),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 200.h,
            child: Row(
              children: [
                Expanded(
                  child: Container(color: Colors.green, child: const AvailableRoutesPointInfo()),
                ),
                Expanded(
                  child: Container(color: Colors.blue, child: const AvailableRoutesPointInfo()),
                ),
                Expanded(
                  child: Container(color: Colors.green, child: const AvailableRoutesPointInfo()),
                ),
                Expanded(
                  child: Container(color: Colors.blue, child: const AvailableRoutesPointInfo()),
                ),
              ],
            ),
          ),
          const Sizer(),
        ],
      ),
    );
  }
}

class AvailableRoutesPointInfo extends StatelessWidget {
  const AvailableRoutesPointInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(flex: 2, child: Container(color: Colors.grey.withOpacity(0.3))),
      Expanded(flex: 4, child: Container(color: Colors.yellow.withOpacity(0.3))),
      Expanded(flex: 1, child: Container(color: Colors.grey.withOpacity(0.3))),
      Expanded(flex: 2, child: Container(color: Colors.yellow.withOpacity(0.3))),
    ]);
  }
}

List<AvailableRoutesCardEntity> cards = List.generate(
  10,
  (index) {
    return AvailableRoutesCardEntity(
      price: 100,
      timeLeft: 20,
      onlyWomanAllowed: index.isEven,
      pointOne: PointLocationEntity(
        isMale: index.isOdd,
        booked: index.isOdd,
        number: 1,
        addressEn: 'Mansoura, Samya Gamal street near Egyption hospital',
        addressAr: '',
      ),
      pointTwo: PointLocationEntity(
        isMale: index.isEven,
        booked: index.isEven,
        number: 1,
        addressEn: 'Mansoura, Samya Gamal street near Egyption hospital',
        addressAr: '',
      ),
      pointThree: PointLocationEntity(
        isMale: index.isOdd,
        booked: index.isOdd,
        number: 1,
        addressEn: 'Mansoura, Samya Gamal street near Egyption hospital',
        addressAr: '',
      ),
      pointFour: PointLocationEntity(
        isMale: index.isEven,
        booked: index.isEven,
        number: 1,
        addressEn: 'Mansoura, Samya Gamal street near Egyption hospital',
        addressAr: '',
      ),
    );
  },
);
