import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/cubit/emergency_requests_cubit.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/widgets/emergency_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class EmergencyRequestsView extends StatefulWidget {
  final String subCategoryId;
  const EmergencyRequestsView({super.key, required this.subCategoryId});

  @override
  State<EmergencyRequestsView> createState() => _EmergencyRequestsViewState();
}

class _EmergencyRequestsViewState extends State<EmergencyRequestsView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context
        .read<EmergencyRequestsCubit>()
        .loadEmergencies(widget.subCategoryId);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context
          .read<EmergencyRequestsCubit>()
          .getEmergencies(widget.subCategoryId);
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.emergencyRequests.localize,
        ),
      ),
      body: BlocBuilder<EmergencyRequestsCubit, EmergencyRequestsState>(
          builder: (context, state) {
        var cubit = context.read<EmergencyRequestsCubit>();
        return state.isLoading
            ? const Center(child: CustomCircularProgressIndicator())
            : cubit.emergencies.isNotEmpty
                ? ListView.separated(
                    controller: _scrollController,
                    padding: EdgeInsets.all(15.w),
                    itemCount: cubit.emergencies.length,
                    separatorBuilder: (context, i) => const Sizer(),
                    itemBuilder: (context, i) => EmergencyCard(
                      emergency: cubit.emergencies[i],
                    ),
                  )
                : Center(
                    child: Text(
                      LocaleKeys.noEmergencyRequests.localize,
                      style: Styles.headerText(),
                    ),
                  );
      }),
    );
  }
}
