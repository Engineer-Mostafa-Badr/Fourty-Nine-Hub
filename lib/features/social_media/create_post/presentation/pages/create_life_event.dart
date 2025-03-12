import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/life_event_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class CreateLifeEvent extends StatefulWidget {
  const CreateLifeEvent({super.key, required this.lifeEventData});
  final LifeEventEntity lifeEventData;

  @override
  State<CreateLifeEvent> createState() => _CreateLifeEventState();
}

class _CreateLifeEventState extends State<CreateLifeEvent> {
  DateTime selectedDate = DateTime(2025, 2, 7);

  var formKey = GlobalKey<FormState>();
  initState() {
    if(context.read<CreatePostCubit>().state.selectedLifeEvent==null||context.read<CreatePostCubit>().state.selectedLifeEvent?.id!=widget.lifeEventData.id){
      context.read<CreatePostCubit>().onChangePage(0);
    }
    context.read<CreatePostCubit>().titleController.text = widget.lifeEventData.title??'';
    context.read<CreatePostCubit>().descriptionController.text = widget.lifeEventData.desc??'';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Life Event",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClickableWidget(
                onTap: (){
                  if(formKey.currentState!.validate()){
                    if(context.read<CreatePostCubit>().state.pickedDate!=null){
                      print("context.read<CreatePostCubit>().titleController.text${context.read<CreatePostCubit>().titleController.text}");
                      print(context.read<CreatePostCubit>().descriptionController.text);
                      LifeEventEntity selected = LifeEventEntity(
                          id: widget.lifeEventData.id,
                          titleAr: widget.lifeEventData.titleAr,
                          titleEn: widget.lifeEventData.titleEn,
                          image: widget.lifeEventData.image,
                          media: context.read<CreatePostCubit>().state.lifeEventImages??[],
                          liveEventMainCategoryId: widget.lifeEventData.liveEventMainCategoryId,
                          mainCat: widget.lifeEventData.mainCat,
                        date: context.read<CreatePostCubit>().state.pickedDate,
                        desc: context.read<CreatePostCubit>().descriptionController.text,
                        title: context.read<CreatePostCubit>().titleController.text
                      );
                      context.read<CreatePostCubit>().setLifeEvent(selected);

                      context.push(Routes.CREATEPOST, extra: 'lifeEvent');
                    }else{
                      showErrorMessage(context, "Please select a date");
                    }
                  }
                },
                child: Text('Next',style: Styles.headerText(color: AppColors.PRIMARY_COLOR),)),
          )
        ],
        centerTitle: true,
      ),
      body: BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Padding(
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
                  child:(context.read<CreatePostCubit>().state.lifeEventImages==null&&(context.read<CreatePostCubit>().state.lifeEventImages?.isEmpty??false))?Container(
                    alignment: Alignment.center,
                    child:Center(child: Text("Add Image",style: Styles.headerText(color: AppColors.PRIMARY_COLOR),)),
                  ):
                  PageView.builder(
                    itemCount: (context.read<CreatePostCubit>().state.lifeEventImages?.length??0),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
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
                          ),
                          if(context.read<CreatePostCubit>().state.lifeEventImages!=null&&context.read<CreatePostCubit>().state.lifeEventImages!.isNotEmpty)PositionedDirectional(top: 8,start: 8,
                              child: GestureDetector(
                                  onTap: (){
                                    context.read<CreatePostCubit>().onRemoveLifeEventImages(index);
                                  },
                                  child:Container(
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
                              )
                          ),
                        ],
                      );
                    },
                    onPageChanged: (index) {
                      // context.read<CreatePostCubit>().onChangePage(index);
                    }
                  )
                ),
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
                      child:SvgPicture.network(widget.lifeEventData.mainCat?.image??'',height: 32,width: 32,color: Colors.white,)
                  )
              ),
              if(context.read<CreatePostCubit>().state.lifeEventImages==null&&(context.read<CreatePostCubit>().state.lifeEventImages?.isEmpty??false))PositionedDirectional(top: 110,start: 123,
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
    return TextFormField(
      textAlign: TextAlign.center,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter a title...";
        }
        return null;
      },
      controller: context.read<CreatePostCubit>().titleController,
      decoration: const InputDecoration(
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
            context.read<CreatePostCubit>().onSelectDate(selectedDate);
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
    return TextFormField(
      textAlign: TextAlign.center,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter a description...";
        }
        return null;
      },
      controller: context.read<CreatePostCubit>().descriptionController,
      decoration: const InputDecoration(
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
