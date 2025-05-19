import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/dashboards_cubit/dashboards_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_arrived_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_status_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/location_info_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/dialog_widget/show_custom_dialog_trip.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';

class BuildDriverRateClientSheet extends StatefulWidget {
  const BuildDriverRateClientSheet(
      {super.key, required this.onPressed, });
  final Function(String message , double rate ) onPressed;

  @override
  State<BuildDriverRateClientSheet> createState() => _BuildDriverRateClientSheetState();
}

class _BuildDriverRateClientSheetState extends State<BuildDriverRateClientSheet> {

  TextEditingController otherController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String? selectedTag;
  double _rating = 4.0;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.2,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
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
                      getRatingText(_rating),
                      style:const TextStyle(fontSize: FontSize.s20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    RatingBar.builder(
                      initialRating: _rating,
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
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DefaultTextFormField(
                      currentController: otherController,
                      fillColor: context.isDarkMode ? AppColors.GREY_DARK_COLOR : AppColors.GREYBG,
                      borderColor: Colors.transparent,
                      hint: context.isArabic ? 'اكتب رسالة شكر' : 'Write a thank-you message',
                      // label: LocaleKeys.firstName.localize,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return LocaleKeys.required.localize;
                        }
                        return null;
                      },
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
                          if(formKey.currentState!.validate()){
                            widget.onPressed(otherController.text, _rating);
                          }
                          // context.push(Routes.connectionCallScreen);
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
      },
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
