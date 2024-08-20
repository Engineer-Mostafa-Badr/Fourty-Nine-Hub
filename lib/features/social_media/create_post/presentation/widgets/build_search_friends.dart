import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BuildSearchFriends extends StatefulWidget {
  const BuildSearchFriends({super.key, required this.onSelect, required this.onSearch, this.users, this.pagination});
  final Function(String) onSelect;
  final Function(String) onSearch;
  final List<PostUserEntity>? users;
  final PagingController<int, PostUserEntity>? pagination;
  @override
  State<BuildSearchFriends> createState() => _BuildSearchFriendsState();
}

class _BuildSearchFriendsState extends State<BuildSearchFriends> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 20.0, end: 8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Row(
              children: [
                const BackButton(),
                Expanded(
                  child: FormTextField(
                    hint: 'search ....',
                    height: kToolbarHeight * .7,
                    action: (v) {

                      return widget.onSearch(v);
                    },
                    controller: searchController,
                    suffix: const Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
          if (widget.users != null)
            PagedSliverList<int, PostUserEntity>(
              pagingController: widget.pagination!,
              builderDelegate: PagedChildBuilderDelegate<PostUserEntity>(
                noItemsFoundIndicatorBuilder: (context) {
                  return const SizedBox.shrink();
                },
                itemBuilder: (context, item, index) {
                  return Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Container(
                            //   width: 60,
                            //   height: 60,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     image: DecorationImage(
                            //       image: NetworkImage(controller
                            //               .usersPagingController
                            //               .itemList?[index]
                            //               .profilePicture ??
                            //           ''),
                            //       fit: BoxFit.fitHeight,
                            //     ),
                            //   ),
                            // ),
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(widget.pagination!.itemList?[index].profilePicture??''),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Label(
                              text: widget.pagination!
                                      .itemList?[index].fullName ??
                                  '',
                              style: Styles.headerText(),
                            ),
                          ],
                        ),
                        Checkbox(value: widget.pagination!
                            .itemList?[index].isSelected, onChanged: (v) {
                          widget.onSelect(widget.pagination!
                              .itemList![index].id);
                          setState(() {

                          });
                        }),
                      ],
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
  }
}
