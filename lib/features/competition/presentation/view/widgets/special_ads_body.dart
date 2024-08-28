import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/competition/presentation/view/widgets/build_item_list_view.dart';

class SpecialAdsBody extends StatelessWidget {
  const SpecialAdsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
      child: ListView.separated(
        itemBuilder: (context,index)=>const BuildItemListView(),
        separatorBuilder: (context,index)=>const Padding(
          padding: EdgeInsets.only(top: 20,bottom: 10),
          child: Divider(endIndent: 15,color: Colors.grey,),
        ),
        itemCount: 10,
      ),
    );
  }
}
