import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 'country_dropdown.dart';

class AddStopsWidget extends StatefulWidget {
  const AddStopsWidget({super.key});

  @override
  State<AddStopsWidget> createState() => _AddStopsWidgetState();
}

class _AddStopsWidgetState extends State<AddStopsWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 10,
          children: [
            CountryDropdown(),
            _customLocationField(LocaleKeys.from.tr(), Colors.green,
                LocaleKeys.find.tr(), fromController, false),
            _customLocationField(LocaleKeys.to.tr(), Colors.blue,
                LocaleKeys.find.tr(), toController, true),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                spacing: 5,
                children: [
                  Expanded(
                      flex: 1, child: Icon(Icons.location_on_sharp, size: 30)),
                  Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cairo International Airport',
                          style: TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Heliopolis, El Nozha, Cairo Governora',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            AppButton(
              label: 'Done',
              onPressed: () {},
              width: MediaQuery.of(context).size.width / 2,
              backColor: AppColors.PRIMARY_COLOR,
            ),
          ],
        ),
      ),
    );
  }

  Widget _customLocationField(String label, Color color, String buttonText,
      TextEditingController controller, bool isTo) {
    return Row(
      children: [
        Expanded(
          child: FormTextField(
            style: Styles.mediumText(color: AppColors.GREY_DARK_COLOR),
            constraints: const BoxConstraints(maxHeight: 52, minHeight: 52),
            fillColor: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(20),
            controller: controller,
            hint: label,
            suffix: Row(
              spacing: 5,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isTo == true)
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.add, size: 18),
                  ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 52),
                      backgroundColor: AppColors.PRIMARY_COLOR,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Text(buttonText,
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
            prefix: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: CircleAvatar(
                    backgroundColor: color,
                    radius: 10,
                    child: const CircleAvatar(
                        backgroundColor: Colors.white, radius: 5))),
            action: (v) {},
          ),
        ),
      ],
    );
  }
}
