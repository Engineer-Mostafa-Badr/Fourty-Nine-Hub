import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/stateful/banners/back_appbar.dart';

class SelectSubActivity extends StatefulWidget {
  final ActivityEntity activity;

  const SelectSubActivity(
      {super.key, required this.activity,});

  @override
  State<SelectSubActivity> createState() => _SelectSubActivityState();
}

class _SelectSubActivityState extends State<SelectSubActivity> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    context.read<CreatePostCubit>().loadInitialSubActivities(widget.activity.id);
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CreatePostCubit>().getSubActivities(widget.activity.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Scaffold(
        appBar: BackAppBar(
          label: LocaleKeys.selectActivity.localize,
        ),
        body: BlocBuilder<CreatePostCubit, CreatePostState>(
          builder: (context,state) {
            var cubit = context.read<CreatePostCubit>();
            if(cubit.loadSubActivities){
              return const Center(child: CircularProgressIndicator(),);
            }
            return GridView.builder(
              controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 2),
                itemCount: cubit.subActivities.length,
                itemBuilder: (context, index) {
                  final item = cubit.subActivities[index];
                  print("item.image ${item.image} ${context.isArabic ? item.name : item.nameEn}");
                  return InkWell(
                    onTap: () {
                      ActivityEntity selectedActivity = ActivityEntity(id: item.id, name: item.name, nameEn: item.nameEn, image: item.image,mainActivity: widget.activity,mainId: widget.activity.id);
                      context
                          .read<CreatePostCubit>()
                          .selectActivity(item: selectedActivity);
                      // widget.onSelected(selectedActivity);
                      Navigator.pop(context, selectedActivity);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: .5)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(item.image),
                            // child: Label(
                            //   text: item.image,
                            //   style: Styles.mediumText(),
                            // ),
                          ),
                          const Sizer(),
                          Expanded(child: Label(text: context.isArabic?item.name:item.nameEn,style: Styles.mediumText(),)),
                        ],
                      ),
                    ),
                  );
                });
          }
        ),
      ),
    );
  }
}
