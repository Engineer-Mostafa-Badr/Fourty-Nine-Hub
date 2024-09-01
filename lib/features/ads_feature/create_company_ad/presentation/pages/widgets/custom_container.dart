import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../../data/repositories/company_advertise_repo/company_advertise_repo_impl.dart';
import '../../cubit/company_advertise/company_advertise_cubit.dart';
import '../../cubit/company_advertise/company_advertise_state.dart';

class CustomContainerAdvertise extends StatelessWidget {
  const CustomContainerAdvertise({super.key, required this.title, required this.price, required this.function, required this.filter, this.context});

  final String title;
  final int price;
  final Function function;
  final String filter;
  final context;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompanyAdvertiseCubit(
          serviceLocator.get<CompanyAdvertiseRepoImpl>())
        ..fetchAdvertiseCompany(context, filter),
      child: BlocBuilder<CompanyAdvertiseCubit, CompanyAdvertiseState>(
        builder: (BuildContext context, CompanyAdvertiseState state) {
          if (state is FetchAllCompanyAdvertiseSuccess) {
            final numberOfAdvertises =
                state.advertiseCompanyModel.data!.advertises!.length;

            final totalPrice = price * numberOfAdvertises;

            return GestureDetector(
              onTap: () {
                function();
              },
              child: Container(
                margin: const EdgeInsetsDirectional.only(bottom: 20),
                padding: const EdgeInsetsDirectional.symmetric(
                    vertical: 7, horizontal: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: Styles.headerText(
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                    const SizedBox(width: 6),
                    if (numberOfAdvertises > 0)
                      Text(
                        '($numberOfAdvertises)',
                        style: Styles.mediumText(
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                    const Spacer(),
                    if (numberOfAdvertises > 0)
                      Text(
                        '$totalPrice',
                        style: Styles.mediumText(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.check_circle,
                        color: numberOfAdvertises > 0
                            ? AppColors.SECONDARY_COLOR
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
