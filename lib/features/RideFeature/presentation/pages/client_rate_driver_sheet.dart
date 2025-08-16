import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../service_locator/service_locator.dart';
import '../controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class BuildClientRateDriverSheet extends StatefulWidget {
  const BuildClientRateDriverSheet({
    super.key,
    required this.onPressed,
  });
  final Function(String message, double rate) onPressed;

  @override
  State<BuildClientRateDriverSheet> createState() =>
      _BuildClientRateDriverSheetState();
}

class _BuildClientRateDriverSheetState
    extends State<BuildClientRateDriverSheet> {
  TextEditingController otherController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String? selectedTag;
  double _rating = 4.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusNode().unfocus(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.35,
        minChildSize: 0.2,
        maxChildSize: 0.6,
        builder: (context, scrollController) {
          return BlocProvider.value(
              value: serviceLocator<RideCubit>(),
              child: Builder(builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 25,
                                ),
                                const Spacer(),
                                Text(
                                  context.isArabic
                                      ? "تقييم السائق"
                                      : "Rate The Driver",
                                  style: const TextStyle(
                                      fontSize: FontSize.s20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () async =>
                                      await serviceLocator<RideCubit>()
                                          .finishTripWithoutRating(context),
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade200,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              getRatingText(_rating),
                              style: const TextStyle(
                                  fontSize: FontSize.s20,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            RatingBar.builder(
                              initialRating: _rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemSize: 26,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  _rating = rating;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            RideFeedbackTags(
                              isArabic: context.isArabic,
                              controller:
                                  otherController, // Pass the controller
                            ),
                            const SizedBox(height: 16),
                            DefaultTextFormField(
                              currentController: otherController,
                              fillColor: context.isDarkMode
                                  ? AppColors.GREY_DARK_COLOR
                                  : AppColors.GREYBG,
                              borderColor: Colors.transparent,
                              hint: context.isArabic
                                  ? 'اكتب رسالة شكر'
                                  : 'Write a thank-you message',
                              // label: LocaleKeys.firstName.localize,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.PRIMARY_COLOR,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  ManageVibration.vibrate();
                                  widget.onPressed(
                                      otherController.text, _rating);
                                  // context.pushNamed(Routes.connectionCallScreen);
                                },
                                child: Text(LocaleKeys.send.localize),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }));
        },
      ),
    );
  }

  String getRatingText(double rating) {
    if (rating >= 5.0) return LocaleKeys.excellent.localize;
    if (rating >= 4.0) return LocaleKeys.veryGood.localize;
    if (rating >= 3.0) return LocaleKeys.good.localize;
    if (rating >= 2.0) return LocaleKeys.poor2.localize;
    if (rating >= 1.0) return LocaleKeys.bad.localize;
    return LocaleKeys.noRating.localize;
  }
}

class RideFeedbackTags extends StatefulWidget {
  final bool isArabic;
  final TextEditingController controller;

  const RideFeedbackTags({
    super.key,
    required this.isArabic,
    required this.controller,
  });

  @override
  State<RideFeedbackTags> createState() => _RideFeedbackTagsState();
}

class _RideFeedbackTagsState extends State<RideFeedbackTags> {
  String? selectedTag;

  @override
  Widget build(BuildContext context) {
    final tags = widget.isArabic
        ? [
            "نظيف وأنيق",
            "موسيقى جيدة",
            "قيادة حذرة",
            "سائق مهذب",
            "سيارة جميلة",
            "وصل بسرعة",
          ]
        : [
            "Clean and elegant",
            "Good music",
            "Careful driving",
            "Polite driver",
            "Nice car",
            "Arrived quickly",
          ];

    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3.5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: tags.map((tag) {
          final isSelected = tag == selectedTag;
          return GestureDetector(
            onTap: () {
              ManageVibration.vibrate();
              setState(() {
                selectedTag = tag;
                widget.controller.text = tag; // Update the TextField
              });
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade100 : Colors.grey[200],
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                tag,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
