// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/get_wallet_state.dart';
//
// import '../../../data/repositories/wallet_repository.dart';
//
// class GetWalletCubit extends Cubit<GetWalletState> GetWalletState{
//   final WalletRepository repository;
//   GetWalletCubit(this.repository) : super(GetWalletInitial());
//   getWallet() async {
//     // log("4444444444444444444444444444");
//     var response = await repository.getWallet();
//     response.fold(
//       (error) {
//         // log(error.toString(), name: "WalletError");
//         emit(FilauerGetWallatState());
//       },
//       (data) {
//         // log(data.toString(), name: "WalletError");
//         emit(SuccessGetWallet(model: data));
//       },
//     );
//   }
// }
