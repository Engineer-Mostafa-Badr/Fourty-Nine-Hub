part of 'payment_cubit.dart';

class PaymentState {
  final StateStatus? status;
  final StateStatus instaPayStatus;
  final Failure? failure;
  final List<PaymentProviderEntity>? data;
  final PaymobEntity? paymobData;
  final FawryPayWithCardEntity? fawryPayWithCardData;
  final FawryCardTokenResponseEntity? fawryCardTokenResponseData;
  final List<CardEntity>? savedCardsData;
  final DeleteCardResponse? deleteCardResponse;
  final MutliPaymentResponse? mutliPaymentResponse;
  final File? uploadedImage;
  final StateStatus? uploadStatus;
  final File? selectedImage;
  final String? imageMediaId;
  final InstaPayResponseEntity? instaPayResponseData;
  final PayWithTokenResponseEntity? payWithTokenResponseData;

  PaymentState({
    this.status,
    this.instaPayStatus = StateStatus.initial,
    this.failure,
    this.data,
    this.paymobData,
    this.fawryPayWithCardData,
    this.fawryCardTokenResponseData,
    this.savedCardsData,
    this.deleteCardResponse,
    this.mutliPaymentResponse,
    this.uploadedImage,
    this.uploadStatus,
    this.selectedImage,
    this.imageMediaId,
    this.instaPayResponseData,
    this.payWithTokenResponseData,
  });

  PaymentState copyWith({
    StateStatus? status,
    StateStatus? instaPayStatus,
    Failure? failure,
    List<PaymentProviderEntity>? data,
    PaymobEntity? paymobData,
    FawryPayWithCardEntity? fawryPayWithCardData,
    FawryCardTokenResponseEntity? fawryCardTokenResponseData,
    List<CardEntity>? savedCardsData,
    DeleteCardResponse? deleteCardResponse,
    MutliPaymentResponse? mutliPaymentResponse,
    File? uploadedImage,
    StateStatus? uploadStatus,
    File? selectedImage,
    String? imageMediaId,
    InstaPayResponseEntity? instaPayResponseData,
    PayWithTokenResponseEntity? payWithTokenResponseData,
  }) {
    return PaymentState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      data: data ?? this.data,
      paymobData: paymobData ?? this.paymobData,
      fawryPayWithCardData: fawryPayWithCardData ?? this.fawryPayWithCardData,
      fawryCardTokenResponseData:
          fawryCardTokenResponseData ?? this.fawryCardTokenResponseData,
      savedCardsData: savedCardsData ?? this.savedCardsData,
      deleteCardResponse: deleteCardResponse ?? this.deleteCardResponse,
      mutliPaymentResponse: mutliPaymentResponse ?? this.mutliPaymentResponse,
      uploadedImage: uploadedImage ?? this.uploadedImage,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      selectedImage: selectedImage ?? this.selectedImage,
      imageMediaId: imageMediaId ?? this.imageMediaId,
      instaPayResponseData: instaPayResponseData ?? this.instaPayResponseData,
      payWithTokenResponseData:
          payWithTokenResponseData ?? this.payWithTokenResponseData,
    );
  }
}
