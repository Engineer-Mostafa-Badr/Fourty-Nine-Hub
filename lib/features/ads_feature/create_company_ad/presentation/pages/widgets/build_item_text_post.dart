import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../../res/style/styles.dart';
import '../../../data/models/company_advertise_model.dart';

class BuildItemTextPost extends StatelessWidget {
  const BuildItemTextPost({super.key, required this.advertises});

  final Advertises advertises;

  @override
  Widget build(BuildContext context) {
    final DateTime createdAt = DateTime.parse(advertises.createdAt!);

    final DateTime egyptTime = createdAt.toUtc().add(
        const Duration(hours: 3));

    final String formattedDayTime = DateFormat('EEEE, h:mm a').format(egyptTime);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(
          height: 5,
        ),
        Slidable(
          key: Key(DateTime.now().toString()),
          endActionPane: ActionPane(
            dragDismissible: false,
            extentRatio: .3,
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(onDismissed: () {}),
            children: [
              const SizedBox(width: 5),
              SlidableAction(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                borderRadius: BorderRadius.circular(10),
                onPressed: (context) async {
                  // Implement your archive logic here
                },
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                icon: Icons.delete_outlined,
                label: 'Delete',
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      advertises.post!, // Use actual data here
                      style: Styles.mediumText(
                        fontSize: 34,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(formattedDayTime),
      ],
    );
  }
}
