import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trips_entity.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/format_numbers.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../presentation/controllers/cubits/ride_cubit.dart';

class TripReceiptScreenParams {
  final RideCubit rideCubit;
  final HistoryTripsEntity historyTripEntity;
  TripReceiptScreenParams(
      {required this.rideCubit, required this.historyTripEntity});
}

class TripReceiptScreen extends StatefulWidget {
  final TripReceiptScreenParams params;
  const TripReceiptScreen({super.key, required this.params});

  @override
  _TripReceiptScreenState createState() => _TripReceiptScreenState();
}

class _TripReceiptScreenState extends State<TripReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.params.rideCubit,
      child: Builder(
        builder: (context) {
          return CustomScaffold(
            appBar: AppBar(
              titleSpacing: 0,
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Transform(
                transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                child: Text(
                  context.isArabic ? "الفاتورة" : "Receipt",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 24),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(

                children: [
                  Container(
                    color: AppColors.PRIMARY_COLOR,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatFullDate(
                                      widget.params.historyTripEntity
                                              .createdAt ??
                                          DateTime.now(),
                                      context),
                                  style:  TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  context.isArabic? "شكرا لاستخدامك, ${widget.params.historyTripEntity.subCategoryNameAr ?? ""}" : "Thank you for riding, ${widget.params.historyTripEntity.subCategoryNameEn ?? ""}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if(widget.params.historyTripEntity.subCategoryPicture != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.network(
                            widget.params.historyTripEntity.subCategoryPicture!,
                            height: 50,
                            width: 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    context.isArabic? "الأجمالي" : "Total",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                        FormatNumbers().convertNumberToLocalizedString(widget.params.historyTripEntity.price?.toInt().toString() ?? '', isArabic: context.isArabic),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          context.isArabic ? "ج.م" : "EGP",
                          style:  TextStyle(
                            fontSize: 18,
                            color: AppColors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                      ),
                      Text(
                        context.isArabic? "الدفع" : "Payment",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        SvgPicture.asset(Assets.cash),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          context.isArabic? "نقدي" : "Cash",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Text(
                          FormatNumbers().convertNumberToLocalizedString(widget.params.historyTripEntity.price?.toInt().toString() ?? '', isArabic: context.isArabic),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          context.isArabic ? "ج.م" : "EGP",
                          style:  TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String formatFullDate(DateTime date, BuildContext context) {
    final locale = context.isArabic ? 'ar' : 'en';
    return DateFormat('d MMMM y', locale).format(date);
  }
}
