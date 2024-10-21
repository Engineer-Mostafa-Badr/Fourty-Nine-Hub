import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class AdsSearchView extends StatelessWidget {
  const AdsSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => buildItem(),
      separatorBuilder: (context, index) => const Sizer(),
      itemCount: 10,
    );
  }

  Widget _buildTag() {
    // super premium
    return const Icon(
      Icons.workspace_premium_outlined,
      size: 20,
      color: AppColors.SECONDARY_COLOR,
    );
    // premium
    // regular
  }

  Widget buildItem() => InkWell(
        onTap: () {
          // context.push(Routes.ADdetails, extra: item.id);
        },
        child: Container(
          width: kToolbarHeight * 2.5,
          height: 500.h,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.BACKGROUND_COLOR, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: SquareImage(
                        fit: BoxFit.fill,
                        radius: 5,
                        url:
                            'https://gratisography.com/wp-content/uploads/2024/01/gratisography-cyber-kitty-800x525.jpg',
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: _buildTag(),
                    )
                  ],
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Expanded(
                  //   child: Label(
                  //     text:
                  //         '${NumbersHelper.formatThousands(number: item.price??0)} L.E',
                  //     style: Styles.mediumText(
                  //         fontWeight: FontWeight.bold,
                  //         color: AppColors.SECONDARY_COLOR),
                  //     maxLines: 1,
                  //   ),
                  // ),
                  const Sizer(),
                  IconAppButton(
                      size: 18, icon: Icons.favorite_border, onPressed: () {}),
                ],
              ),
              Row(
                children: [
                  Label(
                      text: '${LocaleKeys.title.localize} : ',
                      style:
                          Styles.mediumText(color: AppColors.SECONDARY_COLOR)),
                  Label(
                    text: 'Craft Job',
                    style: Styles.mediumText(
                        fontWeight: FontWeight.w500, color: Colors.grey),
                    maxLines: 1,
                  ),
                ],
              ),
              Row(
                children: [
                  Label(
                      text: '${LocaleKeys.desc.localize} : ',
                      style:
                          Styles.mediumText(color: AppColors.SECONDARY_COLOR)),
                  Label(
                    text: 'This is full time job',
                    style: Styles.mediumText(
                        fontWeight: FontWeight.w500, color: Colors.grey),
                    maxLines: 1,
                  ),
                ],
              ),
              RichText(
                  text: TextSpan(children: [
                WidgetSpan(
                    child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Label(
                          text: 'label :',
                          //  text: '${e.label} : ',
                          style: Styles.mediumText(
                              color: AppColors.SECONDARY_COLOR)),
                      Label(
                          text: 'value',
                          // text: '${e.value}',
                          style: Styles.mediumText(
                              color: AppColors.PRIMARY_COLOR)),
                    ],
                  ),
                )),
              ])),
              Label(
                text: 'Street hamza gaber manshia elbkary, haram giza',
                // text: 'item.address?.street',
                style: Styles.mediumText(color: Colors.grey),
                maxLines: 1,
              ),
              Label(
                text: 'Monday',
                // text: 'item.formattedRestTime',
                style: Styles.mediumText(color: Colors.grey),
                maxLines: 1,
              ),
            ],
          ),
        ),
      );
}
