import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LifeEvent extends StatelessWidget {
  const LifeEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Life Event",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),),
      body: Column(
        // shrinkWrap: true,
        // padding: const EdgeInsets.all(0),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child:Image.asset(
              Assets.lifeEvent,
              width: double.infinity,
              height: 116,
              fit: BoxFit.fill,
            )
          ),
          SizedBox(
            width: 225,
            child:Text("Share and remember important moments from your life.",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
          ),
          SizedBox(height: 8,),
          Divider(),
          SizedBox(height: 16,),
          Text("SELECT A CATEGORY",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
          SizedBox(height: 8,),

          Expanded(
            child:GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 0,
                childAspectRatio: 1,),
              itemBuilder: (context, index) {
                return Container(
                  padding:  EdgeInsetsDirectional.only(end: 10,bottom: 16),
                  child: Column(
                      children: [
                        Image.asset(
                          Assets.lifeEvent,
                          width: 42,
                          height: 42,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(height: 8,),
                        Text("Home & Livingklasndasklnd",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),textAlign: TextAlign.center,maxLines: 2,),
                      ]
                  ),
                );
              },
            )
          )
        ],
      ),
    );
  }
}