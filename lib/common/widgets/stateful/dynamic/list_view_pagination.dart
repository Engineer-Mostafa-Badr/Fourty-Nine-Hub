import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';

class PaginationView<T> extends StatefulWidget {
  final PaginationParams intialPagination;
  final Widget Function(ScrollController scrollController, List<T> data) build;
  final Future<List<T>>? Function(PaginationParams paginationParams) fetchData;
  PaginationView({
    super.key,
    PaginationParams? intialPagination,
    required this.build,
    required this.fetchData,
  }) : intialPagination = intialPagination ?? PaginationParams.basic();

  @override
  State<PaginationView> createState() => _PaginationViewState<T>();
}

class _PaginationViewState<T> extends State<PaginationView<T>> {
  late ScrollController _scrollController;
  late bool _lastPage;
  late List<T>? _fetchedData;
  late List<T> _data;
  late PaginationParams _paginationParams;

  @override
  void initState() {
    _fetchedData = [];
    _paginationParams = widget.intialPagination;
    _lastPage = false;
    _data = [];
    _scrollController = ScrollController();
    _fetchData();
    _scrollController.addListener(() async {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          !_lastPage) {
        await _fetchData();
      }
    });
    super.initState();
  }

  Future<void> _fetchData() async {
    _fetchedData = await widget.fetchData(_paginationParams);
    if (_fetchedData != null) {
      _data.addAll(_fetchedData!);
      _lastPage = _fetchedData!.length < _paginationParams.limit;
      _paginationParams.page++;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(_scrollController, _data);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
