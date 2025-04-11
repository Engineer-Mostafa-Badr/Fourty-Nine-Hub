import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';

import '../../../../../res/strings/labels.dart';
import '../../../domain/entities/status_all_services_entity.dart';
import '../../../domain/usecases/get_status_all_services_usecase.dart';

part 'get_status_all_services_notifications_state.dart';

class GetStatusAllServicesNotificationsCubit
    extends Cubit<GetStatusAllServicesNotificationsState> {
  final GetStatusAllServicesUseCase getStatusAllServicesUseCase;

  GetStatusAllServicesNotificationsCubit(
    this.getStatusAllServicesUseCase,
  ) : super(GetUserTripsNotificationsInitial());

  List<Map<String, String>> status = [];

  Future<void> getStatusAllServices() async {
    emit(GetUserTripsNotificationsLoading());
    final result = await getStatusAllServicesUseCase(const NoParams());
    result.fold(
        (l) => emit(GetUserTripsNotificationsFailed(Labels.errorHappened)),
        (r) {
      status = [
        {
          'nameEn': 'Ride Registration',
          'nameAr': 'تسجيل الرحلة',
          'valueEn': r.rideRegistration,
          'valueAr': _changeStatusLang(r.rideRegistration),
        },
        {
          'nameEn': 'Shipping Registration',
          'nameAr': 'تسجيل الشحن',
          'valueEn': r.shippingRegistration,
          'valueAr': _changeStatusLang(r.shippingRegistration),
          
        },
        {
          'nameEn': 'Restaurant Registration',
          'nameAr': 'تسجيل المطعم',
          'valueEn': r.restaurantRegistration,
          'valueAr': _changeStatusLang(r.restaurantRegistration),
          
        },
        {
          'nameEn': 'Health Registration',
          'nameAr': 'التسجيل الصحي',
          'valueEn': r.healthRegistration,
          'valueAr': _changeStatusLang(r.healthRegistration),
          
        },
        {
          'nameEn': 'Ads',
          'nameAr': 'تسجيل الإعلانات',
          'valueEn': r.adsRegistration,
          'valueAr': _changeStatusLang(r.adsRegistration),
          
        },
        {
          'nameEn': 'Company Ads',
          'nameAr': 'إعلانات الشركة',
          'valueEn': r.companyAdsRegistration,
          'valueAr': _changeStatusLang(r.companyAdsRegistration),
          
        },
        {
          'nameEn': 'Talent',
          'nameAr': 'المواهب',
          'valueEn': r.talentRegistration,
          'valueAr': _changeStatusLang(r.talentRegistration),
          
        },
        {
          'nameEn': 'Yellow Card',
          'nameAr': 'البطاقة الصفراء',
          'valueEn': r.yellowCardStatus,
          'valueAr': _changeStatusLang(r.yellowCardStatus),
          
        },
        {
          'nameEn': 'Bills',
          'nameAr': 'الفواتير',
          'valueEn': r.billsStatus,
          'valueAr': _changeStatusLang(r.billsStatus),
          
        },
        {
          'nameEn': 'Help',
          'nameAr': 'المساعدة',
          'valueEn': r.helpStatus,
          'valueAr': _changeStatusLang(r.helpStatus),
          
        },
        {
          'nameEn': 'Cashback Withdraw',
          'nameAr': 'سحب النقود المستردة',
          'valueEn': r.cashbackWithdrawStatus,
          'valueAr': _changeStatusLang(r.cashbackWithdrawStatus),
          
        },
        {
          'nameEn': 'Wallet Withdraw',
          'nameAr': 'سحب المحفظة',
          'valueEn': r.walletWithdrawStatus,
          'valueAr': _changeStatusLang(r.walletWithdrawStatus),
          
        },
        {
          'nameEn': 'Report',
          'nameAr': 'التقرير',
          'valueEn': r.reportStatus,
          'valueAr': _changeStatusLang(r.reportStatus),
        },
        {
          'nameEn': 'Gift Transfer',
          'nameAr': 'نقل الهدايا',
          'valueEn': r.giftTransfer,
          'valueAr': _changeStatusLang(r.giftTransfer),
          
        },
      ];
      emit(GetUserTripsNotificationsSuccess(r));
    });
  }

  String _changeStatusLang(String status) {
    const statusMap = {
      'Not Used': 'لم يتم استخدامها',
      'Approved': 'موافقة',
      'Active': 'نشط',
      'Waiting Approval': 'انتظار الموافقة',
      'Rejected': 'مرفوض',
      'Submitted': 'تم التقديم',
    };
    return statusMap[status] ?? status;
  }
}
