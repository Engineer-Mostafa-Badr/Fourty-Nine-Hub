import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/competition/presentation/cubit/competition_cubit.dart';
import 'package:fourtyninehub/features/competition/presentation/cubit/notifications_state.dart';
import 'package:fourtyninehub/features/competition/presentation/view/widgets/build_item_list_view.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SpecialAdsBody extends StatelessWidget {
  const SpecialAdsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompetitionCubit,CompetitionState>(
      builder: (BuildContext context, state) {
        if(state is CompetitionSuccessState) {
          return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
          child: ListView.separated(
            itemBuilder: (context,index)=> BuildItemListView(model: state.competitionModel.data![index],),
            separatorBuilder: (context,index)=>const Padding(
              padding: EdgeInsets.only(top: 20,bottom: 10),
              child: Divider(endIndent: 15,color: Colors.grey,),
            ),
            itemCount: state.competitionModel.data!.length,
          ),
        );
        }else if(state is CompetitionErrorState){
          return Text(state.errMessage,
          style: Styles.mediumText(),
          );
        }return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
