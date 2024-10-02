import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/numberwidget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AvailableRoutesPointInfo extends StatelessWidget {
  const AvailableRoutesPointInfo({
    super.key,
    required this.dotNumber,
    this.status = '',
    this.inProgress = true,
    this.gender = 'male',
  });
  final int dotNumber;
  final String status;
  final bool inProgress;
  final String gender;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.center,
            child: Text(status, style: Styles.headerText()),
          ),
        ),
        Expanded(
          flex: 5,
          child: _buildImageOrProgressWidget(),
        ),
        // Expanded(flex: 1, child: Container(color: Colors.grey.withOpacity(0.3))),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: 5,
                    // height: 200,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 3),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dotNumber == 1
                          ? Colors.green
                          : dotNumber == 4
                              ? Colors.blue
                              : Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.only(top: 5),
            alignment: Alignment.center,
            child: NumberWidget(number: dotNumber),
          ),
        ),
      ],
    );
  }

  Widget _buildImageOrProgressWidget() {
    if (dotNumber == 4) {
      return Center(
        child: Text(
          inProgress ? 'In Progress' : 'Finished',
          style: Styles.headerText(),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Container(
      // width: double.infinity,
      // height: double.infinity,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(top: 0, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        shape: status.toLowerCase() != 'free' ? BoxShape.circle : BoxShape.rectangle,
      ),
      padding: EdgeInsets.all(status.toLowerCase() != 'free' ? 0 : 5),
      child: Image.asset(
        status.toLowerCase() == 'free'
            ? Assets.tripjoin
            : gender.toLowerCase() == 'female'
                ? Assets.femaleImagePlacehlder
                : Assets.maleImagePlaceholder,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
