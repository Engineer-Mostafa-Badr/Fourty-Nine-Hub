import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/competition/presentation/view/widgets/build_item_list_view.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../service_locator/service_locator.dart';
import '../../../data/repository/competition_repo_impl.dart';
import '../../cubit/competition_cubit/competition_cubit.dart';
import '../../cubit/competition_cubit/competition_state.dart';

class SpecialAdsBody extends StatelessWidget {
  const SpecialAdsBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a list of icons for different items
    final List<IconData> icons = [
      Icons.person_add,
      FontAwesomeIcons.codePullRequest,
      FontAwesomeIcons.car,
      FontAwesomeIcons.car,
      FontAwesomeIcons.bowlFood,
      FontAwesomeIcons.book,
      Icons.lightbulb,
      Icons.set_meal_outlined,
      FontAwesomeIcons.car,
      FontAwesomeIcons.car,
      Icons.workspace_premium,
      Icons.live_tv,
      Icons.live_tv,
    ];

    return BlocProvider(
      create: (context) =>
          CompetitionCubit(serviceLocator.get<CompetitionRepoImpl>())
            ..fetchCompetition(context),
      child: BlocBuilder<CompetitionCubit, CompetitionState>(
        builder: (BuildContext context, state) {
          if (state is CompetitionSuccessState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
              child: ListView.separated(
                itemBuilder: (context, index) => BuildItemListView(
                  model: state.competitionModel.data![index],
                  icon: icons[
                      index % icons.length], // Pass the corresponding icon
                ),
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Divider(endIndent: 15, color: Colors.grey),
                ),
                itemCount: state.competitionModel.data!.length,
              ),
            );
          } else if (state is CompetitionErrorState) {
            return Center(
              child: Text(
                state.errMessage,
                textAlign: TextAlign.center,
                style: Styles.mediumText(),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
