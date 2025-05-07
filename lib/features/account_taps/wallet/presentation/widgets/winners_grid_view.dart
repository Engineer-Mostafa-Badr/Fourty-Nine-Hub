import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class WinnersGridView extends StatefulWidget {
  const WinnersGridView({
    super.key,
    required this.winners,
    required this.hasReachedMax,
    required this.paginationOnpressed,
  });

  final List<WinnersGridViewModel> winners;
  final bool hasReachedMax;
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
        if (!widget.hasReachedMax) {
          widget.paginationOnpressed();
        }
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CustomScrollView(
        controller: _controller,
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 16,
            ),
          ),
          SliverGrid.builder(
            // controller: _controller,
            // padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: widget.hasReachedMax
                ? widget.winners.length
                : widget.winners.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 7,
              mainAxisSpacing: 8,
              childAspectRatio: 110 / 173,
              crossAxisCount: 3,
              // mainAxisExtent: 180,
            ),
            itemBuilder: (context, index) {
              if (index < widget.winners.length) {
                return WinnersGridViewItem(
                  winner: widget.winners[index],
                );
              } else {
                return const CustomLoading();
              }
            },
          ),
        ],
      ),
    );
  }
}

class WinnersGridViewModel {
  final String image;
  final String name;
  final String? title;
  final String date;
  final String price;
  final String currencyAr;
  final String currencyEn;

  WinnersGridViewModel({
    required this.image,
    required this.name,
    this.title,
    required this.date,
    required this.price,
    required this.currencyAr,
    required this.currencyEn,
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
      height: 180,
      // width: 110,
      // padding: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? const Color(0xB3FFFFFF)
            : const Color(0xB3000000),
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
              ImageFromInternet(
                width: 80.25,
                height: 80.25,
                image: winner.image,
                isCircle: true,
              ),
              // Container(
              //   width: 80.25,
              //   height: 80.25,
              //   decoration: ShapeDecoration(
              //     color: Colors.grey,
              //     image: DecorationImage(
              //       image: NetworkImage(
              //         winner.image,
              //       ),
              //       fit: BoxFit.cover,
              //     ),
              //     shape: const OvalBorder(),
              //   ),
              // ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Label(
                  text: winner.name,
                  style: Styles.headerText(
                    fontSize: 24,
                    color: context.isDarkMode
                        ? const Color(0xff0D0D0D)
                        : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              if (winner.title != null)
                Label(
                  text: winner.title!,
                  style: Styles.mediumText(
                    fontSize: 20,
                    color: context.isDarkMode
                        ? const Color(0xff0D0D0D)
                        : Colors.white,
                  ),
                ),
              Label(
                text: formatDateInWinners(winner.date, context),
                style: Styles.mediumText(
                  fontSize: 20,
                  color: context.isDarkMode
                      ? const Color(0xff0D0D0D)
                      : Colors.white,
                ),
              ),
              Label(
                text:
                    '${FormatNumbers().formatNumberByComma(winner.price, isArabic: context.isArabic)} ${context.isArabic ? winner.currencyAr : winner.currencyEn}',
                style: Styles.mediumText(
                  fontSize: 20,
                  color: context.isDarkMode
                      ? const Color(0xff0D0D0D)
                      : Colors.white,
                ),
              ),
            ],
          ),
          Positioned(
            top: -2,
            right: 14,
            child: SvgPicture.asset(
                context.isDarkMode ? Assets.crownIconDark : Assets.crownIcon),
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
