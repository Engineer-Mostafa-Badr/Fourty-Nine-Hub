
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/pages/select_sub_activity_view.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/stateful/banners/back_appbar.dart';

class SelectActivity extends StatefulWidget {
  final List<ActivityEntity> activities;
  final Function(ActivityEntity) onSelected;

  const SelectActivity(
      {super.key, required this.activities, required this.onSelected});

  @override
  State<SelectActivity> createState() => _SelectActivityState();
}

class _SelectActivityState extends State<SelectActivity> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CreatePostCubit>().getActivities();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: CustomScaffold(
        appBar: BackAppBar(
          label: LocaleKeys.selectActivity.localize,
        ),
        body: BlocBuilder<CreatePostCubit,CreatePostState>(
            builder: (context,state) {
              var cubit = context.read<CreatePostCubit>();
              return GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 2),
                  itemCount: cubit.activities.length,
                  itemBuilder: (context, index) {
                    final item = cubit.activities[index];
                    print("item.image ${item.image} ${context.isArabic ? item.name : item.nameEn}");
                    return InkWell(
                      onTap: () {
                        // widget.onSelected(item);
                        Navigator.pop(context, item);
                        bottomSheet(
                            isScrollControlled: true,
                            context: context,
                            widget: SelectSubActivity(
                              activity: cubit.activities[index],
                              // onSelected: (ActivityEntity item) => context
                              //     .read<CreatePostCubit>()
                              //     .selectActivity(item: item),
                            ));
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
