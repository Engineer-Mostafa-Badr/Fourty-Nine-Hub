import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'get_all_talents.dart';

class MyTalentView extends StatelessWidget {
  const MyTalentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Text(
                  'Winners',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.sp,
                  ),
                ),
                const SizedBox(width: 4),
                Image.asset(
                  'assets/49-New-icons/winners.png',
                  // height: 20,
                ),
              ],
            ),
          ),
        ],
        title: Text(
          'My Talent',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 36.sp,
          ),
        ),
      ),
      body: const GetAllTalents(
        isMyTalent: true,
      ),
    );
  }
}
