import 'package:flutter/material.dart';

import '../../../res/style/app_colors.dart';
import 'banner.dart';

class OlxPaginationWidget extends StatefulWidget {
  final List<Widget> items;
  final List<BannerAdsModel> banners;
  final int itemsPerPage;
  final ScrollController scrollController;
  final Future<void> Function(int) loadPage; // Callback for loading pages

  const OlxPaginationWidget({
    super.key,
    required this.items,
    required this.banners,
    required this.loadPage,
    required this.scrollController,
    this.itemsPerPage = 10,
  });

  @override
  _OlxPaginationWidget createState() => _OlxPaginationWidget();
}

class _OlxPaginationWidget extends State<OlxPaginationWidget> {
  bool _isLoading = false;
  int _currentPage = 1; // Start at page 1

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
    // Load initial page if items are empty
    if (widget.items.isEmpty) _loadPage(_currentPage);
  }

  void _scrollListener() {
    if (widget.scrollController.hasClients &&
        widget.scrollController.position.pixels >=
            widget.scrollController.position.maxScrollExtent - 100 &&
        !_isLoading) {
      _loadNextPage();
    }
  }

  Future<void> _loadPage(int page) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await widget.loadPage(page);
    if (mounted) {
      setState(() {
        _isLoading = false;
        _currentPage = page;
      });
    }
  }

  Future<void> _loadNextPage() async {
    await _loadPage(_currentPage + 1);
  }

  @override

  void dispose() {
      //   widget.scrollController
      // ..removeListener(_scrollListener)
      // ..dispose();

    // IMPORTANT: Only remove listener, DO NOT dispose the controller
    // The parent widget is responsible for disposing the controller
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height * 0.6;
    final pageCount = (widget.items.length / widget.itemsPerPage).ceil();

    return GlowingOverscrollIndicator(
        color: AppColors.SECONDARY_COLOR,
        axisDirection: AxisDirection.down,
        child: CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            // First page items
            if (widget.items.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => widget.items[index],
                  childCount: widget.items.length > widget.itemsPerPage
                      ? widget.itemsPerPage
                      : widget.items.length,
                ),
              ),

            // Subsequent pages with banners
            for (int page = 1; page < pageCount; page++) ...[
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: false,
                expandedHeight: screenHeight, // Reduced height for banner
                flexibleSpace: BannerAdsWidget(
                  key: Key('banner_$page'),
                  banner: widget.banners[(page - 1) % widget.banners.length],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final itemIndex = page * widget.itemsPerPage + index;
                    return itemIndex < widget.items.length
                        ? widget.items[itemIndex]
                        : null;
                  },
                  childCount: widget.itemsPerPage,
                ),
              ),
            ],

            // Loading indicator
            if (_isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ));
  }
}