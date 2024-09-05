import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

class PaginationView<T> extends StatefulWidget {
  final PaginationParams intialPagination;
  final Widget Function(ScrollController scrollController, List<T> data) build;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final Future<List<T>>? Function(PaginationParams paginationParams) fetchData;

  PaginationView({
    super.key,
    PaginationParams? intialPagination,
    this.loadingWidget,
    this.emptyWidget,
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
  late bool _isLoading;
  late bool _isEmpty;

  @override
  void initState() {
    _isLoading = true;
    _isEmpty = false;
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
    _isLoading = false;
    if (_fetchedData != null) {
      _data.addAll(_fetchedData!);
      _lastPage = _fetchedData!.length < _paginationParams.limit;
      _paginationParams.page++;
      setState(() {});
    } else {
      if (_paginationParams.page == 1) {
        setState(() {
          _isEmpty = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading){
      return widget.loadingWidget ?? const Center(child: CircularProgressIndicator.adaptive());
    }else if(_isEmpty){
return widget.emptyWidget ??  Center(child: Text(LocaleKeys.noData.tr()),);
    }else{
      return widget.build(_scrollController, _data);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
