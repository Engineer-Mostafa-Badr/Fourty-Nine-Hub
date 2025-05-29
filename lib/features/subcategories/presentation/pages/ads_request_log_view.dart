import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/ads_request_log_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AdsRequestLogView extends StatefulWidget {
  const AdsRequestLogView({
    super.key,
    required this.mainCategoryId,
    required this.isFloatingButtonVisible,
  });
  final String mainCategoryId;
  final void Function(bool) isFloatingButtonVisible;
  @override
  State<AdsRequestLogView> createState() => _AdsRequestLogViewState();
}

class _AdsRequestLogViewState extends State<AdsRequestLogView> {
  late ScrollController _scrollController;
  late SubcategoriesCubit _cubit;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    print("AdsRequestLogView initState");
    super.initState();
    _cubit = context.read<SubcategoriesCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context
          .read<SubcategoriesCubit>()
          .getRequestsLogByMainCategory(widget.mainCategoryId);
    }

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      widget.isFloatingButtonVisible(false);
    } else {
      widget.isFloatingButtonVisible(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
        builder: (context, state) {
      final controller = context.read<SubcategoriesCubit>();
      if (controller.isLoadingRequestsLogByMainCategory == true) {
        return const CustomLoading();
      }
      if (controller.requestsLogByMainCategory.isEmpty) {
        return Center(
          child: Label(
            text: LocaleKeys.noRequests.localize,
            style: Styles.headerText(
              fontSize: 40,
              color: context.isDarkMode
                  ? Colors.white.withValues(alpha: 178)
                  : Colors.black.withValues(alpha: 178),
              height: 1.60,
            ),
          ),
        );
      }
      // if(controller.requestsLog.isEmpty){return Center(child: Label(text: "No Requests Found.",style: Styles.mediumText(color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR),),);}
      return ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: controller.requestsLogByMainCategory.length,
        itemBuilder: (context, i) => AdsRequestLogCard(
            requestLog: controller.requestsLogByMainCategory[i]),
      );
    });
  }
}
