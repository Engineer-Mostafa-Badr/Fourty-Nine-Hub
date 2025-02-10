import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/life_event_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateLifeEvent extends StatelessWidget {
  const CreateLifeEvent({super.key,required this.lifeEventData});
  final LifeEventEntity lifeEventData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Life Event",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),),
      body: BlocBuilder<CreatePostCubit, CreatePostState>(
          builder: (context,state) {
            var cubit = context.read<CreatePostCubit>();
            return Column(
              // shrinkWrap: true,
              // padding: const EdgeInsets.all(0),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 22),
                  child:Column(
                    children: [
                     SizedBox(
                       height: 250,
                       child: Stack(
                         clipBehavior: Clip.none,
                           children: [
                             Container(
                               height: 250,
                               width: double.infinity,
                               decoration: BoxDecoration(
                                 color: AppColors.GREYBG,
                                 borderRadius: BorderRadius.circular(20),

                               ),
                               alignment: AlignmentDirectional.center,
                             ),
                             PositionedDirectional(top: 8,start: 8,
                             child: Container(
                               height: 44,
                               width: 44,
                               decoration: BoxDecoration(
                                 color: AppColors.GREYICON,
                                 shape: BoxShape.circle
                               ),
                               alignment: Alignment.center,
                               child:Icon(
                                 Icons.close,color: Colors.white,size: 24,
                               )
                             )
                             ),
                             PositionedDirectional(top: 224,start: 147,
                             child: Container(
                               height: 50,
                               width: 50,
                               decoration: BoxDecoration(
                                 color: AppColors.PRIMARY_COLOR,
                                 shape: BoxShape.circle
                               ),
                               alignment: Alignment.center,
                               child:SvgPicture.asset(Assets.starIcon,height: 32,width: 32,color: Colors.white,)
                             )
                             ),
                             PositionedDirectional(top: 110,start: 123,
                             child: Text("Photos / Vidos",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.black),)
                             ),
                             PositionedDirectional(top: 8,end: 8,
                             child: Container(
                               // height: 44,
                               // width: 44,
                               padding: const EdgeInsets.all(10),
                               decoration: BoxDecoration(
                                 color: AppColors.GREYICON,
                                 borderRadius: BorderRadius.circular(22),
                               ),
                               alignment: Alignment.center,
                               child:Row(
                                 children:[
                                   SvgPicture.asset(Assets.addImage,height: 20,width: 20,),
                                   const SizedBox(width: 8,),
                                   Text("Photos / Vidos",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.white),)
                                 ]
                               )
                             )
                             ),
                           ]
                       )
                     )
                    ]
                  )
                )
              ],
            );
          }
      ),

    );
  }
}
