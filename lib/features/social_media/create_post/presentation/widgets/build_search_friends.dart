import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class BuildSearchFriends extends StatefulWidget {
  const BuildSearchFriends({
    super.key,
    required this.onSelectUser,
    required this.controller,
  });
  final Function(PostUserEntity) onSelectUser;
  final CreatePostCubit controller;
  @override
  State<BuildSearchFriends> createState() => _BuildSearchFriendsState();
}

class _BuildSearchFriendsState extends State<BuildSearchFriends> {
  final searchController = TextEditingController();
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CreatePostCubit>().fetchFriendsFollowers('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) =>Padding(
          padding: const EdgeInsetsDirectional.only(top: 40.0, end: 8, start: 8),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.arrow_back)),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormTextField(
                      hint: '${LocaleKeys.search.localize} ....',
                      height: kToolbarHeight * .7,
                      action: (v) async {
                        setState(() {});
                        print(v);
                        // widget.controller.usersPagingController.itemList = [];
                        // widget.controller.usersPagingController.refresh();
                        // widget.controller.loadUsers(v);

                        // widget.controller.usersPagingController.itemList = [];
                        widget.controller.loadInitialUsers(v);
                        setState(() {});
                      },
                      controller: widget.controller.searchController,
                      suffix: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.separated(itemBuilder: (context,index)=>Container(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(widget
                                .controller
                                .usersList[index]
                                .profilePicture ??
                                ''),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Label(
                            text: widget
                                .controller
                                .usersList[index].fullName ??
                                '',
                            style: Styles.headerText(),
                          ),
                        ],
                      ),
                      Checkbox(
                          value: widget
                              .controller
                              .usersList[index].isSelected,
                          onChanged: (v) {
                            widget.onSelectUser(widget
                                .controller
                                .usersList[index]);
                            widget
                                .controller
                                .usersList[index].isSelected =
                            !widget
                                .controller
                                .usersList[index].isSelected!;
                            setState(() {});
                          }),
                    ],
                  ),
                ), separatorBuilder: (context,state)=>Sizer(), itemCount: widget
                    .controller
                    .usersList.length),
              )
            ],
          ),
        )
      ),
    );
  }
}
