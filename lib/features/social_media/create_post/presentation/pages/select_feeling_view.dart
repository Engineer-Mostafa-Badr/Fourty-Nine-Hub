import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../domain/entities/feeling_entity.dart';

class SelectFeelingView extends StatefulWidget {
  final List<FeelingEntity> feelings;
  final Function(FeelingEntity) onSelected;

  const SelectFeelingView(
      {super.key, required this.feelings, required this.onSelected});

  @override
  State<SelectFeelingView> createState() => _SelectFeelingViewState();
}

class _SelectFeelingViewState extends State<SelectFeelingView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // context.read<CreatePostCubit>().loadInitialFeelings();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CreatePostCubit>().getFeelings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: CustomScaffold(
        appBar: BackAppBar(
          label: LocaleKeys.selectFeeling.localize,
        ),
        body: BlocBuilder<CreatePostCubit,CreatePostState>(
            builder: (context,state) {
              var cubit = context.read<CreatePostCubit>();
              return cubit.loadFeelings==true?const Center(child: CircularProgressIndicator(),):Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 2),
                        controller: _scrollController,
                        itemCount: cubit.feelings.length,
                        itemBuilder: (context, index) {
                          final item = cubit.feelings[index];
                          return InkWell(
                            onTap: () {
                              widget.onSelected(item);
                              Navigator.pop(context, item);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: .5)),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(item.image),
                                  ),
                                  const Sizer(),
                                  Expanded(child: Label(text: context.isArabic?item.name:item.nameEn,style: Styles.mediumText(),)),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  cubit.isLoadingMoreFeelings?const Column(
                      children: [
                        Sizer(),
                        Center(child: CircularProgressIndicator()),
                      ]):const SizedBox(),

                ],
              );
            }
        ),
      ),
    );
  }
}