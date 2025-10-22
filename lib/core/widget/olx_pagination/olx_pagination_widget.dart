import 'package:flutter/material.dart';

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
  // final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1; // Start at page 1
  bool _hasLoadedInitialPage = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
    // Load initial page if items are empty
    if (widget.items.isEmpty && !_hasLoadedInitialPage) {
      print("widget.items.isEmpty");
      _hasLoadedInitialPage = true;
      _loadPage(_currentPage);
    }
  }

  void _scrollListener() {
    if (!mounted) return;
    if (widget.scrollController.position.pixels >=
            widget.scrollController.position.maxScrollExtent - 100 &&
        !_isLoading) {
      print("widget.items.isNotEmpty");
      _loadNextPage();
    }
  }

  Future<void> _loadPage(int page) async {
    if (_isLoading) return;
    if (!mounted) return;
    setState(() => _isLoading = true);
    await widget.loadPage(page);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _currentPage = page;
    });
  }

  Future<void> _loadNextPage() async {
    await _loadPage(_currentPage + 1);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height * 0.6;
    final pageCount = (widget.items.length / widget.itemsPerPage).ceil();

    // Build the list of widgets to display
    List<Widget> buildItemsList() {
      List<Widget> allWidgets = [];

      // First page items
      if (widget.items.isNotEmpty) {
        final firstPageCount = widget.items.length > widget.itemsPerPage
            ? widget.itemsPerPage
            : widget.items.length;
        for (int i = 0; i < firstPageCount; i++) {
          allWidgets.add(widget.items[i]);
        }
      }

      // Subsequent pages with banners
      for (int page = 1; page < pageCount; page++) {
        // Add banner
        if (widget.banners.isNotEmpty) {
          allWidgets.add(
            SizedBox(
              height: screenHeight,
              child: BannerAdsWidget(
                key: Key('banner_$page'),
                banner: widget.banners[(page - 1) % widget.banners.length],
              ),
            ),
          );
        }

        // Add items for this page
        for (int i = 0; i < widget.itemsPerPage; i++) {
          final itemIndex = page * widget.itemsPerPage + i;
          if (itemIndex < widget.items.length) {
            allWidgets.add(widget.items[itemIndex]);
          }
        }
      }

      // Loading indicator
      if (_isLoading) {
        allWidgets.add(
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      return allWidgets;
    }

    // Return a simple Column for embedded usage
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Column(
        children: buildItemsList(),
      ),
    );
  }
}

extension StaticOlxPagination on OlxPaginationWidget {
  Widget buildAsStaticList() {
    return Column(
      children: items,
    );
  }
}
