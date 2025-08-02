import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class WinnersGridView extends StatefulWidget {
  const WinnersGridView({
    super.key,
    required this.winners,
    required this.paginationOnpressed,
  });

  final List<WinnersGridViewModel> winners;
  final void Function() paginationOnpressed;

  @override
  State<WinnersGridView> createState() => _WinnersGridViewState();
}

class _WinnersGridViewState extends State<WinnersGridView> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        widget.paginationOnpressed();
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _controller,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemCount: widget.winners.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 7,
        mainAxisSpacing: 8,
        childAspectRatio: 110 / 173,
        crossAxisCount: 3,
        mainAxisExtent: 173,
      ),
      itemBuilder: (context, index) {
        if (index < widget.winners.length) {
          return WinnersGridViewItem(
            winner: widget.winners[index],
          );
        } else {
          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class WinnersGridViewModel {
  final String image;
  final String name;
  final String? title;
  final String date;
  final String price;

  WinnersGridViewModel({
    required this.image,
    required this.name,
    this.title,
    required this.date,
    required this.price,
  });
}

class WinnersGridViewItem extends StatelessWidget {
  const WinnersGridViewItem({
    super.key,
    required this.winner,
  });
  final WinnersGridViewModel winner;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 173,
      // width: 110,
      // padding: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Container(
                width: 80.25,
                height: 80.25,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      winner.image,
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: const OvalBorder(),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Label(
                text: winner.name,
                style: Styles.headerText(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 3),
              if (winner.title != null)
                Label(
                  text: winner.title!,
                  style: Styles.mediumText(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              Label(
                text: formatDateInWinners(winner.date, context),
                style: Styles.mediumText(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Label(
                text: '${winner.price} ${LocaleKeys.egp.localize}',
                style: Styles.mediumText(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 14,
            child: SvgPicture.asset(Assets.crownIcon),
          ),
        ],
      ),
    );
  }

  String formatDateInWinners(String date, BuildContext context) {
    DateTime parsedDate = DateTime.parse(date);

    return context.locale == Locales.english
        ? DateFormat('d/M/yyyy', 'en').format(parsedDate)
        : DateFormat('yyyy/M/d', 'ar').format(parsedDate);
  }
}
