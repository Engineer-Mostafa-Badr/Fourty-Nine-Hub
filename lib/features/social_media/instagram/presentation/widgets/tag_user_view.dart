import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/tag_user_view_body.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TagUserView extends StatefulWidget {
  const TagUserView({super.key, required this.images});
  final List<File> images;

  @override
  State<TagUserView> createState() => _TagUserViewState();
}

class _TagUserViewState extends State<TagUserView> {
  late final TextEditingController searchController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    searchController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  bool isSearchClicked = false;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: isSearchClicked
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xffF0F0F0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: searchController,
                  focusNode: _focusNode,
                  onChanged: (value) {
                    setState(() {

                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0x80000000),),
                    hintText: LocaleKeys.searchForAUser.localize,
                    hintStyle: Styles.mediumText(
                        color: Colors.black.withValues(alpha: 128),
                        fontSize: 32,
                    ),

                  ),
                ),
              )
            : Label(
                text: LocaleKeys.tagPeople.localize,
                style: Styles.headerText(),
              ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close_rounded),
        ),
        actions: isSearchClicked
            ? [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.check,
                    color: Color(0xffFF3308),
                  ),
                ),
              ]
            : null,
      ),
      body: searchController.text.isNotEmpty ?
      Container() :
      TagUserViewBody(
        images: widget.images,
        onTap: () {
          _focusNode.requestFocus();
            isSearchClicked = !isSearchClicked;

            setState(() {  });
        },
      ) ,
    );
  }
}
