import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/call/widgets/call_control_button.dart';

class DeclinedBtns extends StatelessWidget {
  const DeclinedBtns({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        
         _customBtn(context: context, icon: Icons.close, btnText: 'Cancel', backgroundColor:Colors.white , iconColor: Color(0xFF1E282A)),
          _customBtn(context: context, icon: Icons.message_outlined, btnText: "Message", backgroundColor:Color(0xFF1E282A) , iconColor: Colors.white),
        ],
      ),
    );
  }

  Widget _customBtn({required BuildContext context, required IconData icon, required String btnText, required Color backgroundColor, required Color iconColor}){
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CallControlButton(
            iconSize: 26,
            icon: icon,
            backgroundColor: backgroundColor,
            iconColor: iconColor,
            onPressed: () {
              Navigator.pop(context);
            }),
        const SizedBox(height: 8,),
        Text(
          btnText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey
          ),
        )
       ]);
  }
}
