import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/elevated_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/style/app_colors.dart';

class MazadCard extends StatelessWidget {
  final bool isHoriz;

  MazadCard({super.key, this.isHoriz = false});
  // TODO Replace with model
    @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(Routes.MAZADDETAILS),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: isHoriz
            ? Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            UIConst.productImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                            child: Container(
                          color: Colors.black.withOpacity(.2),
                        )),
                      ],
                    ),
                  ),
                  const Sizer(),
                  Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              timeCounter(label: '4'),
                              Label(text: ' : ', style: Styles.mediumText()),
                              timeCounter(label: '32'),
                              Label(text: ' : ', style: Styles.mediumText()),
                              timeCounter(label: '45'),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Label(
                                          text: 'Current Price',
                                          style: Styles.smallText(
                                              color: Colors.grey)),
                                      Label(
                                          text: '130 \$',
                                          style: Styles.mediumText(
                                              color: AppColors.PRIMARY_COLOR,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ))
                                ],
                              )),
                              Expanded(
                                  child: AppButton(
                                      style:
                                          Styles.smallText(color: Colors.white),
                                      height: kToolbarHeight * .5,
                                      label: 'Bidding',
                                      onPressed: () {}))
                            ],
                          ),
                        ],
                      ))
                ],
              )
            : Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              UIConst.productImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                              child: Container(
                            color: Colors.black.withOpacity(.2),
                          )),
                          Positioned(
                              top: 5,
                              left: 10,
                              right: 10,
                              child: Row(
                                children: [
                                  timeCounter(label: '4'),
                                  Label(
                                      text: ' : ', style: Styles.mediumText()),
                                  timeCounter(label: '32'),
                                  Label(
                                      text: ' : ', style: Styles.mediumText()),
                                  timeCounter(label: '45'),
                                  const Spacer(),
                                  const Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                ],
                              ))
                        ],
                      )),
                  Column(
                    children: [
                      Label(
                          text: 'Marcedes volume 3, 42 CC , Fabric',
                          style: Styles.mediumText()),
                      Row(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Label(
                                      text: 'Current Price',
                                      style: Styles.mediumText(
                                          color: Colors.grey)),
                                  Label(
                                      text: '130 \$',
                                      style: Styles.headerText(
                                          color: AppColors.PRIMARY_COLOR,
                                          fontWeight: FontWeight.bold))
                                ],
                              ))
                            ],
                          )),
                          Expanded(
                              child: AppButton(
                                  style: Styles.smallText(color: Colors.white),
                                  height: kToolbarHeight * .5,
                                  label: 'Bidding',
                                  onPressed: () {}))
                        ],
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }

  Widget timeCounter({
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.GREY_DARK_COLOR.withOpacity(.7)),
      child: Label(
          text: label,
          style: Styles.mediumText(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
