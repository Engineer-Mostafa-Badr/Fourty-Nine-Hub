import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';

class GetAllTripRiderCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetAllTripRiderCubit({required this.repository}) : super(RiderInitial());
  getAllTrip() {
    emit(LoadingRiderState());
    repository.getAllTripSocket(
      (data) {
        emit(SuccessGetAllTripsRiderState(list: data));
      },
    );
  }
}

// {
//   "startLocation": {
//     "type":"Point",
//     "coordinates": [31.261392,29.962565]
//   },
//   "targetLocation": {
//     "type":"Point",
//     "coordinates":[30.098281,31.329383]
//   },
//   "_id": "67241330a1a0c98c23583b84",
//   "userId": {
//     "_id":"66b4659d1c9c4b1cb35bfee4",
//     "firstName":"zyad",
//     "lastName":"mohamed",
//     "email":"zyadmohamed122232@gmail.com",
//     "gender":"male",
//     "USER_PROFILE":{
//       "_id":
//       "66b4659d1c9c4b1cb35bfee6",
//       "userId":"66b4659d1c9c4b1cb35bfee4",
//       "profilePictureKey":"66a4ee09e0f15662b542e239"
//     },
//     "id":"66b4659d1c9c4b1cb35bfee4"
//   },
//   "riderId":null,
//   "subCategoryId":{
//     "_id":
//     "62c8ba9f8e28a58a3edf57eb",
//     "nameAr":"كابتن",
//     "nameEn":"Captain"
//   },
//   "carTypeId":null,
//   "fromTitle":"5 القنال، معادي السرايات الغربية، قسم المعادي، محافظة القاهرة 4212220، مصر",
//   "toTitle":"19 شارع دمنهور، البستان، قسم مصر الجديدة، محافظة القاهرة 4460313، مصر",
//   "profit":0,
//   "autoAccept":false,
//   "isPremium":false,
//   "distance":25708,
//   "duration":2304,
//   "passengers":4,
//   "price":125,
//   "calculateB":0,
//   "paymentMethod":"cash",
//   "status":"pending",
//   "penalty":0,
//   "payed_penalty":false,
//   "isUserGetCashback":false,
//   "isRiderGetCashback":false,
//   "OTP":"",
//   "createdAt":"2024-10-31T23:30:56.012Z",
//   "updatedAt":"2024-10-31T23:30:56.012Z"
//   }
