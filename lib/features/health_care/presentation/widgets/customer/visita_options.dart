import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../data/models/filter_option_model.dart';
import '../../../data/models/visita_option_model.dart';
import 'info_selection.dart';

class VisitaOptions extends StatelessWidget {
  final List<VisitaOptionModel> options;
  VisitaOptions({super.key, required this.options});
  final specializations = <FilterOptionModel>[
    FilterOptionModel(
        name: 'Cardiology',
        image: 'https://cdn-icons-png.freepik.com/512/3974/3974920.png'),
    FilterOptionModel(
        name: 'Dermatology',
        image: 'https://cdn-icons-png.freepik.com/512/3974/3974920.png'),
    FilterOptionModel(
        name: 'Endocrinology',
        image: 'https://cdn-icons-png.freepik.com/512/3974/3974920.png'),
    FilterOptionModel(
        name: 'Gastroenterology',
        image: 'https://cdn-icons-png.freepik.com/512/3974/3974920.png'),
    FilterOptionModel(
        name: 'Hematology',
        image: 'https://cdn-icons-png.freepik.com/512/3974/3974920.png'),
    FilterOptionModel(
        name: 'Neurology',
        image: 'https://cdn-icons-png.freepik.com/512/3974/3974920.png'),
  ];
  final states = <FilterOptionModel>[
    FilterOptionModel(
      name: 'Cairo',
    ),
    FilterOptionModel(
      name: 'Alexandria',
    ),
    FilterOptionModel(
      name: 'Aswan',
    ),
    FilterOptionModel(
      name: 'Assiut',
    ),
    FilterOptionModel(
      name: 'Beheira',
    ),
    FilterOptionModel(
      name: 'Beni Suef',
    ),
  ];
  final cities = <FilterOptionModel>[
    FilterOptionModel(
      name: 'Downtown Cairo (Wust El-Balad)',
    ),
    FilterOptionModel(
      name: 'Giza',
    ),
    FilterOptionModel(
      name: 'Zamalek',
    ),
    FilterOptionModel(
      name: 'Maadi',
    ),
    FilterOptionModel(
      name: 'Heliopolis',
    ),
    FilterOptionModel(
      name: 'Islamic Cairo (El Moez Street)',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1,
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        shrinkWrap: true,
        itemCount: options.length,
        itemBuilder: (context, index) {
          return _buildVisitaOptionItem(context: context, item: options[index]);
        });
  }

  Widget _buildVisitaOptionItem(
      {required BuildContext context, required VisitaOptionModel item}) {
    return InkWell(
      onTap: () {
        bottomSheet(
            context: context,
            isScrollControlled: true,
            widget: InfoSelection(
              title: 'Choose Specialization',
              options: specializations,
              onOptionSelected: (item) {
                bottomSheet(
                    context: context,
                    isScrollControlled: true,
                    widget: InfoSelection(
                      title: 'Choose State',
                      options: states,
                      onOptionSelected: (item) {
                        bottomSheet(
                            context: context,
                            isScrollControlled: true,
                            widget: InfoSelection(
                              title: 'Choose City',
                              options: cities,
                              onOptionSelected: (item) =>
                                  context.go(Routes.VISITADOCTORLIST),
                            ));
                      },
                    ));
              },
            ));
      },
      child: Container(
        // margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.LIGHT_COLOR,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(item.image),
            ),
            const Sizer(),
            Label(text: item.name, style: Styles.mediumText())
          ],
        ),
      ),
    );
  }
}
