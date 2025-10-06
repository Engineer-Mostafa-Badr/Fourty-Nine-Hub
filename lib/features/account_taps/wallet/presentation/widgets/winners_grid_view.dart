import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'winner.dart';

class WinnersGridView extends StatefulWidget {
  const WinnersGridView({
    super.key,
    required this.winners,
    required this.hasReachedMax,
    required this.paginationOnpressed,
    this.mainAxisExtent,
  });

  final List<WinnersGridViewModel> winners;
  final bool hasReachedMax;
  final void Function() paginationOnpressed;
  final double? mainAxisExtent;

  @override
  State<WinnersGridView> createState() => _WinnersGridViewState();
}

class _WinnersGridViewState extends State<WinnersGridView> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (!widget.hasReachedMax) {
          widget.paginationOnpressed();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CustomScrollView(
        controller: _controller,
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 16,
            ),
          ),
          SliverGrid.builder(
            // controller: _controller,
            // padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: widget.hasReachedMax
                ? widget.winners.length
                : widget.winners.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 7,
              mainAxisSpacing: 8,
              childAspectRatio: 195.w / 260.h,
              crossAxisCount: 3,
              mainAxisExtent: widget.mainAxisExtent,
            ),
            itemBuilder: (context, index) {
              if (index < widget.winners.length) {
                return WinnersGridViewItem(
                  winner: widget.winners[index],
                );
              } else {
                return const CustomLoading();
              }
            },
          ),
        ],
      ),
    );
  }
}

