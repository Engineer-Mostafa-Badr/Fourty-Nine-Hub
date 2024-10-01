import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/place_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BuildSearchPlaces extends StatefulWidget {
  const BuildSearchPlaces(
      {super.key, required this.onSelectPlace, required this.controller});
  final Function(PlaceEntity) onSelectPlace;
  final CreatePostCubit controller;

  @override
  State<BuildSearchPlaces> createState() => _BuildSearchPlacesState();
}

class _BuildSearchPlacesState extends State<BuildSearchPlaces> {
  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsDirectional.only(top: 20.0, end: 8, start: 8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [
                  InkWell(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.arrow_back)),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormTextField(
                      hint: 'search ....',
                      height: kToolbarHeight * .7,
                      action: (v) async {
                        // setState(() {});
                        widget.controller.placesPagingController.itemList = [];
                        await widget.controller.loadPlaces(v);
                      },
                      controller: searchController,
                      suffix: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.controller.placesPagingController.itemList != null &&
                widget.controller.placesPagingController.itemList!.isNotEmpty)
              PagedSliverList<int, PlaceEntity>(
                pagingController: widget.controller.placesPagingController,
                builderDelegate: PagedChildBuilderDelegate<PlaceEntity>(
                  noItemsFoundIndicatorBuilder: (context) {
                    return const SizedBox.shrink();
                  },
                  itemBuilder: (context, item, index) {
                    return GestureDetector(
                      onTap: () {
                        widget.onSelectPlace(widget.controller
                            .placesPagingController.itemList![index]);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10.h,
                            ),
                            Expanded(
                              child: Label(
                                text: widget.controller.placesPagingController
                                        .itemList?[index].name ??
                                    '',
                                style: Styles.headerText(),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  noMoreItemsIndicatorBuilder: (context) => Container(),
                  firstPageProgressIndicatorBuilder: (context) =>
                      const CupertinoActivityIndicator(),
                  newPageProgressIndicatorBuilder: (context) =>
                      const CupertinoActivityIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
