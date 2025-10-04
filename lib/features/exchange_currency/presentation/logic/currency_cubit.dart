import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/exchange_rate_entity.dart';
import '../../domain/entities/currency_rates_entity.dart';
import '../../domain/entities/currency_entity.dart';
import '../../domain/usecases/convert_currency_usecase.dart';
import '../../domain/usecases/get_exchange_rates_usecase.dart';
part 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  final ConvertCurrencyUseCase convertCurrencyUseCase;
  final GetExchangeRatesUseCase getExchangeRatesUseCase;

  CurrencyCubit({
    required this.convertCurrencyUseCase,
    required this.getExchangeRatesUseCase,
  }) : super(CurrencyInitial()) {
    _loadSettings().then((_) => _startAutoRefresh());
  }

  String _fromCurrency = 'USD';
  String _toCurrency = 'AED';
  double _amount = 1000.0;
  ExchangeRateEntity? _lastExchangeRate;
  CurrencyRatesEntity? _allRates;

  // Auto-refresh variables
  Timer? _refreshTimer;
  Duration _refreshInterval = const Duration(hours: 1);
  DateTime? _lastUpdateTime;
  bool _autoRefreshEnabled = true;
  bool _isAppInBackground = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  // SharedPreferences keys
  static const String _autoRefreshKey = 'auto_refresh_enabled';
  static const String _refreshIntervalKey = 'refresh_interval_minutes';
  static const String _fromCurrencyKey = 'from_currency';
  static const String _toCurrencyKey = 'to_currency';
  static const String _lastAmountKey = 'last_amount';

  // Getters
  String get fromCurrency => _fromCurrency;
  String get toCurrency => _toCurrency;
  double get amount => _amount;
  ExchangeRateEntity? get lastExchangeRate => _lastExchangeRate;
  CurrencyRatesEntity? get allRates => _allRates;
  bool get autoRefreshEnabled => _autoRefreshEnabled;
  DateTime? get lastUpdateTime => _lastUpdateTime;
  Duration get refreshInterval => _refreshInterval;

  // Available currencies
  final List<CurrencyEntity> availableCurrencies = [
    CurrencyEntity(code: 'USD', name: 'US Dollar', nameAr: 'الدولار الأمريكي', flag: '🇺🇸', countryName: 'United States', countryNameAr: 'أمريكا'),
    CurrencyEntity(code: 'EUR', name: 'Euro', nameAr: 'اليورو', flag: '🇪🇺', countryName: 'European Union', countryNameAr: 'أوروبا'),
    CurrencyEntity(code: 'GBP', name: 'British Pound', nameAr: 'الجنيه الإسترليني', flag: '🇬🇧', countryName: 'United Kingdom', countryNameAr: 'بريطانيا'),
    CurrencyEntity(code: 'JPY', name: 'Japanese Yen', nameAr: 'الين الياباني', flag: '🇯🇵', countryName: 'Japan', countryNameAr: 'اليابان'),
    CurrencyEntity(code: 'AUD', name: 'Australian Dollar', nameAr: 'الدولار الأسترالي', flag: '🇦🇺', countryName: 'Australia', countryNameAr: 'أستراليا'),
    CurrencyEntity(code: 'CAD', name: 'Canadian Dollar', nameAr: 'الدولار الكندي', flag: '🇨🇦', countryName: 'Canada', countryNameAr: 'كندا'),
    CurrencyEntity(code: 'CHF', name: 'Swiss Franc', nameAr: 'الفرنك السويسري', flag: '🇨🇭', countryName: 'Switzerland', countryNameAr: 'سويسرا'),
    CurrencyEntity(code: 'CNY', name: 'Chinese Yuan', nameAr: 'اليوان الصيني', flag: '🇨🇳', countryName: 'China', countryNameAr: 'الصين'),
    CurrencyEntity(code: 'SEK', name: 'Swedish Krona', nameAr: 'الكرونا السويدية', flag: '🇸🇪', countryName: 'Sweden', countryNameAr: 'السويد'),
    CurrencyEntity(code: 'NZD', name: 'New Zealand Dollar', nameAr: 'الدولار النيوزيلندي', flag: '🇳🇿', countryName: 'New Zealand', countryNameAr: 'نيوزيلندا'),
    CurrencyEntity(code: 'MXN', name: 'Mexican Peso', nameAr: 'البيزو المكسيكي', flag: '🇲🇽'),
    CurrencyEntity(code: 'SGD', name: 'Singapore Dollar', nameAr: 'دولار سنغافورة', flag: '🇸🇬'),
    CurrencyEntity(code: 'HKD', name: 'Hong Kong Dollar', nameAr: 'دولار هونغ كونغ', flag: '🇭🇰'),
    CurrencyEntity(code: 'NOK', name: 'Norwegian Krone', nameAr: 'الكرونا النرويجية', flag: '🇳🇴'),
    CurrencyEntity(code: 'KRW', name: 'South Korean Won', nameAr: 'الوون الكوري الجنوبي', flag: '🇰🇷'),
    CurrencyEntity(code: 'TRY', name: 'Turkish Lira', nameAr: 'الليرة التركية', flag: '🇹🇷'),
    CurrencyEntity(code: 'RUB', name: 'Russian Ruble', nameAr: 'الروبل الروسي', flag: '🇷🇺'),
    CurrencyEntity(code: 'INR', name: 'Indian Rupee', nameAr: 'الروبية الهندية', flag: '🇮🇳'),
    CurrencyEntity(code: 'BRL', name: 'Brazilian Real', nameAr: 'الريال البرازيلي', flag: '🇧🇷'),
    CurrencyEntity(code: 'ZAR', name: 'South African Rand', nameAr: 'الراند الجنوب أفريقي', flag: '🇿🇦'),
    CurrencyEntity(code: 'PLN', name: 'Polish Zloty', nameAr: 'الزلوتي البولندي', flag: '🇵🇱'),
    CurrencyEntity(code: 'EGP', name: 'Egyptian Pound', nameAr: 'الجنيه المصري', flag: '🇪🇬', countryName: 'Egypt', countryNameAr: 'مصر'),
    CurrencyEntity(code: 'AED', name: 'UAE Dirham', nameAr: 'الدرهم الإماراتي', flag: '🇦🇪', countryName: 'United Arab Emirates', countryNameAr: 'الإمارات'),
    CurrencyEntity(code: 'SAR', name: 'Saudi Riyal', nameAr: 'الريال السعودي', flag: '🇸🇦', countryName: 'Saudi Arabia', countryNameAr: 'السعودية'),
    CurrencyEntity(code: 'QAR', name: 'Qatari Riyal', nameAr: 'الريال القطري', flag: '🇶🇦', countryName: 'Qatar', countryNameAr: 'قطر'),
    CurrencyEntity(code: 'KWD', name: 'Kuwaiti Dinar', nameAr: 'الدينار الكويتي', flag: '🇰🇼', countryName: 'Kuwait', countryNameAr: 'الكويت'),
    CurrencyEntity(code: 'BHD', name: 'Bahraini Dinar', nameAr: 'الدينار البحريني', flag: '🇧🇭', countryName: 'Bahrain', countryNameAr: 'البحرين'),
    CurrencyEntity(code: 'OMR', name: 'Omani Rial', nameAr: 'الريال العماني', flag: '🇴🇲', countryName: 'Oman', countryNameAr: 'عمان'),
    CurrencyEntity(code: 'JOD', name: 'Jordanian Dinar', nameAr: 'الدينار الأردني', flag: '🇯🇴', countryName: 'Jordan', countryNameAr: 'الأردن'),
    CurrencyEntity(code: 'LBP', name: 'Lebanese Pound', nameAr: 'الليرة اللبنانية', flag: '🇱🇧'),
    CurrencyEntity(code: 'IQD', name: 'Iraqi Dinar', nameAr: 'الدينار العراقي', flag: '🇮🇶'),
    CurrencyEntity(code: 'IRR', name: 'Iranian Rial', nameAr: 'الريال الإيراني', flag: '🇮🇷'),
    CurrencyEntity(code: 'THB', name: 'Thai Baht', nameAr: 'الباهت التايلاندي', flag: '🇹🇭'),
    CurrencyEntity(code: 'MYR', name: 'Malaysian Ringgit', nameAr: 'الرنجت الماليزي', flag: '🇲🇾'),
    CurrencyEntity(code: 'IDR', name: 'Indonesian Rupiah', nameAr: 'الروبية الإندونيسية', flag: '🇮🇩'),
    CurrencyEntity(code: 'PHP', name: 'Philippine Peso', nameAr: 'البيزو الفلبيني', flag: '🇵🇭'),
    CurrencyEntity(code: 'VND', name: 'Vietnamese Dong', nameAr: 'الدونغ الفيتنامي', flag: '🇻🇳'),
    CurrencyEntity(code: 'TWD', name: 'Taiwan Dollar', nameAr: 'الدولار التايواني', flag: '🇹🇼'),
    CurrencyEntity(code: 'PKR', name: 'Pakistani Rupee', nameAr: 'الروبية الباكستانية', flag: '🇵🇰'),
    CurrencyEntity(code: 'BGN', name: 'Bulgarian Lev', nameAr: 'الليف البلغاري', flag: '🇧🇬'),
    CurrencyEntity(code: 'CZK', name: 'Czech Koruna', nameAr: 'الكورونا التشيكية', flag: '🇨🇿'),
    CurrencyEntity(code: 'HUF', name: 'Hungarian Forint', nameAr: 'الفورنت المجري', flag: '🇭🇺'),
    CurrencyEntity(code: 'RON', name: 'Romanian Leu', nameAr: 'الليو الروماني', flag: '🇷🇴'),
    CurrencyEntity(code: 'HRK', name: 'Croatian Kuna', nameAr: 'الكونا الكرواتية', flag: '🇭🇷'),
    CurrencyEntity(code: 'RSD', name: 'Serbian Dinar', nameAr: 'الدينار الصربي', flag: '🇷🇸'),
    CurrencyEntity(code: 'UAH', name: 'Ukrainian Hryvnia', nameAr: 'الهريفنيا الأوكرانية', flag: '🇺🇦'),
    CurrencyEntity(code: 'BYN', name: 'Belarusian Ruble', nameAr: 'الروبل البيلاروسي', flag: '🇧🇾'),
    CurrencyEntity(code: 'KZT', name: 'Kazakhstani Tenge', nameAr: 'التنغي الكازاخستاني', flag: '🇰🇿'),
    CurrencyEntity(code: 'UZS', name: 'Uzbekistani Som', nameAr: 'السوم الأوزبكستاني', flag: '🇺🇿'),
    CurrencyEntity(code: 'AZN', name: 'Azerbaijani Manat', nameAr: 'المانات الأذربيجاني', flag: '🇦🇿'),
    CurrencyEntity(code: 'GEL', name: 'Georgian Lari', nameAr: 'الاري الجورجي', flag: '🇬🇪'),
    CurrencyEntity(code: 'AMD', name: 'Armenian Dram', nameAr: 'الدرام الأرمني', flag: '🇦🇲'),
    CurrencyEntity(code: 'TMT', name: 'Turkmenistani Manat', nameAr: 'المانات التركمانستاني', flag: '🇹🇲'),
    CurrencyEntity(code: 'KGS', name: 'Kyrgyzstani Som', nameAr: 'السوم القيرغيزستاني', flag: '🇰🇬'),
    CurrencyEntity(code: 'TJS', name: 'Tajikistani Somoni', nameAr: 'السوموني الطاجيكستاني', flag: '🇹🇯'),
    CurrencyEntity(code: 'MDL', name: 'Moldovan Leu', nameAr: 'الليو المولدوفي', flag: '🇲🇩'),
    CurrencyEntity(code: 'MKD', name: 'Macedonian Denar', nameAr: 'الدينار المقدوني', flag: '🇲🇰'),
    CurrencyEntity(code: 'ALL', name: 'Albanian Lek', nameAr: 'الليك الألباني', flag: '🇦🇱'),
    CurrencyEntity(code: 'BAM', name: 'Bosnia-Herzegovina Convertible Mark', nameAr: 'المارك البوسني', flag: '🇧🇦'),
    CurrencyEntity(code: 'ISK', name: 'Icelandic Krona', nameAr: 'الكرونا الآيسلندية', flag: '🇮🇸'),
    CurrencyEntity(code: 'DKK', name: 'Danish Krone', nameAr: 'الكرونا الدنماركية', flag: '🇩🇰'),
    CurrencyEntity(code: 'CLP', name: 'Chilean Peso', nameAr: 'البيزو التشيلي', flag: '🇨🇱'),
    CurrencyEntity(code: 'COP', name: 'Colombian Peso', nameAr: 'البيزو الكولومبي', flag: '🇨🇴'),
    CurrencyEntity(code: 'PEN', name: 'Peruvian Sol', nameAr: 'السول البيروفي', flag: '🇵🇪'),
    CurrencyEntity(code: 'UYU', name: 'Uruguayan Peso', nameAr: 'البيزو الأوروغوياني', flag: '🇺🇾'),
    CurrencyEntity(code: 'PYG', name: 'Paraguayan Guarani', nameAr: 'الغواراني الباراغوياني', flag: '🇵🇾'),
    CurrencyEntity(code: 'BOB', name: 'Bolivian Boliviano', nameAr: 'البوليفيانو البوليفي', flag: '🇧🇴'),
    CurrencyEntity(code: 'VES', name: 'Venezuelan Bolívar', nameAr: 'البوليفار الفنزويلي', flag: '🇻🇪'),
    CurrencyEntity(code: 'GYD', name: 'Guyanese Dollar', nameAr: 'الدولار الغياني', flag: '🇬🇾'),
    CurrencyEntity(code: 'SRD', name: 'Surinamese Dollar', nameAr: 'الدولار السوريناميي', flag: '🇸🇷'),
    CurrencyEntity(code: 'AWG', name: 'Aruban Florin', nameAr: 'الفلورين الأروبي', flag: '🇦🇼'),
    CurrencyEntity(code: 'ANG', name: 'Netherlands Antillean Guilder', nameAr: 'الغيلدر الأنتيلي', flag: '🇨🇼'),
    CurrencyEntity(code: 'BBD', name: 'Barbadian Dollar', nameAr: 'الدولار الباربادي', flag: '🇧🇧'),
    CurrencyEntity(code: 'BZD', name: 'Belize Dollar', nameAr: 'الدولار البليزي', flag: '🇧🇿'),
    CurrencyEntity(code: 'BMD', name: 'Bermudian Dollar', nameAr: 'الدولار البرمودي', flag: '🇧🇲'),
    CurrencyEntity(code: 'BSD', name: 'Bahamian Dollar', nameAr: 'الدولار البهامي', flag: '🇧🇸'),
    CurrencyEntity(code: 'CUP', name: 'Cuban Peso', nameAr: 'البيزو الكوبي', flag: '🇨🇺'),
    CurrencyEntity(code: 'DOP', name: 'Dominican Peso', nameAr: 'البيزو الدومينيكاني', flag: '🇩🇴'),
    CurrencyEntity(code: 'GTQ', name: 'Guatemalan Quetzal', nameAr: 'الكيتزال الغواتيمالي', flag: '🇬🇹'),
    CurrencyEntity(code: 'HNL', name: 'Honduran Lempira', nameAr: 'الليمبيرا الهندوراسية', flag: '🇭🇳'),
    CurrencyEntity(code: 'HTG', name: 'Haitian Gourde', nameAr: 'الغورد الهايتي', flag: '🇭🇹'),
    CurrencyEntity(code: 'JMD', name: 'Jamaican Dollar', nameAr: 'الدولار الجمايكي', flag: '🇯🇲'),
    CurrencyEntity(code: 'KYD', name: 'Cayman Islands Dollar', nameAr: 'دولار جزر الكايمان', flag: '🇰🇾'),
    CurrencyEntity(code: 'NIO', name: 'Nicaraguan Córdoba', nameAr: 'الكوردوبا النيكاراغوية', flag: '🇳🇮'),
    CurrencyEntity(code: 'PAB', name: 'Panamanian Balboa', nameAr: 'البالبوا البنمية', flag: '🇵🇦'),
    CurrencyEntity(code: 'TTD', name: 'Trinidad & Tobago Dollar', nameAr: 'دولار ترينيداد وتوباغو', flag: '🇹🇹'),
    CurrencyEntity(code: 'XCD', name: 'East Caribbean Dollar', nameAr: 'دولار شرق الكاريبي', flag: '🇦🇬'),
    CurrencyEntity(code: 'AFN', name: 'Afghan Afghani', nameAr: 'الأفغاني الأفغانستاني', flag: '🇦🇫'),
    CurrencyEntity(code: 'BDT', name: 'Bangladeshi Taka', nameAr: 'التاكا البنغلاديشية', flag: '🇧🇩'),
    CurrencyEntity(code: 'BTN', name: 'Bhutanese Ngultrum', nameAr: 'النغولتروم البوتاني', flag: '🇧🇹'),
    CurrencyEntity(code: 'KHR', name: 'Cambodian Riel', nameAr: 'الريال الكمبودي', flag: '🇰🇭'),
    CurrencyEntity(code: 'LAK', name: 'Laotian Kip', nameAr: 'الكيب اللاوسي', flag: '🇱🇦'),
    CurrencyEntity(code: 'LKR', name: 'Sri Lankan Rupee', nameAr: 'الروبية السريلانكية', flag: '🇱🇰'),
    CurrencyEntity(code: 'MMK', name: 'Myanmar Kyat', nameAr: 'الكيات الميانماري', flag: '🇲🇲'),
    CurrencyEntity(code: 'MNT', name: 'Mongolian Tugrik', nameAr: 'التوغريك المنغولي', flag: '🇲🇳'),
    CurrencyEntity(code: 'MVR', name: 'Maldivian Rufiyaa', nameAr: 'الروفية المالديفية', flag: '🇲🇻'),
    CurrencyEntity(code: 'NPR', name: 'Nepalese Rupee', nameAr: 'الروبية النيبالية', flag: '🇳🇵'),
    CurrencyEntity(code: 'DZD', name: 'Algerian Dinar', nameAr: 'الدينار الجزائري', flag: '🇩🇿'),
    CurrencyEntity(code: 'AOA', name: 'Angolan Kwanza', nameAr: 'الكوانزا الأنغولية', flag: '🇦🇴'),
    CurrencyEntity(code: 'BWP', name: 'Botswanan Pula', nameAr: 'البولا البوتسوانية', flag: '🇧🇼'),
    CurrencyEntity(code: 'BIF', name: 'Burundian Franc', nameAr: 'الفرنك البوروندي', flag: '🇧🇮'),
    CurrencyEntity(code: 'CVE', name: 'Cape Verdean Escudo', nameAr: 'الإسكودو الرأس أخضري', flag: '🇨🇻'),
    CurrencyEntity(code: 'KMF', name: 'Comorian Franc', nameAr: 'الفرنك القمري', flag: '🇰🇲'),
    CurrencyEntity(code: 'CDF', name: 'Congolese Franc', nameAr: 'الفرنك الكونغولي', flag: '🇨🇩'),
    CurrencyEntity(code: 'DJF', name: 'Djiboutian Franc', nameAr: 'الفرنك الجيبوتي', flag: '🇩🇯'),
    CurrencyEntity(code: 'ERN', name: 'Eritrean Nakfa', nameAr: 'الناكفا الإريترية', flag: '🇪🇷'),
    CurrencyEntity(code: 'ETB', name: 'Ethiopian Birr', nameAr: 'البير الإثيوبي', flag: '🇪🇹'),
    CurrencyEntity(code: 'GMD', name: 'Gambian Dalasi', nameAr: 'الدالاسي الغامبي', flag: '🇬🇲'),
    CurrencyEntity(code: 'GHS', name: 'Ghanaian Cedi', nameAr: 'السيدي الغاني', flag: '🇬🇭'),
    CurrencyEntity(code: 'GNF', name: 'Guinean Franc', nameAr: 'الفرنك الغيني', flag: '🇬🇳'),
    CurrencyEntity(code: 'KES', name: 'Kenyan Shilling', nameAr: 'الشلن الكيني', flag: '🇰🇪'),
    CurrencyEntity(code: 'LSL', name: 'Lesotho Loti', nameAr: 'اللوتي الليسوتي', flag: '🇱🇸'),
    CurrencyEntity(code: 'LRD', name: 'Liberian Dollar', nameAr: 'الدولار الليبيري', flag: '🇱🇷'),
    CurrencyEntity(code: 'LYD', name: 'Libyan Dinar', nameAr: 'الدينار الليبي', flag: '🇱🇾'),
    CurrencyEntity(code: 'MGA', name: 'Malagasy Ariary', nameAr: 'الأرياري المدغشقري', flag: '🇲🇬'),
    CurrencyEntity(code: 'MWK', name: 'Malawian Kwacha', nameAr: 'الكواشا المالاوي', flag: '🇲🇼'),
    CurrencyEntity(code: 'MRU', name: 'Mauritanian Ouguiya', nameAr: 'الأوقية الموريتانية', flag: '🇲🇷'),
    CurrencyEntity(code: 'MUR', name: 'Mauritian Rupee', nameAr: 'الروبية الموريشية', flag: '🇲🇺'),
    CurrencyEntity(code: 'MAD', name: 'Moroccan Dirham', nameAr: 'الدرهم المغربي', flag: '🇲🇦'),
    CurrencyEntity(code: 'MZN', name: 'Mozambican Metical', nameAr: 'الميتيكال الموزمبيقي', flag: '🇲🇿'),
    CurrencyEntity(code: 'NAD', name: 'Namibian Dollar', nameAr: 'الدولار الناميبي', flag: '🇳🇦'),
    CurrencyEntity(code: 'NGN', name: 'Nigerian Naira', nameAr: 'النايرا النيجيرية', flag: '🇳🇬'),
    CurrencyEntity(code: 'RWF', name: 'Rwandan Franc', nameAr: 'الفرنك الرواندي', flag: '🇷🇼'),
    CurrencyEntity(code: 'STN', name: 'São Tomé & Príncipe Dobra', nameAr: 'الدوبرا', flag: '🇸🇹'),
    CurrencyEntity(code: 'SCR', name: 'Seychellois Rupee', nameAr: 'الروبية السيشلية', flag: '🇸🇨'),
    CurrencyEntity(code: 'SLE', name: 'Sierra Leonean Leone', nameAr: 'الليون السيراليوني', flag: '🇸🇱'),
    CurrencyEntity(code: 'SOS', name: 'Somali Shilling', nameAr: 'الشلن الصومالي', flag: '🇸🇴'),
    CurrencyEntity(code: 'SSP', name: 'South Sudanese Pound', nameAr: 'الجنيه الجنوب سوداني', flag: '🇸🇸'),
    CurrencyEntity(code: 'SDG', name: 'Sudanese Pound', nameAr: 'الجنيه السوداني', flag: '🇸🇩'),
    CurrencyEntity(code: 'SZL', name: 'Swazi Lilangeni', nameAr: 'الليلانجيني السوازي', flag: '🇸🇿'),
    CurrencyEntity(code: 'TZS', name: 'Tanzanian Shilling', nameAr: 'الشلن التنزاني', flag: '🇹🇿'),
    CurrencyEntity(code: 'TND', name: 'Tunisian Dinar', nameAr: 'الدينار التونسي', flag: '🇹🇳'),
    CurrencyEntity(code: 'UGX', name: 'Ugandan Shilling', nameAr: 'الشلن الأوغندي', flag: '🇺🇬'),
    CurrencyEntity(code: 'ZMW', name: 'Zambian Kwacha', nameAr: 'الكواشا الزامبي', flag: '🇿🇲'),
    CurrencyEntity(code: 'ZWL', name: 'Zimbabwean Dollar', nameAr: 'الدولار الزيمبابوي', flag: '🇿🇼'),
    CurrencyEntity(code: 'FJD', name: 'Fijian Dollar', nameAr: 'الدولار الفيجي', flag: '🇫🇯'),
    CurrencyEntity(code: 'PGK', name: 'Papua New Guinean Kina', nameAr: 'الكينا', flag: '🇵🇬'),
    CurrencyEntity(code: 'SBD', name: 'Solomon Islands Dollar', nameAr: 'دولار جزر سليمان', flag: '🇸🇧'),
    CurrencyEntity(code: 'TOP', name: 'Tongan Paʻanga', nameAr: 'البانغا التونغي', flag: '🇹🇴'),
    CurrencyEntity(code: 'VUV', name: 'Vanuatu Vatu', nameAr: 'الفاتو الفانواتي', flag: '🇻🇺'),
    CurrencyEntity(code: 'WST', name: 'Samoan Tala', nameAr: 'التالا الساموي', flag: '🇼🇸'),
    CurrencyEntity(code: 'XPF', name: 'CFP Franc', nameAr: 'فرنك المحيط الهادئ', flag: '🇵🇫'),
  ];

  // Settings management
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _autoRefreshEnabled = prefs.getBool(_autoRefreshKey) ?? true;
      final intervalMinutes = prefs.getInt(_refreshIntervalKey) ?? 60;
      _refreshInterval = Duration(minutes: intervalMinutes);
      _fromCurrency = prefs.getString(_fromCurrencyKey) ?? 'USD';
      _toCurrency = prefs.getString(_toCurrencyKey) ?? 'AED';
      _amount = prefs.getDouble(_lastAmountKey) ?? 1000.0;
    } catch (e) {
      if (kDebugMode) {
        print('Error loading settings: $e');
      }
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_autoRefreshKey, _autoRefreshEnabled);
      await prefs.setInt(_refreshIntervalKey, _refreshInterval.inMinutes);
      await prefs.setString(_fromCurrencyKey, _fromCurrency);
      await prefs.setString(_toCurrencyKey, _toCurrency);
      await prefs.setDouble(_lastAmountKey, _amount);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving settings: $e');
      }
    }
  }

  // Auto-refresh methods
  void _startAutoRefresh() {
    if (!_autoRefreshEnabled || _isAppInBackground) return;

    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (timer) {
      if (!_isAppInBackground) {
        _performAutoRefreshWithRetry();
      }
    });
  }

  Future<void> _performAutoRefreshWithRetry() async {
    _retryCount = 0;
    await _performAutoRefreshWithRetryLogic();
  }

  Future<void> _performAutoRefreshWithRetryLogic() async {
    if (!_autoRefreshEnabled || _isAppInBackground) return;

    try {
      // Update last exchange rate if exists
      if (_lastExchangeRate != null) {
        await convertCurrency(silent: true);
      }

      // Update rates list if exists
      if (_allRates != null) {
        await getAllExchangeRates(_fromCurrency, silent: true);
      }

      _retryCount = 0; // Reset retry count on success
    } catch (e) {
      _retryCount++;
      if (_retryCount < _maxRetries) {
        // Exponential backoff
        await Future.delayed(Duration(seconds: _retryCount * 2));
        await _performAutoRefreshWithRetryLogic();
      } else {
        // Failed after max retries
        if (kDebugMode) {
          print('Auto-refresh failed after $_maxRetries attempts: $e');
        }
        emit(CurrencyAutoRefreshFailed(
            'Failed to refresh after $_maxRetries attempts'));
      }
    }
  }

  // App lifecycle management
  void onAppStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _isAppInBackground = true;
        _refreshTimer?.cancel();
        break;
      case AppLifecycleState.resumed:
        _isAppInBackground = false;
        if (_autoRefreshEnabled) {
          _startAutoRefresh();
          if (_needsRefresh()) {
            _performAutoRefreshWithRetry();
          }
        }
        break;
      case AppLifecycleState.detached:
        _refreshTimer?.cancel();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  bool _needsRefresh() {
    if (_lastUpdateTime == null) return true;

    final now = DateTime.now();
    final difference = now.difference(_lastUpdateTime!);

    return difference >= _refreshInterval;
  }

  // Public methods for auto-refresh control
  void enableAutoRefresh() {
    _autoRefreshEnabled = true;
    _startAutoRefresh();
    _saveSettings();
    emit(CurrencyAutoRefreshEnabled());
  }

  void disableAutoRefresh() {
    _autoRefreshEnabled = false;
    _refreshTimer?.cancel();
    _saveSettings();
    emit(CurrencyAutoRefreshDisabled());
  }

  void setRefreshInterval(Duration interval) {
    _refreshInterval = interval;
    _saveSettings();
    if (_autoRefreshEnabled) {
      _startAutoRefresh();
    }
    emit(CurrencyRefreshIntervalChanged(interval));
  }

  Future<void> forceRefresh() async {
    emit(CurrencyRefreshing());

    try {
      // Force refresh both conversion and rates
      if (_lastExchangeRate != null) {
        await convertCurrency(silent: false);
      }

      if (_allRates != null) {
        await getAllExchangeRates(_fromCurrency, silent: false);
      }

      emit(CurrencyRefreshed());
    } catch (e) {
      emit(CurrencyError('Force refresh failed: $e'));
    }
  }

  // Currency management
  void setFromCurrency(String currency) {
    _fromCurrency = currency;
    _allRates = null;
    _saveSettings();
    emit(CurrencyFromChanged(currency));
  }

  void setToCurrency(String currency) {
    _toCurrency = currency;
    _saveSettings();
    emit(CurrencyToChanged(currency));
  }

  void setAmount(double amount) {
    _amount = amount;
    _saveSettings();
  }

  void swapCurrencies() {
    final temp = _fromCurrency;
    _fromCurrency = _toCurrency;
    _toCurrency = temp;
    _allRates = null;
    _saveSettings();
    emit(CurrenciesSwapped(_fromCurrency, _toCurrency));
  }

  // API calls
  Future<void> convertCurrency({bool silent = false}) async {
    if (!silent) {
      emit(CurrencyLoading());
    }

    final result = await convertCurrencyUseCase(
      from: _fromCurrency,
      to: _toCurrency,
      amount: _amount,
    );

    result.fold(
      (failure) {
        if (!silent) {
          emit(CurrencyError(failure.toString()));
        }
      },
      (exchangeRate) {
        _lastExchangeRate = exchangeRate;
        _lastUpdateTime = DateTime.now();

        if (!silent) {
          emit(CurrencyConverted(exchangeRate));
        } else {
          emit(CurrencyUpdatedSilently(exchangeRate));
        }

        // Trigger haptic feedback for successful conversion
        if (!silent) {
          HapticFeedback.lightImpact();
        }
      },
    );
  }

  Future<void> getAllExchangeRates(String baseCurrency,
      {bool silent = false}) async {
    if (!silent) {
      emit(CurrencyLoading());
    }

    final result = await getExchangeRatesUseCase(code: baseCurrency);

    result.fold(
      (failure) {
        if (!silent) {
          emit(CurrencyError(failure.toString()));
        }
      },
      (currencyRates) {
        _allRates = currencyRates;
        _lastUpdateTime = DateTime.now();

        if (!silent) {
          emit(CurrencyRatesLoaded(currencyRates));
        } else {
          emit(CurrencyRatesUpdatedSilently(currencyRates));
        }
      },
    );
  }

  // Utility methods
  CurrencyEntity? getCurrencyByCode(String code) {
    try {
      return availableCurrencies
          .firstWhere((currency) => currency.code == code);
    } catch (e) {
      return null;
    }
  }

  String getTimeSinceLastUpdate() {
    if (_lastUpdateTime == null) return 'Never updated';

    final now = DateTime.now();
    final difference = now.difference(_lastUpdateTime!);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  String getRefreshIntervalText() {
    if (_refreshInterval.inMinutes < 60) {
      return '${_refreshInterval.inMinutes} minutes';
    } else if (_refreshInterval.inHours < 24) {
      return '${_refreshInterval.inHours} hours';
    } else {
      return '${_refreshInterval.inDays} days';
    }
  }

  // Available refresh intervals
  List<Duration> getAvailableRefreshIntervals() {
    return [
      const Duration(minutes: 15),
      const Duration(minutes: 30),
      const Duration(hours: 1),
      const Duration(hours: 2),
      const Duration(hours: 6),
      const Duration(hours: 12),
      const Duration(hours: 24),
    ];
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
