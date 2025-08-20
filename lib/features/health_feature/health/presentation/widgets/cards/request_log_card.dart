import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../food_feature/food_cart/presentation/pages/cart_view.dart';
import '../../../../doctor_filter/presentation/widgets/premuim_views_card.dart';
import 'health_contacts_button.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class RequestLogCard extends StatelessWidget {
  const RequestLogCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      ManageVibration.vibrate();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: cardDarkColor(context),
            border: Border.all(color: AppColors.LIGHT_GRAY_COLOR),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
            children: [

            /// premium views banner
            PremuimViewsCard(),
        const Divider(),

        /// doctor image
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(Assets.doctor),
                  ),
                  const Sizer(),
                ],
              ),
            ),
            const Sizer(),
            Label(
              text: 'Mona',
              style: Styles.headerText(),
            ),
          ],
        ),
        const Sizer(),
        Label(
          maxLines: 3,
          text:
          "sadaasd lkasjdklsadkljklewjrklewjreklwj sdas asd asd asd se wq we wqe qwe s esa das d sad sad sad sad as dsa das dsa das das ",
          style: Styles.mediumText(),
        ),

        /// address

        const Sizer(),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
            SizedBox(width: 100,),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.PRIMARY_COLOR,
                size: 24,
              ),
              const Sizer(),
              Expanded(child: Label(
                  text: ' Giza, Egypt ', style: Styles.mediumText())),
            ],
          )
          ],
        ),
      ),
      const Divider(),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Expanded(
          child: HealthContactsButtons(
            otherUserId: '',
            subcategoryId: '',
            phone: '',
            id: "",
          ),
        ),
      )
      ],
    ),)
    ,
    );
  }
}