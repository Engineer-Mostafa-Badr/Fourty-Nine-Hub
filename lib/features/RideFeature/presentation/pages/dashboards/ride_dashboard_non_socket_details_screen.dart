import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/enums/support_status_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/support_details_entity.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_ride_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/support_screen/support_widget/custom_support_text_form_field.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/custom_color_circle_widget.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/helpers/responsive/responsive.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../domain/entities/dashboards/get_past_ride_non_socket_trip_entity.dart';
import '../../../domain/entities/dashboards/trip_entity.dart';
import '../../controllers/dashboards_cubit/dashboards_cubit.dart';
import 'widgets/problem_and_client_details.dart';
import 'widgets/ride_details_rating_widget.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_pdfview/flutter_pdfview.dart';

class RideDashboardNonSocketDetailsScreen extends StatefulWidget {
  const RideDashboardNonSocketDetailsScreen({super.key, required this.tripEntity,});
final HistoryTripEntity tripEntity;
  @override
  State<RideDashboardNonSocketDetailsScreen> createState() =>
      _RideDashboardNonSocketDetailsScreenState();
}

class _RideDashboardNonSocketDetailsScreenState
    extends State<RideDashboardNonSocketDetailsScreen> {
  bool isYourRate = false;
  double yourRate = 3.0;
  bool isClientRate = true;
  double clientRate = 4.0;
  var form = GlobalKey<FormState>();
  bool isLoading = false;
  String? pdfPath;

  initState(){
    context.read<DashboardsCubit>().getEmergencyDetails(context, SupportRideParams(
        clientId: 'widget.tripEntity.clientDetails?.id??''',
        // clientId: 'widget.tripEntity.clientDetails?.id??''',
        driverId: 'widget.tripEntity.driverDetails?.id??''',
        tripId: widget.tripEntity.tripDetails?.id??'',
        tripType: 'nonTracking',
        userType: 'driver'
    ));
    super.initState();
  }

  Future<String?> _generatePdf({SupportDetailsEntity? details, double? lat, double? lng}) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(level: 0, child: pw.Text('Client Details Report')),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    _buildTableRow('Field', 'Value', isHeader: true),
                    _buildTableRow('Client Name', details?.name ?? 'N/A'),
                    _buildTableRow('Client Phone', details?.phone ?? 'N/A'),
                    _buildTableRow('Email', details?.email ?? 'N/A'),
                    _buildTableRow('Device ID', details?.deviceId ?? 'N/A'),
                    _buildTableRow(
                        'Location',
                        'Latitude : $lat, Longitude: $lng',
                        isLink: true,
                        lat: lat,
                        lng: lng
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text('Generated on: ${DateTime.now().toString()}'),
              ],
            );
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/client_details.pdf");
      await file.writeAsBytes(await pdf.save());
      return file.path;
    } catch (e) {
      print('Error generating PDF: $e');
      return null;
    }
  }

  pw.TableRow _buildTableRow(
      String label,
      String value, {
        bool isHeader = false,
        bool isLink = false,
        double? lat,
        double? lng,
      }) {
    return pw.TableRow(
      children: [
        pw.Padding(
          child: pw.Text(label, style: isHeader
              ? pw.TextStyle(fontWeight: pw.FontWeight.bold)
              : null),
          padding: const pw.EdgeInsets.all(8),
        ),
        pw.Padding(
          child: isLink && lat != null && lng != null
              ? _buildLocationLink(value, lat, lng)
              : pw.Text(value, style: isHeader
              ? pw.TextStyle(fontWeight: pw.FontWeight.bold)
              : null),
          padding: const pw.EdgeInsets.all(8),
        ),
      ],
    );
  }

  pw.Widget _buildLocationLink(String text, double lat, double lng) {
    final url = 'https://www.google.com/maps?q=$lat,$lng';
    return pw.UrlLink(
      child: pw.Text(
        text,
        style: const pw.TextStyle(
          color: PdfColors.blue,
          decoration: pw.TextDecoration.underline,
        ),
      ),
      destination: url,
    );
  }

  void _showPdfPreview(BuildContext context, String path) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(context.isArabic?'تفاصيل العميل':'Client Details'),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: PDFView(
            filePath: path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            onRender: (pages) => print("PDF rendered with $pages pages"),
            onError: (error) => print("PDF error: $error"),
            onPageError: (page, error) => print("PDF page $page error: $error"),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.close.localize),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Printing.layoutPdf(
                onLayout: (_) => File(path).readAsBytes(),
              );
            },
            child: Text(context.isArabic?'طباعة':'Print'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(
        widget.tripEntity?.tripDetails?.createdAt ?? '2025-03-11T21:50:21.998Z');
    String formattedDate =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    // String formattedTime =
    //     "${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12} ${dateTime.hour < 12 ? 'AM' : 'PM'}";
    String formattedTime =
        "${(dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12)}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour < 12 ? 'AM' : 'PM'}";

    DateTime dateTimePickUp = DateTime.parse(
        widget.tripEntity?.tripDetails?.pickupTime ?? '2025-03-11T21:50:21.998Z');
    String formattedDatePickUp =
        "${dateTimePickUp.day.toString().padLeft(2, '0')}/${dateTimePickUp.month.toString().padLeft(2, '0')}/${dateTimePickUp.year}";
    // String formattedTimePickUp =
    //     "${dateTimePickUp.hour % 12 == 0 ? 12 : dateTimePickUp.hour % 12} ${dateTimePickUp.hour < 12 ? 'AM' : 'PM'}";
    String formattedTimePickUp =
        "${(dateTimePickUp.hour % 12 == 0 ? 12 : dateTimePickUp.hour % 12)}:${dateTimePickUp.minute.toString().padLeft(2, '0')} ${dateTimePickUp.hour < 12 ? 'AM' : 'PM'}";

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leadingWidth: 30,
          title: Label(
              text:
                  LocaleKeys.rideDetails.tr(),

              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 20))),
      body: SingleChildScrollView(
        child: BlocBuilder<DashboardsCubit, DashboardsState>(
          builder: (context,state) {
            var cubit = context.read<DashboardsCubit>();
            if(state.isLoading){
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                              spacing: 2,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Label(
                                    text:( context.isArabic ? widget.tripEntity.subCategory?.nameAr  :  widget.tripEntity.subCategory?.nameEn ) ?? LocaleKeys.captainWithYou.tr() ,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 20),
                                    maxLines: 3),
                                const SizedBox(height: 8),
                                Row(
                                  spacing: 5,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Label(
                                      text: formattedDate, //'20/2/2025',
                                      style: Styles.mediumText(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text("-", style: Styles.mediumText(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 50.sp
                                    ),),
                                    Label(
                                      text: formattedTime, //'10 AM',
                                      style: Styles.mediumText(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Label(
                                    text: "${widget.tripEntity.tripDetails!.price} ${LocaleKeys.egp.tr()}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 16)),
                              ]),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: ImageFromInternet(
                             image: widget.tripEntity.subCategory?.pictureUrl ?? "",
                              width: 80,
                              height: 33,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // if (widget.tripEntity.modeType != 'ride')
                    Label(
                        text: "${LocaleKeys.passenger.tr()} : ${widget.tripEntity.tripDetails?.passengers ?? 0}"
                          ,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                   Row(
                    spacing: 18,
                    children: [
                      const CustomColorCircleWidget(
                        firstColor: AppColors.c19D176,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Label(
                            //   text: "Cairo International Airport",
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.w600,
                            //     fontSize: 14,
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 2,
                            // ),
                            Label(
                              text: widget.tripEntity.tripDetails?.startLocation?.title ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                       Label(
                        text: formattedTime,
                        style: TextStyle(
                            color: AppColors.c5A5A5A,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                   Row(
                    spacing: 18,
                    children: [
                      const CustomColorCircleWidget(
                        firstColor: AppColors.c3897F0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Label(
                              text: widget.tripEntity.tripDetails?.targetLocation?.title ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                       Label(
                        text: formattedTimePickUp,
                        style: TextStyle(
                            color: AppColors.c5A5A5A,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Text("${widget.tripEntity.tripDetails?.yourRating?.average}"),
                  RideDetailsRatingNonSocketWidget(
                    // isRate: widget.tripEntity.tripDetails?.rating?.client?.count != null,
                    // rate: 1,
                    rate: widget.tripEntity.tripDetails?.yourRateClient?.rate?.toDouble() ?? 0.0,
                    title: LocaleKeys.youRateClient.tr(),
                    tripId: widget.tripEntity.tripDetails?.id ?? '',
                    cubit: context.read<DashboardsCubit>(),
                  ),
                  RideDetailsRatingNonSocketWidget(
                    // isRate: widget.tripEntity.tripDetails?.rating?.client?.count != null,
                    // rate: 2,
                    rate: widget.tripEntity.tripDetails?.yourRateClient?.rate?.toDouble() ?? 0.0,
                    title: LocaleKeys.clientRateYou.tr(),
                    tripId: widget.tripEntity.tripDetails?.id ?? '',
                    cubit: context.read<DashboardsCubit>(),
                    isClient: true,
                  ),
                  // RideDetailsRatingWidget(
                  //     isRate: isClientRate,
                  //     rate: clientRate,
                  //     title: LocaleKeys.clientRateYou.tr()),
                  if(!(state.supportStatus == RequestEmergencyStatus.approved.status))Form(
                    key: form,
                    child: Column(
                      children: [
                        CustomSupportTextField(
                          hintText: LocaleKeys.writeYourProblem.localize,
                          enabled: state.supportStatus == RequestEmergencyStatus.noRequest.status,
                          controller: cubit.supportDescriptionController, validator: (String? value) {
                          if (value!.isEmpty) {
                            return context.isArabic? 'الرجاء ادخال المشكلة' : 'Please enter your problem';
                          }
                          return null;
                        },
                        ),
                        SizedBox(height: 16.h),
                        CustomSupportTextField(
                          hintText: LocaleKeys.writeYourPhoneNumber.localize,
                          enabled: state.supportStatus == RequestEmergencyStatus.noRequest.status,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          controller: cubit.supportPhoneController, validator: (String? value) {
                          if (value!.isEmpty) {
                            return context.isArabic? 'الرجاء ادخال رقم الهاتف' : 'Please enter your phone number';
                          }
                          return null;
                        },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: state.isLoadingSubmitRequest? const Center(child: CircularProgressIndicator()): ElevatedButton(
                            onPressed: () {
                              if(state.supportStatus == RequestEmergencyStatus.noRequest.status){
                                if(form.currentState!.validate()){
                                  cubit.requestEmergencySupport(context: context, clientId: widget.tripEntity.clientDetails?.id??'', driverId: widget.tripEntity.driverDetails?.id??'', tripId: widget.tripEntity.tripDetails?.id??'', userType: 'driver',tripType: 'nonTracking');
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: state.supportStatus == RequestEmergencyStatus.pending.status ? AppColors.PRIMARY_COLOR.withOpacity(.7) : AppColors.PRIMARY_COLOR,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              state.supportStatus == RequestEmergencyStatus.pending.status ? LocaleKeys.requestSent.localize : LocaleKeys.requestEmergencySupport.localize,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        if (state.supportStatus == RequestEmergencyStatus.pending.status)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  LocaleKeys.waitingApproval.localize,
                                  style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // const ProblemAndClientDetails()
                  if(state.supportStatus == RequestEmergencyStatus.approved.status)Padding(
                    padding: EdgeInsets.only(bottom: 16.hs),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            LocaleKeys.clientDetails.localize,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildLabel(LocaleKeys.clientName.localize),
                        CustomSupportTextField(enabled: false,validator: (String? value) {  },hintText: LocaleKeys.enterYourName.localize, controller: TextEditingController(text: state.supportDetails?.name??'')),
                        const SizedBox(height: 16),
                        _buildLabel(LocaleKeys.clientPhone.localize),
                        CustomSupportTextField(enabled: false,validator: (String? value) {  },hintText: LocaleKeys.enterYourPhoneNumber.localize, controller: TextEditingController(text: state.supportDetails?.phone??'')),
                        const SizedBox(height: 16),
                        _buildLabel(LocaleKeys.email.localize),
                        CustomSupportTextField(enabled: false,validator: (String? value) {  },hintText: LocaleKeys.enterYourEmail.localize, controller: TextEditingController(text: state.supportDetails?.email??'')),
                        const SizedBox(height: 16),
                        _buildLabel(LocaleKeys.deviceID.localize),
                        CustomSupportTextField(enabled: false,validator: (String? value) {  },hintText: LocaleKeys.enterYourDeviceID.localize, controller: TextEditingController(text: state.supportDetails?.deviceId??'')),
                        const SizedBox(height: 30),
                        isLoading? const Center(child: CircularProgressIndicator()): ElevatedButton.icon(
                          onPressed: () async {
                            setState(() => isLoading = true);
                            final path = await _generatePdf(details:state.supportDetails,lat:31.2802705,lng: 31.6775629);
                            setState(() {
                              pdfPath = path;
                              isLoading = false;
                            });

                            if (path != null) {
                              _showPdfPreview(context, path);
                            }
                            context.push(Routes.emergencyContactsScreen);
                          },
                          icon: const Icon(Icons.download, color: Colors.white),
                          label: Text(LocaleKeys.locationLog.localize),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.PRIMARY_COLOR,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
