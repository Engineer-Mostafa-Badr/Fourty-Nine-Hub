import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/widget/clickable_widget.dart';
import '../../domain/entities/life_event_entity.dart';
import '../cubit/create_post_cubit.dart';
import 'life_event.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../../helpers/manage_vibration.dart';

class LifeEventSubCategories extends StatefulWidget {
  const LifeEventSubCategories({super.key, required this.lifeEvent});
  final LifeEventEntity lifeEvent;
  @override
  State<LifeEventSubCategories> createState() => _LifeEventSubCategoriesState();
}

class _LifeEventSubCategoriesState extends State<LifeEventSubCategories> {

  @override
  void initState() {
    context.read<CreatePostCubit>().getLifeEventSubCategories(widget.lifeEvent.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.isArabic?widget.lifeEvent.titleAr:widget.lifeEvent.titleEn,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),),
      body: BlocBuilder<CreatePostCubit, CreatePostState>(
          builder: (context,state) {
            var cubit = context.read<CreatePostCubit>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Divider(),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child:Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.PRIMARY_COLOR
                      ),
                      alignment: AlignmentDirectional.center,
                      child: CachedSvgImage(imageUrl: widget.lifeEvent.image,fallbackImage:Assets.logo,height: 42,width: 42,color: Colors.white,),
                    )
                ),
                Expanded(
                    child:cubit.isLoadingMoreLifeEventSubCat?const Center(child: CustomCircularProgressIndicator(),):ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      itemCount: cubit.lifeEventSubCategories.length,
                      itemBuilder: (context, index) {
                        LifeEventEntity selected = LifeEventEntity(
                            id: cubit.lifeEventSubCategories[index].id,
                            titleAr: cubit.lifeEventSubCategories[index].titleAr,
                            titleEn: cubit.lifeEventSubCategories[index].titleEn,
                            image: cubit.lifeEventSubCategories[index].image,
                            media: cubit.lifeEventSubCategories[index].media,
                            title: context.isArabic?cubit.lifeEventSubCategories[index].titleAr:cubit.lifeEventSubCategories[index].titleEn,
                            liveEventMainCategoryId: cubit.lifeEventSubCategories[index].liveEventMainCategoryId,
                        mainCat: widget.lifeEvent
                        );
                        return ClickableWidget(
                          onTap: (){
      ManageVibration.vibrate();
                            context.push(Routes.CREATELIFEEVENT,extra: selected);
                          },
                          child: Container(
                            padding:  const EdgeInsetsDirectional.only(end: 10,bottom: 16),
                            child: Column(
                                children: [
                                  Text(context.isArabic?cubit.lifeEventSubCategories[index].titleAr:cubit.lifeEventSubCategories[index].titleEn,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),textAlign: TextAlign.center,maxLines: 2,),
                                  const SizedBox(height: 8,),
                                  const Divider()
                                ]
                            ),
                          ),
                        );
                      },
                    )
                )
              ],
            );
          }
      ),
    );
  }
}