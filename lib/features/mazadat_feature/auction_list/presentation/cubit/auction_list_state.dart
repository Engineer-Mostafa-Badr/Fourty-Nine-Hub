part of 'auction_list_cubit.dart';

enum AuctionListStates { loading, error, initState }

extension AuctionListStateX on AuctionListState {
  bool get isLoading => status == AuctionListStates.loading;
  bool get isError => status == AuctionListStates.error;
  bool get isInitState => status == AuctionListStates.initState;
}

class AuctionListState {
  final AuctionListStates? status;
  final Failure? failure;
  final List<AuctionEntity>? auctionList;
  final List<SubCategoryEntity>? subCategories;
  final SubCategoryEntity? selectedSubCategory;
  final bool isGrid;
  AuctionListState(
      {this.status,
      this.auctionList,
      this.failure,
      this.subCategories,
      this.isGrid = true,
      this.selectedSubCategory});
  AuctionListState copyWith({
    AuctionListStates? status,
    Failure? failure,
    List<AuctionEntity>? auctionList,
    List<SubCategoryEntity>? subCategories,
    SubCategoryEntity? selectedSubCategory,
    bool? isGrid,
  }) {
    return AuctionListState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      auctionList: auctionList ?? this.auctionList,
      subCategories: subCategories ?? this.subCategories,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      isGrid: isGrid ?? this.isGrid,
    );
  }
}
