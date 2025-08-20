import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_widget/custom_support_text_form_field.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import 'widgets/font_manager.dart';
import 'widgets/map_section.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

// هتتغير انا عملها علشان التغير بتاع ال rate بس
class RatingDriverScreen extends StatefulWidget {
  const RatingDriverScreen({super.key});

  @override
  State<RatingDriverScreen> createState() => _RatingDriverScreenState();
}

class _RatingDriverScreenState extends State<RatingDriverScreen> {


  double _rating = 5.0;

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
  final double rating;
  final Function(double) onRatingChanged;
  final Function(String) onTagSelected;
  final TextEditingController messageController;

  RatingCard({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    required this.onTagSelected,
    required this.messageController,
  });

  TextEditingController problemController = TextEditingController();
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              const  SizedBox(width: 25,),
              const  Spacer(),
              Text(
                LocaleKeys.rateTheClient.localize,
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
              allowHalfRating: true,
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
            GestureDetector(
              onTap: () {
      ManageVibration.vibrate();
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color:  context.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(child: CustomSupportTextField(hintText: LocaleKeys.writeThankYouMessage.localize, controller: problemController,validator: (String? value) {  })),

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
      ManageVibration.vibrate();
                  context.push(Routes.connectionCallScreen);
                },
                child: Text(LocaleKeys.send.localize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
String getRatingText(double rating) {
  if (rating >= 4.5) return LocaleKeys.excellent.localize;
  if (rating >= 3.5) return LocaleKeys.veryGood.localize;
  if (rating >= 2.5) return LocaleKeys.good.localize;
  if (rating >= 1.0) return LocaleKeys.poor2.localize;
  return LocaleKeys.noRating.localize;
}