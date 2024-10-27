import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/azkaar/presentation/cubit/azkaar_cubit.dart';
import 'package:fourtyninehub/features/azkaar/presentation/cubit/azkaar_state.dart';

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
    _cubit.loadInitialData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _cubit.fetchAzkar();
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              widget.category,
              style: const TextStyle(fontSize: 20),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward,),
              onPressed: () {
                Navigator.of(context).pop(); // Pop the current screen
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<AzkarCubit,AzkarState>(
        builder: (BuildContext context, state) {
          if (state.status ==AzkarStates.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return  Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 10.w
            ),
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context,index) {
                if (index == _cubit.azkar.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: 10.w,
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.r),)
                ),
                child:  Text(
                    state.azkarDetail![index].zekr,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 50.sp,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    )
                ),
              );
              },
              separatorBuilder: (context,index)=> const Divider(),
              itemCount: state.azkarDetail?.length ??0,),
          );
        },
      ),
    );
  }
}
