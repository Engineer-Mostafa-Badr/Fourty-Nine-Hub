import 'package:flutter/material.dart';
import '../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../res/style/styles.dart';

class RideOptions extends StatelessWidget{


  const RideOptions({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15)
          )
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              Expanded(child:Label(text:  'Air Conditioner', style: Styles.mediumText(fontWeight: FontWeight.bold))),
             Switch(value: false, onChanged: (v){

             })
            ],
          ),
          Label(text:  "Car Model Year", style: Styles.mediumText(fontWeight: FontWeight.bold))

,          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index){
              return Row(
                children: [
                  Expanded(child:Label(text: 'Kia', style: Styles.mediumText())),
                 Switch(
                      value: true,
                      onChanged: (v){
                        
                  }),
                ],
              );
            },
            itemCount: 4,),
          const Sizer(),
          AppButton(label: 'Save', onPressed: ()=> context.pop()),
        ],
      ),
    );
  }

}