import 'package:flutter/material.dart';
import '../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/const.dart';
import '../../../../res/style/styles.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../common/widgets/stateless/dynamic/CarouselSlider.dart';
import '../../../../common/widgets/stateless/labels/ReadMoreLabel.dart';
import '../../../../res/style/app_colors.dart';
import '../widgets/details/DetailsCounterWidget.dart';
import '../widgets/details/PlaceBidding.dart';

class MazadDetails extends StatelessWidget {
  const MazadDetails({super.key});
  final String image =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBxSZEqruWTMC6Kuq6Ia0ZRe5s2VAxdQPU_3jTP5X3as0YTVTZ6mqW6uhwD1QHyxv5dA4&usqp=CAU';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(),
      drawer: const DrawerWidget(),
      backgroundColor: AppColors.GRAY_LIGHT_COLOR3,
      bottomNavigationBar: AppButton(
          margin: 10,
          radius: 15,
          height: kToolbarHeight * .8,
          style: Styles.headerText(color: Colors.white),
          label: 'Place a bid',
          onPressed: () {
            bottomSheet(context: context, widget: const PlaceBidding());
          }),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                        ))),
                const Spacer(),
                Expanded(flex: 2, child: _buildAuctionInfo()),
              ],
            ),
          ),
          const Positioned.fill(
              child: Center(
            child: DetailsCounterWidget(),
          )),
        ],
      ),
    );
  }

  Widget _buildAuctionInfo() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
                ),
                const Sizer(),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                        text: 'Farouk Shahin',
                        style: Styles.mediumText(color: Colors.black)),
                    Label(
                        text: '@faroukshahin30',
                        style: Styles.mediumText(color: Colors.grey)),
                  ],
                )),
                const Sizer(),
                AppButton(
                    padding: 3, height: 30, label: 'Follow', onPressed: () {})
              ],
            ),
            const Divider(
              color: AppColors.LIGHT_GRAY_COLOR,
            ),
            Label(text: 'Marcedes Car', style: Styles.headerText()),
            const ReadMoreLabel(
              text: UIConst.placeholderText,
            )
          ],
        ),
      ),
    );
  }
}
