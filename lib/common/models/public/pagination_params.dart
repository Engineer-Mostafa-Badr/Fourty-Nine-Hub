class PaginationParams {
  final int limit;
  final int page;
  PaginationParams({
    this.limit=10,
    required this.page
  });
  
  Map<String,dynamic> toJson()=>{
    'limit':limit, 
    'page':page,
  };
}