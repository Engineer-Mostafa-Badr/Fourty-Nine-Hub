import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_loading_search_widget.dart';
import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_entity.dart';
import 'package:fourtyninehub/features/azkaar/presentation/cubit/azkaar_cubit.dart';
import 'package:fourtyninehub/features/azkaar/presentation/cubit/azkaar_state.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

class AzkarView extends StatefulWidget {
  const AzkarView({super.key});

  @override
  State<AzkarView> createState() => _AzkarViewState();
}

class _AzkarViewState extends State<AzkarView> {
  late ScrollController _scrollController;
  late AzkarCubit _cubit;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        // enableCustomAppBar: true,
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(30),
        //   child: BackAppBar(
        //     label: LocaleKeys.azkar.localize,
        //     enableCustomAppBar: true,
        //   ),
        // ),
        body: BlocBuilder<AzkarCubit, AzkarState>(
          builder: (BuildContext context, state) {
            if (state.status == AzkarStates.loading) {
              return const Center(child: CustomLoadingSearchWidget());
            }
            final isSearching = state.azkarSearch != null &&
                state.azkarSearch!.isNotEmpty &&
                _cubit.searchController.text.isNotEmpty;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          ManageVibration.vibrate();
                          context.pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(AppColors.PRIMARY_COLOR),
                        ),
                        icon: Icon(
                          Icons.arrow_back,
                          size: 40.w,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      Sizer(),
                      Expanded(
                        child: TextField(
                          textDirection: TextDirection.rtl,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.getFillColor(context),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.transparent),
                            ),
                            hintText: LocaleKeys.search.localize,
                            hintStyle: Styles.mediumText(
                                color: AppColors.getTextColor(context)),
                          ),
                          controller: _cubit.searchController,
                          onSubmitted: (value) {
                            // _cubit.searchAzkar(search: value);
                          },
                          onChanged: (value) {
                            if (state.akar == null) return;
                            // if (value.isNotEmpty) {
                            // _cubit.searchController.clear();
                            // _cubit.cleanSearchAzkar();
                            _cubit.searchAzkar2(search: value);
                            // state.akar = state.akar!
                            //     .where((element) => element.name
                            //         .toLowerCase()
                            //         .contains(value.toLowerCase()))
                            //     .toList();
                            // setState(() {});
                            // }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GlowingOverscrollIndicator(
                    color: AppColors.SECONDARY_COLOR,
                    axisDirection: AxisDirection.down,
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                      itemCount: isSearching
                          ? state.azkarSearch!.length
                          : state.akar!.length,
                      itemBuilder: (context, index) {
                        final items =
                            isSearching ? state.azkarSearch! : state.akar!;
      
                        if (index >= items.length) {
                          return const Center(child: CustomLoadingSearchWidget());
                        }
      
                        return _buildAzkarItem(
                            context, items[index], isSearching);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10.h);
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _cubit = context.read<AzkarCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit.loadInitialData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Widget _buildAzkarItem(
      BuildContext context, AzkarEntity item, bool isSearch) {
    return InkWell(
      onTap: () {
        ManageVibration.vibrate();
        context.push(
          Routes.AZKAARDETAILS,
          extra: item.name,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Row(
          children: [
            Image.asset(
              Assets.azkarPrayer,
              color: context.isDarkMode ? AppColors.PRIMARY_COLOR : null,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 40.sp,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.fetchAzkar();
    }
  }
}
