import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/place_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BuildSearchPlaces extends StatefulWidget {
  const BuildSearchPlaces({
    super.key,
    required this.onSelectPlace,
  });
  final Function(PlaceEntity) onSelectPlace;
  @override
  State<BuildSearchPlaces> createState() => _BuildSearchPlacesState();
}

class _BuildSearchPlacesState extends State<BuildSearchPlaces> {
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) {
      final controller = context.read<CreatePostCubit>();
      return Padding(
        padding: const EdgeInsetsDirectional.only(top: 20.0, end: 8, start: 8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: FormTextField(
                      hint: 'search ....',
                      height: kToolbarHeight * .7,
                      action: (v) async {
                        setState(() {});
                        controller.placesPagingController.itemList = [];
                        await controller.loadPlaces(v);
                      },
                      controller: searchController,
                      suffix: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
            if (controller.placesPagingController.itemList != null &&
                controller.placesPagingController.itemList!.isNotEmpty)
              PagedSliverList<int, PlaceEntity>(
                pagingController: controller.placesPagingController,
                builderDelegate: PagedChildBuilderDelegate<PlaceEntity>(
                  noItemsFoundIndicatorBuilder: (context) {
                    return const SizedBox.shrink();
                  },
                  itemBuilder: (context, item, index) {
                    return GestureDetector(
                      onTap: () {
                        widget.onSelectPlace(
                            controller.placesPagingController.itemList![index]);
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
                              width: 10.zW,
                            ),
                            Expanded(
                              child: Label(
                                text: controller.placesPagingController
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
      );
    });
  }
}
