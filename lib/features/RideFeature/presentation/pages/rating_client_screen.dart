import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import 'widgets/font_manager.dart';
import 'widgets/map_section.dart';

// هتتغير انا عملها علشان التغير بتاع ال rate بس
class RatingClientScreen extends StatefulWidget {
  @override
  State<RatingClientScreen> createState() => _RatingClientScreenState();
}

class _RatingClientScreenState extends State<RatingClientScreen> {
  final List<String> tags = [
    "Clean and elegant",
    "Good music",
    "Careful driving",
    "Polite driver",
    "Nice car",
    "Driver arrived quickly"
  ];

  double _rating = 4.0;

  String? selectedTag;

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SharedScaffold(
          mainCategoryId: 2,
          body: Stack(
          children: [
           const MapSection(),
            Align(
              alignment: Alignment.bottomCenter,
              child: RatingCard(
                tags: tags,
                rating: _rating,
                onRatingChanged: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
                onTagSelected: (tag) {
                  setState(() {
                    selectedTag = tag;
                  });
                },
                messageController: _messageController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingCard extends StatelessWidget {
  final List<String> tags;
  final double rating;
  final Function(double) onRatingChanged;
  final Function(String) onTagSelected;
  final TextEditingController messageController;

  const RatingCard({
    super.key,
    required this.tags,
    required this.rating,
    required this.onRatingChanged,
    required this.onTagSelected,
    required this.messageController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration:  BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius:const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow:const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            const  SizedBox(width: 25,),
            const  Spacer(),
            Text(
              LocaleKeys.rateTheDriver.localize,
              style: const TextStyle(fontSize: FontSize.s20, fontWeight: FontWeight.bold),
            ),
           const Spacer(),
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              child: const Icon(Icons.close,color: Colors.black,),
            ),
          ],),
          const SizedBox(height: 8,),
           Text(
      getRatingText(rating),
            style:const TextStyle(fontSize: FontSize.s20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 26,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: onRatingChanged,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: tags.map((tag) =>  GestureDetector(
                onTap: () => onTagSelected(tag),
                child: Container(
                  width: MediaQuery.sizeOf(context).width*.41,
                  height: 40,
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.isDarkMode?Colors.black.withOpacity(.6):Colors.grey[200],
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child:Text(tag),

              ),
            )).toList(),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    LocaleKeys.writeThankYouMessage.localize,
                    style:const TextStyle(color: Colors.grey),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.PRIMARY_COLOR,
                foregroundColor: Colors.white,
                padding:const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                context.push(Routes.connectionCallScreen);
              },
              child: Text(LocaleKeys.send.localize),
            ),
          ),
        ],
      ),
    );
  }
}
String getRatingText(double rating) {
  if (rating >= 5.0) return LocaleKeys.excellent.localize;
  if (rating >= 4.0) return LocaleKeys.veryGood.localize;
  if (rating >= 3.0) return LocaleKeys.good.localize;
  if (rating >= 2.0) return LocaleKeys.poor2.localize;
  if (rating >= 1.0) return LocaleKeys.bad.localize;
  return LocaleKeys.noRating.localize;
}
