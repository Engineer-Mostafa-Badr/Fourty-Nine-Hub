import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../../../../res/style/styles.dart';
import '../../../domain/entities/company_ad_entity.dart';
import '../../cubit/create_company_ad_cubit.dart';

class BuildItemTextPost extends StatelessWidget {
  BuildItemTextPost(
      {super.key, required this.advertises, this.isScalable = true, required this.onDeleteItem});

  final CompanyAdEntity advertises;
  final Function(String) onDeleteItem;
  bool? isScalable;

  @override
  Widget build(BuildContext context) {
    final DateTime createdAt = DateTime.parse(advertises.createdAt!);
    final DateTime egyptTime = createdAt.toUtc().add(const Duration(hours: 3));
    final String formattedDayTime =
        DateFormat('EEEE, h:mm a').format(egyptTime);

    return BlocProvider<CreateCompanyAdCubit>(
      create: (BuildContext context) =>serviceLocator(),
      child: BlocConsumer<CreateCompanyAdCubit,CreateCompanyAdState>(
        listener: (BuildContext context, state) {
          if (state.status == StateStatus.success) {
            showSuccessMessage(context, LocaleKeys.deleteSuccessfully.localize);
          }
        },
        builder: (BuildContext context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 5),
              isScalable!
                  ? Slidable(
                key: ValueKey(advertises.sId),
                endActionPane: ActionPane(
                  dragDismissible: false,
                  extentRatio: 0.2,
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(onDismissed: () {}),
                  children: [
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: (){
                         onDeleteItem(advertises.sId!);
                      },
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 80),
                        padding: const EdgeInsets.symmetric(vertical: 5,
                            horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor),
                        child: Icon(
                          Icons.delete_outlined,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
                child: buildItem(context),
              )
                  : buildItem(context),
              const SizedBox(height: 2),
              Text(formattedDayTime),
            ],
          );
        },
      ),
    );
  }

  Widget buildItem(context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 80),
      width: double.infinity,
      padding: const EdgeInsets.symmetric( vertical: 5,horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColor,
      ),
      child: Text(
        advertises.post!,
        style: Styles.mediumText(
          fontSize: 34,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
