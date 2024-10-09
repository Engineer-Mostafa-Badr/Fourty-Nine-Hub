 part of 'payment_cubit.dart';
 enum StateStatus {
   initial,
   loading,
   success,
   success1,
   updated,
   error,
 }

class PaymentCacheOutState {
  final StateStatus? status;
  final Failure? failure;
  final InstapayCacheOutEntity? instaPay;
  final List<UploadFileEntity>? images;
  final UploadFileEntity? frontImage;
  final UploadFileEntity? backImage;
  final WalletHomeEntity? wallet;
  final List<ListBankEntity>?banks;
  final PriceYellowCardEntity? price;
  String? backColor;

  PaymentCacheOutState({
    this.status,
    this.failure,
    this.instaPay,
    this.images,
    this.frontImage,
    this.backImage,
    this.wallet,
    this.banks,
    this.price,
    this.backColor = "#FFFFFFFF",
  });

  PaymentCacheOutState copyWith({
    StateStatus? status,
    Failure? failure,
    InstapayCacheOutEntity? instaPay,
    List<UploadFileEntity>? images,
    UploadFileEntity? frontImage,
    UploadFileEntity? backImage,
     WalletHomeEntity? wallet,
    List<ListBankEntity>?banks,
    PriceYellowCardEntity? price,
    String? backColor,
  }) {
    return PaymentCacheOutState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      instaPay: instaPay ?? this.instaPay,
      images: images ?? this.images,
      frontImage: frontImage ?? this.frontImage,
      backImage: backImage ?? this.backImage,
      backColor: backColor ?? this.backColor,
      wallet: wallet ?? this.wallet,
      banks: banks ?? this.banks,
      price: price ?? this.price,
    );
  }
}


