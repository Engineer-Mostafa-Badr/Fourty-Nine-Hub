import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/presentation/cubit/company_advertise/company_advertise_state.dart';

import '../../../../../../core/messages/messages.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../../data/models/company_advertise_model.dart';
import '../../../data/repositories/company_advertise_repo/company_advertise_repo_impl.dart';
import '../../cubit/company_advertise/company_advertise_cubit.dart';

class BuildItemTextPost extends StatelessWidget {
   BuildItemTextPost({super.key, required this.advertises,this.isScalable=true});

  final Advertises advertises;
  bool? isScalable;

  @override
  Widget build(BuildContext context) {
    final DateTime createdAt = DateTime.parse(advertises.createdAt!);
    final DateTime egyptTime = createdAt.toUtc().add(const Duration(hours: 3));
    final String formattedDayTime = DateFormat('EEEE, h:mm a').format(egyptTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 5),
       isScalable!? Slidable(
          key: ValueKey(advertises.sId),
          endActionPane: ActionPane(
            dragDismissible: false,
            extentRatio: 0.25,
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(onDismissed: () {}),
            children: [
              const SizedBox(height: 5),
              SlidableAction(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                borderRadius: BorderRadius.circular(10),
                onPressed: (context) async {
                  context.read<CompanyAdvertiseCubit>().deletePost(context, advertises.sId!, 'written');
                },
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                icon: Icons.delete_outlined,
                label: 'Delete',
              ),
            ],
          ),
          child: buildItem(context),
        ):buildItem(context),
        const SizedBox(height: 2),
        Text(formattedDayTime),
      ],
    );
  }

  Widget buildItem(context) {
    return Container(
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
          advertises.post!,
          style: Styles.mediumText(
            fontSize: 34,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      ],
    ),
  );
  }
}
