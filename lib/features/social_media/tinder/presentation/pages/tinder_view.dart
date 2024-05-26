import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/routes.dart';
import '../widgets/tinder_person_card.dart';
import '../widgets/tinder_person_options_widget.dart';

class TinderView extends StatefulWidget {
  const TinderView({super.key});

  @override
  State<TinderView> createState() => _TinderViewState();
}

class _TinderViewState extends State<TinderView> {
  late CardSwiperController cardSwipperController;

  @override
  void initState() {
    cardSwipperController = CardSwiperController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
        mainCategoryId: 0,
        body: Stack(
          children: [
            Positioned.fill(bottom: 30, child: _buildCardSwipper()),
            Positioned(
                bottom: kToolbarHeight * .5,
                right: 20,
                left: 20,
                child: _buildActions()),
          ],
        ));
  }

  Widget _buildCardSwipper() {
    return CardSwiper(
      cardsCount: 10,
      controller: cardSwipperController,
      onSwipe: (b, v, d) {
        if (d == CardSwiperDirection.top) {
          context.push(Routes.OTHERSACCOUNT);
        } else if (d == CardSwiperDirection.bottom) {
          bottomSheet(
              context: context, widget: const TinderPersonOptionsWidget());
        }
        return false;
      },
      cardBuilder: (context, index, percentThresholdX, percentThresholdY) =>
          const TinderPersonCard(),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FloatingActionButton.small(
          onPressed: () => cardSwipperController.undo(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: const Icon(Icons.undo_rounded),
        ),
        FloatingActionButton.small(
          onPressed: () =>
              cardSwipperController.swipe(CardSwiperDirection.right),
          backgroundColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),
        FloatingActionButton.small(
          onPressed: () {},
          backgroundColor: AppColors.ACCENT_COLOR,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.star_rounded,
            color: Colors.white,
          ),
        ),
        FloatingActionButton.small(
          onPressed: () {},
          backgroundColor: AppColors.PRIMARY_COLOR,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.chat,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
