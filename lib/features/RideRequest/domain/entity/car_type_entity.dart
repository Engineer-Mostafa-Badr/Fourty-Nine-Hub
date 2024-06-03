class CarTypeEntity {
  final String sId;
  final  String brand;
  final  String model;
   final String year;
   final String type;
   final String subCategory;
   final String mainCategory;
   final String createdAt;
   final String updatedAt;

  CarTypeEntity(
      {
        
       required this.sId,
      required  this.brand,
      required  this.model,
      required  this.year,
      required  this.type,
       required this.subCategory,
      required  this.mainCategory,
      required  this.createdAt,
       required this.updatedAt});

 
}