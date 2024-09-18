// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:go_router/go_router.dart';

class ImagesPageViewParams  {
  final MessageEntity messageEntity;
  final int index;
  ImagesPageViewParams({required this.messageEntity, required this.index});
}
class ImagesPageView extends StatefulWidget {
  const ImagesPageView(
      {super.key, required this.params});
  final ImagesPageViewParams params;

  @override
  State<ImagesPageView> createState() => _ImagesPageViewState();
}

class _ImagesPageViewState extends State<ImagesPageView> {
  int _selectedIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    _selectedIndex = widget.params.index;
    _pageController = PageController(initialPage: _selectedIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 26,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Positioned.fill(
        child: PageView.builder(
          controller: _pageController,
          
          itemCount: widget.params.messageEntity.media.length,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: widget.params.messageEntity.media[_selectedIndex].url,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              placeholder: (context, url) => const SizedBox(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            );
          },
        ),
      ),
    );
  }
}
