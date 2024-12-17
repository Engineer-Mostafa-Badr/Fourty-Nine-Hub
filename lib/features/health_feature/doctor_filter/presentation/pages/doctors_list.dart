import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/doctors_list_cubit/doctors_list_cubit.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../widgets/doctor_card.dart';

class DoctorsListParams{
  final bool fromHome;
  final String subCategoryId;
  final String? type;

  DoctorsListParams({required this.fromHome, required this.subCategoryId,this.type=''});
}
class DoctorsListView extends StatefulWidget {
  const DoctorsListView({super.key,required this.params});
  final DoctorsListParams params;
  @override
  State<DoctorsListView> createState() => _DoctorsListViewState();
}

class _DoctorsListViewState extends State<DoctorsListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);
    widget.params.fromHome==true?context.read<DoctorsListCubit>().loadInitialData(widget.params.subCategoryId):context.read<DoctorsListCubit>().loadData();
    super.initState();
  }

  void _onScroll() async{
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      print("object");
      context.read<DoctorsListCubit>().getDoctorsFromSubCategory(widget.params.subCategoryId);
     print("object");
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
    return BlocListener<DoctorsListCubit, DoctorsListState>(
      listener: (context, state) {
      },
      child: Scaffold(
        appBar: BackAppBar(
          label: LocaleKeys.doctorList.localize,
        ),
        body: BlocBuilder<DoctorsListCubit, DoctorsListState>(
            builder: (context, state) {
          if(state.isLoading){
            return const Center(child: CircularProgressIndicator(),);
          }else{
            return context.read<DoctorsListCubit>().doctors.isEmpty?Center(child: Text(LocaleKeys.noDoctorsFound.localize,style: Styles.headerText(),),):Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10.h),
                      itemBuilder: (context, index) => DoctorCard(
                        doctor: context.read<DoctorsListCubit>().doctors[index], type: widget.params.type??'',
                      ),
                      separatorBuilder: (context, index) => const Sizer(),
                      itemCount: context.read<DoctorsListCubit>().doctors.length),
                ),
                if(context.read<DoctorsListCubit>().isLoadingMore) const Center(child: CircularProgressIndicator(),)
              ],
            );
          }
        }),
      ),
    );
  }
}
