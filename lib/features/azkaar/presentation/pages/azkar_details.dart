import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/azkaar/presentation/cubit/azkaar_cubit.dart';
import 'package:fourtyninehub/features/azkaar/presentation/cubit/azkaar_state.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../core/widget/custom_scaffold.dart';

class AzkarDetails extends StatefulWidget {
  const AzkarDetails({super.key, required this.category});

  final String category;

  @override
  State<AzkarDetails> createState() => _AzkarDetailsState();
}

class _AzkarDetailsState extends State<AzkarDetails> {
  late ScrollController _scrollController;
  late AzkarCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<AzkarCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit.loadAzkarData(widget.category);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.fetchDetailsAzkar(widget.category);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: BackAppBar(
        label: widget.category,
        enableCustomAppBar: true,
      ),
      enableCustomAppBar: true,

      body: BlocBuilder<AzkarCubit, AzkarState>(
        builder: (BuildContext context, state) {
          if (state.status == AzkarStates.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              if (index == _cubit.azkarDetails.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text.rich(
                      textDirection: TextDirection.rtl,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: state.azkarDetail![index].zekr, // Zekr text
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 40.sp,
                              color:
                                  context.isDarkMode? Colors.white : AppColors.PRIMARY_COLOR,
                            ),
                          ),
                          TextSpan(
                            text: state.azkarDetail?[index].count != null
                                ? '(${state.azkarDetail![index].count})' // Show count with parentheses if not null
                                : '', // Count text in red
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 40.sp,
                              color: Colors.red, // Red color for the count
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.right,
                    ),
                    if (state.azkarDetail![index].description!.isNotEmpty)
                      Text(state.azkarDetail![index].description!,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 30.sp,
                            color: AppColors.SECONDARY_COLOR,
                          )),
                    if (state.azkarDetail![index].reference!.isNotEmpty)
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(state.azkarDetail![index].reference!,
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 30.sp,
                              color: AppColors.SECONDARY_COLOR,
                            )),
                      ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: AppColors.GREY_NORMAL_COLOR,
            ),
            itemCount: state.azkarDetail?.length ?? 0,
          );
        },
      ),
    );
  }
}
