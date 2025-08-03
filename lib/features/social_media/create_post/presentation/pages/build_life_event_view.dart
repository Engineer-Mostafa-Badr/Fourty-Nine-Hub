import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/widget/clickable_widget.dart';
import '../cubit/create_post_cubit.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';

class BuildLifeEventView extends StatelessWidget {
  const BuildLifeEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            _buildImageContainer(context),
            const SizedBox(
              height: 30,
            ),
            Label(text:context.read<CreatePostCubit>().state.selectedLifeEvent?.title??'', style: Styles.headerText(color: AppColors.PRIMARY_COLOR) ),
            const Sizer(
              height: 5,
            ),
            Label(text: DateFormat('yyyy-MM-dd').format(context.read<CreatePostCubit>().state.selectedLifeEvent?.date??DateTime.now()), style: Styles.mediumText(color: AppColors.GREY_DARK_COLOR) ),
            Label(text: context.read<CreatePostCubit>().state.selectedLifeEvent?.desc??'', style: Styles.headerText(color: AppColors.PRIMARY_COLOR) ),

          ],
        ),
      ],
    );
  }

  Widget _buildImageContainer(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal:20),
        height: 320,
        child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                  height: 320,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.GREYBG,
                    borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(20)),

                  ),
                  child:(context.read<CreatePostCubit>().state.selectedLifeEvent?.media==null&&(context.read<CreatePostCubit>().state.selectedLifeEvent?.media.isEmpty??false))?Container(
                    alignment: Alignment.center,
                    child:Center(child: Text("",style: Styles.headerText(color: AppColors.PRIMARY_COLOR),)),
                  ):
                  PageView.builder(
                      itemCount: (context.read<CreatePostCubit>().state.selectedLifeEvent?.media.length??0),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              height: 320,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadiusDirectional.only(topStart: Radius.circular(20)),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(
                                    File(context.read<CreatePostCubit>().state.selectedLifeEvent?.media[index].file.path ?? ''),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      onPageChanged: (index) {
                      }
                  )
              ),
              PositionedDirectional(
                  top: -5,
                  end: -4,
                  child: ClickableWidget(
                    onTap: (){
                      context.read<CreatePostCubit>().removeLifeEvent();
                    },
                    child: Container(
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                            color: AppColors.PRIMARY_COLOR,
                            shape: BoxShape.circle
                        ),
                        alignment: Alignment.center,
                        child:const Icon(Icons.close,size: 18,color: Colors.white,)
                    ),
                  )
              ),
              PositionedDirectional(top: 8,start: 8,
                  child: ClickableWidget(
                    onTap: (){
                      context.pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: AppColors.QUANTITY_COLOR,
                          borderRadius: BorderRadiusDirectional.all(Radius.circular(5))
                        ),
                        alignment: Alignment.center,
                        child:const Row(
                          children: [
                            Icon(Icons.edit,size: 18,color: Colors.white,),
                            SizedBox(width: 5,),
                            Text("Edit Life Event",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.white),)
                          ],
                        )
                    ),
                  )
              ),
              PositionedDirectional(top: 290,start: 0,end: 0,
                  child: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                          color: AppColors.PRIMARY_COLOR,
                          shape: BoxShape.circle
                      ),
                      alignment: Alignment.center,
                      child:SvgPicture.network(context.read<CreatePostCubit>().state.selectedLifeEvent?.mainCat?.image??'',height: 32,width: 32,color: Colors.white,)
                  )
              ),
              if(context.read<CreatePostCubit>().state.selectedLifeEvent?.media==null&&(context.read<CreatePostCubit>().state.selectedLifeEvent?.media.isEmpty??false))PositionedDirectional(top: 110,start: 123,
                child:
                GestureDetector(
                    onTap: (){
                      context.read<CreatePostCubit>().uploadLifeEventPhoto(context:context);
                    },
                    child:const Text("Photos / Vidos",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.black),)
                ),
              ),
            ]
        )
    );
  }
}
