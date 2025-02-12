import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/life_event_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

class CreateLifeEvent extends StatefulWidget {
  const CreateLifeEvent({super.key, required this.lifeEventData});
  final LifeEventEntity lifeEventData;

  @override
  State<CreateLifeEvent> createState() => _CreateLifeEventState();
}

class _CreateLifeEventState extends State<CreateLifeEvent> {
  DateTime selectedDate = DateTime(2025, 2, 7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Life Event",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Divider(),
                _buildImageContainer(context),
                const SizedBox(height: 40),
                _buildTitleField(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDateSelector(context)
                  ]
                ),
                const SizedBox(height: 16),
                _buildDescriptionField(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context) {
    return  SizedBox(
        height: 250,
        child: Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: (){
                  context.read<CreatePostCubit>().uploadLifeEventPhoto(context:context);
                },
                child:Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.GREYBG,
                    borderRadius: BorderRadius.circular(20),

                  ),
                  child:(context.read<CreatePostCubit>().state.lifeEventImages==null&&context.read<CreatePostCubit>().state.lifeEventImages!.isEmpty)?const SizedBox.shrink():
                  PageView.builder(
                    itemCount: context.read<CreatePostCubit>().state.lifeEventImages!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: FileImage(
                              File(context.read<CreatePostCubit>().state.lifeEventImages?[index].file.path ?? ''),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ),
              ),
              if(context.read<CreatePostCubit>().state.lifeEventImages!=null&&context.read<CreatePostCubit>().state.lifeEventImages!.isNotEmpty)PositionedDirectional(top: 8,start: 8,
                  child: Container(
                      height: 44,
                      width: 44,
                      decoration: const BoxDecoration(
                          color: AppColors.GREYICON,
                          shape: BoxShape.circle
                      ),
                      alignment: Alignment.center,
                      child:const Icon(
                        Icons.close,color: Colors.white,size: 24,
                      )
                  )
              ),
              PositionedDirectional(top: 224,start: 147,
                  child: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                          color: AppColors.PRIMARY_COLOR,
                          shape: BoxShape.circle
                      ),
                      alignment: Alignment.center,
                      child:SvgPicture.network(widget.lifeEventData.image,height: 32,width: 32,color: Colors.white,)
                  )
              ),
              if(context.read<CreatePostCubit>().state.lifeEventImages==null&&context.read<CreatePostCubit>().state.lifeEventImages!.isEmpty)PositionedDirectional(top: 110,start: 123,
                  child:
                  GestureDetector(
                    onTap: (){
                      context.read<CreatePostCubit>().uploadLifeEventPhoto(context:context);
                    },
                    child:const Text("Photos / Vidos",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.black),)
                  ),
              ),
              PositionedDirectional(top: 8,end: 8,
                  child:GestureDetector(
                      onTap: (){
                        context.read<CreatePostCubit>().uploadLifeEventPhoto(context:context);
                      },
                      child:Container(
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
                                const Text("Photos / Vidos",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.white),)
                              ]
                          )
                      )
                  ),
              ),
            ]
        )
    );
  }

  Widget _buildTitleField() {
    return const TextField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: "Enter a title...",
        hintStyle: TextStyle(fontSize: 16),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        fillColor: Colors.transparent,

      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null && pickedDate != selectedDate) {
          setState(() {
            selectedDate = pickedDate;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        width: 211,
        decoration: BoxDecoration(
          color: AppColors.GREYBG,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "DATE: ${selectedDate.day} ${selectedDate.toLocal().toString().split('-')[1]} ${selectedDate.year}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return const TextField(
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: "Say something about this..",
        hintStyle: TextStyle(fontSize: 16),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        fillColor: Colors.transparent,
      ),
    );
  }

  Widget _buildPostButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.PRIMARY_COLOR,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text("Post", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }
}
