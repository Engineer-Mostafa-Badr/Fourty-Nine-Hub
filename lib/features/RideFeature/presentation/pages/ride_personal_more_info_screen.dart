import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/custom_date_picker.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/custom_pickup_container.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/image_text_row.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/pickup_text_form_field.dart';

import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';

class RidePersonalMoreInfoScreen extends StatefulWidget {
  const RidePersonalMoreInfoScreen({super.key});

  @override
  State<RidePersonalMoreInfoScreen> createState() =>
      _RidePersonalMoreInfoScreenState();
}

class _RidePersonalMoreInfoScreenState
    extends State<RidePersonalMoreInfoScreen> {
  String _selectedTime = LocaleKeys.pickupTime.localize;
  String _selectedDate = LocaleKeys.pickupDate.localize;
  int _numberOfPassengers = 0;
  bool _isExpanded = false;
  String offerPrice = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: ListView(
        // spacing: 8,
        children: [
          PickUpLocationCard(
            title: LocaleKeys.pickupLocation.localize,
            firstColor: AppColors.c19D176,
          ),
          const SizedBox(
            height: 8,
          ),
          PickUpLocationCard(
            title: LocaleKeys.destination.localize,
            firstColor: AppColors.c3897F0,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (selectedTime != null) {
                      setState(() {
                        _selectedTime = selectedTime.format(context);
                      });
                    }
                  },
                  child: PickUpContainer(
                    fontWeight: FontWeight.w500,
                    title: _selectedTime,
                  ),
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Expanded(
                child: CustomDatePickerButton(
                  selectedDate: _selectedDate,
                  onDateSelected: (newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          PickUpTextFormField(
            hintText: LocaleKeys.cargoDescription.localize,
            maxLines: 4,
          ),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded =
                !_isExpanded;
              });
            },
            child: PickUpContainer(
              title: _numberOfPassengers == 0
                  ? LocaleKeys.numberOfPassenger.localize
                  : '$_numberOfPassengers',
            ),
          ),
          if (_isExpanded)
            Column(
              children: List.generate(10, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _numberOfPassengers =
                          index + 1;
                      _isExpanded =
                      false;
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }),
            ),
          const SizedBox(
            height: 8,
          ),
          PickUpTextFormField(
            hintText: LocaleKeys.phone.localize,
          ),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () => _showOfferFareBottomSheet(context),
            child: PickUpContainer(
              title: LocaleKeys.offerPrice.localize,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ImageTextRow(
              imagePath: Assets.logo,
              text: LocaleKeys.appNotDeduct.localize),
          const SizedBox(
            height: 8,
          ),
          ImageTextRow(
              imagePath: Assets.logo,
              text: LocaleKeys.premiumPackageCashBack.localize),
          const SizedBox(
            height: 8,
          ),
          ImageTextRow(
              imagePath: Assets.logo,
              text: LocaleKeys.freeCancellation.localize),
          const SizedBox(height: 15,),
          Row(
            children: [
              Expanded(child: AppButton(
                  radius: 15,
                  height: 44,
                  backColor: AppColors.PRIMARY_COLOR_DARK,
                  style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),
                  label:LocaleKeys.premium_request.localize, onPressed: (){})),
              const SizedBox(width: 4,),
              Expanded(child: AppButton(
                  radius: 15,
                  height: 44,
                  backColor: AppColors.PRIMARY_COLOR,
                  style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),
                  label: LocaleKeys.request.localize, onPressed: (){})),
            ],
          ),
        ],
      ),
    );
  }

  void _showOfferFareBottomSheet(BuildContext context) {
    TextEditingController offerPriceController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: 0.75,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Centered Text
                      Align(
                        alignment: Alignment.center,
                        child: Label(
                          text: LocaleKeys.offerYourFare.localize,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.cEEEEEEE,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: offerPriceController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "EGP",
                      hintStyle:
                          TextStyle(fontSize: 40, color: AppColors.c96979B),
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    onChanged: (value) {
                      offerPrice = value;
                    },
                  ),
                  const SizedBox(height: 50),
                  AppButton(
                    radius: 15,
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () {
                      setState(() {
                        offerPrice = offerPriceController.text;
                      });
                      Navigator.pop(context);
                    },
                    label: LocaleKeys.done.localize,
                    style: const TextStyle(
                        color: AppColors.LIGHT_COLOR,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}






class PickUpLocationCard extends StatelessWidget {
  final String title;
  final Color? firstColor;

  const PickUpLocationCard({super.key, required this.title, this.firstColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: firstColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // Text "PickUp Location"
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ));
  }
}
