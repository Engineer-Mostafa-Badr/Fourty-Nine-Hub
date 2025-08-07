import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/trip_receipt.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/history_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/person_trip_widget.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../common/widgets/form/text_fields/default_text_form_field.dart';
import '../../../../common/widgets/form/text_fields/new_phone_number_text_field.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/validator.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../routes/routes.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class RideHistoryDetailsScreenParams {
  final RideCubit rideCubit;
  final HistoryTripsEntity historyTripEntity;
  RideHistoryDetailsScreenParams(
      {required this.rideCubit, required this.historyTripEntity});
}

class RideHistoryDetailsScreen extends StatefulWidget {
  final RideHistoryDetailsScreenParams params;
  const RideHistoryDetailsScreen({super.key, required this.params});

  @override
  _RideHistoryDetailsScreenState createState() =>
      _RideHistoryDetailsScreenState();
}

class _RideHistoryDetailsScreenState extends State<RideHistoryDetailsScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
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
      ManageVibration.vibrate();
                  Navigator.pop(context);
                },
              ),
              title: Transform(
                transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                child: Text(
                  context.isArabic ? "تفاصيل الرحلة" : "Ride Details",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 24),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.isArabic
                                    ? "${widget.params.historyTripEntity.subCategoryNameAr ?? ''} رحلة مع ${widget.params.historyTripEntity.driverFirstName}"
                                    : '${widget.params.historyTripEntity.subCategoryNameEn ?? ''} ride with ${widget.params.historyTripEntity.driverFirstName}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatDateTime(
                                    context,
                                    widget.params.historyTripEntity.createdAt ??
                                        DateTime.now()),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PersonTripWidget(
                        image:
                            widget.params.historyTripEntity.subCategoryPicture,
                        name: context.isArabic
                            ? widget.params.historyTripEntity.subCategoryNameAr
                            : widget.params.historyTripEntity.subCategoryNameEn,
                        rate: widget
                            .params.historyTripEntity.driverAverageRating
                            ?.toString(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '${FormatNumbers().convertNumberToLocalizedString(widget.params.historyTripEntity.price?.toInt().toString() ?? '', isArabic: context.isArabic)} ${context.isArabic ? "ج.م" : "EGP"}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
      ManageVibration.vibrate();
                        context.push(Routes.TripReceiptScreen,
                            extra: TripReceiptScreenParams(
                              rideCubit: serviceLocator<RideCubit>(),
                              historyTripEntity:
                                  widget.params.historyTripEntity,
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.cF5F5F5,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.receipt_long, color: AppColors.black),
                            const SizedBox(width: 8),
                            Text(
                              context.isArabic ? "الفاتورة" : "Receipt",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PriceColumn(
                      startAddressTitle: widget
                          .params.historyTripEntity.startLocationAddressTitle,
                      targetAddressTitle: widget
                          .params.historyTripEntity.targetLocationAddressTitle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          context.isArabic ? "لا يوجد تقييم" : "No rating",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.cF5F5F5,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            context.isArabic ? "تقييم" : "Rate",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          context.isArabic
                              ? "تقييم السائق لك"
                              : "Driver rate you",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Text(
                              widget.params.historyTripEntity
                                          .driverAverageRating !=
                                      null
                                  ? getRatingText(widget.params
                                      .historyTripEntity.driverAverageRating!)
                                  : LocaleKeys.noRating.localize,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (widget.params.historyTripEntity
                                    .driverAverageRating !=
                                null)
                              RatingBar.builder(
                                initialRating: widget.params.historyTripEntity
                                    .driverAverageRating!,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 16,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {});
                                },
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                  if (widget.params.historyTripEntity.recordUrl != null)
                    VoiceMessageWidget(
                      audioUrl: widget.params.historyTripEntity.recordUrl!,
                    ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DefaultTextFormField(
                      hint: context.isArabic
                          ? "اكتب مشكلتك"
                          : "Write your problem",
                      currentController: _problemController,
                      borderColor: AppColors.cD9D9D9.withValues(alpha: 0.5),
                      fillColor: AppColors.cD9D9D9.withValues(alpha: 0.5),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: NewPhoneNumberTextFormField(
                      currentController:
                          _phoneController, // Use the class-level controller
                      keyboardType: TextInputType.number,
                      borderColor: AppColors.cD9D9D9.withValues(alpha: 0.5),
                      fillColor: AppColors.cD9D9D9.withValues(alpha: 0.5),
                      validator: validatorEgyptPhone,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: AppButton(
                      radius: 15,
                      backColor: AppColors.PRIMARY_COLOR,
                      label: context.isArabic
                          ? "طلب دعم الطوارئ"
                          : "Request emergency support",
                      onPressed: () {

      ManageVibration.vibrate();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String getRatingText(double rating) {
    if (rating >= 5.0) return LocaleKeys.excellent.localize;
    if (rating >= 4.0) return LocaleKeys.veryGood.localize;
    if (rating >= 3.0) return LocaleKeys.good.localize;
    if (rating >= 2.0) return LocaleKeys.poor2.localize;
    if (rating >= 1.0) return LocaleKeys.bad.localize;
    return LocaleKeys.noRating.localize;
  }

  String formatDateTime(BuildContext context, DateTime dateTime) {
    // Check language based on context
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // Define date format based on language
    final dateFormat = DateFormat('MMM d - hh:mm a', isArabic ? 'ar' : 'en');

    return dateFormat.format(dateTime);
  }
}

class PriceColumn extends StatelessWidget {
  final String? startAddressTitle;
  final String? targetAddressTitle;

  const PriceColumn({
    super.key,
    required this.startAddressTitle,
    required this.targetAddressTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (startAddressTitle != null)
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.c19D176,
                size: 18,
              ),
              const SizedBox(width: 4),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                child: Label(
                  text: startAddressTitle!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 8),
        if (targetAddressTitle != null)
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.blueColor,
                size: 18,
              ),
              const SizedBox(width: 4),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                child: Label(
                  text: targetAddressTitle!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class VoiceMessageWidget extends StatefulWidget {
  final String audioUrl;

  const VoiceMessageWidget({super.key, required this.audioUrl});

  @override
  State<VoiceMessageWidget> createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget> {
  late AudioPlayer _player;
  bool isPlaying = false;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    await _player.setUrl(widget.audioUrl);
    duration = _player.duration ?? Duration.zero;

    _player.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.mic, color: AppColors.PRIMARY_COLOR_DARK),
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () {
      ManageVibration.vibrate();
              isPlaying ? _player.pause() : _player.play();
            },
          ),
          // Simulated waveform
          Expanded(
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _waveformData.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Container(
                    width: 3,
                    height: _waveformData[i],
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(_formatDuration(duration)),
          const SizedBox(width: 8),
          IconButton(
            padding: const EdgeInsets.all(0),
            icon: const Icon(
              Icons.file_download,
              color: AppColors.PRIMARY_COLOR,
            ),
            onPressed: () {

      ManageVibration.vibrate();
            },
          ),
        ],
      ),
    );
  }

  final List<double> _waveformData = List.generate(
    60,
    (i) => 20 + 15 * (1 + (i % 20 - 10).abs() / 10),
  );
}