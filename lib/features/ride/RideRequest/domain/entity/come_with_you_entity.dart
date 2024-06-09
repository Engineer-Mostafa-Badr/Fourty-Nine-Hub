class ComeWithYouRequestEntity {
  final String vehicleId;
  final String categoryId;
  final List<String> startLocation;
  final List<String> targetLocation;
  final String from;
  final String to;
  final int passengers;
  final int price;
  final int phone;
  final int time;
  final bool isRepeat;

  ComeWithYouRequestEntity(
      {
       required this.vehicleId,
     required  this.categoryId,
     required  this.startLocation,
     required  this.targetLocation,
     required  this.from,
     required  this.to,
      this.passengers = 1,
     required  this.price,
    required   this.phone,
   required    this.time,
      this.isRepeat = false});

  
}