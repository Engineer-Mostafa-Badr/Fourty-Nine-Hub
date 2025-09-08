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
    CurrencyEntity(code: 'USD', name: 'US Dollar', flag: '🇺🇸'),
    CurrencyEntity(code: 'EUR', name: 'Euro', flag: '🇪🇺'),
    CurrencyEntity(code: 'GBP', name: 'British Pound', flag: '🇬🇧'),
    CurrencyEntity(code: 'JPY', name: 'Japanese Yen', flag: '🇯🇵'),
    CurrencyEntity(code: 'AUD', name: 'Australian Dollar', flag: '🇦🇺'),
    CurrencyEntity(code: 'CAD', name: 'Canadian Dollar', flag: '🇨🇦'),
    CurrencyEntity(code: 'CHF', name: 'Swiss Franc', flag: '🇨🇭'),
    CurrencyEntity(code: 'CNY', name: 'Chinese Yuan', flag: '🇨🇳'),
    CurrencyEntity(code: 'SEK', name: 'Swedish Krona', flag: '🇸🇪'),
    CurrencyEntity(code: 'NZD', name: 'New Zealand Dollar', flag: '🇳🇿'),
    CurrencyEntity(code: 'MXN', name: 'Mexican Peso', flag: '🇲🇽'),
    CurrencyEntity(code: 'SGD', name: 'Singapore Dollar', flag: '🇸🇬'),
    CurrencyEntity(code: 'HKD', name: 'Hong Kong Dollar', flag: '🇭🇰'),
    CurrencyEntity(code: 'NOK', name: 'Norwegian Krone', flag: '🇳🇴'),
    CurrencyEntity(code: 'KRW', name: 'South Korean Won', flag: '🇰🇷'),
    CurrencyEntity(code: 'TRY', name: 'Turkish Lira', flag: '🇹🇷'),
    CurrencyEntity(code: 'RUB', name: 'Russian Ruble', flag: '🇷🇺'),
    CurrencyEntity(code: 'INR', name: 'Indian Rupee', flag: '🇮🇳'),
    CurrencyEntity(code: 'BRL', name: 'Brazilian Real', flag: '🇧🇷'),
    CurrencyEntity(code: 'ZAR', name: 'South African Rand', flag: '🇿🇦'),
    CurrencyEntity(code: 'PLN', name: 'Polish Zloty', flag: '🇵🇱'),
    CurrencyEntity(code: 'EGP', name: 'Egyptian Pound', flag: '🇪🇬'),
    CurrencyEntity(code: 'AED', name: 'UAE Dirham', flag: '🇦🇪'),
    CurrencyEntity(code: 'SAR', name: 'Saudi Riyal', flag: '🇸🇦'),
    CurrencyEntity(code: 'QAR', name: 'Qatari Riyal', flag: '🇶🇦'),
    CurrencyEntity(code: 'KWD', name: 'Kuwaiti Dinar', flag: '🇰🇼'),
    CurrencyEntity(code: 'BHD', name: 'Bahraini Dinar', flag: '🇧🇭'),
    CurrencyEntity(code: 'OMR', name: 'Omani Rial', flag: '🇴🇲'),
    CurrencyEntity(code: 'JOD', name: 'Jordanian Dinar', flag: '🇯🇴'),
    CurrencyEntity(code: 'LBP', name: 'Lebanese Pound', flag: '🇱🇧'),
    CurrencyEntity(code: 'IQD', name: 'Iraqi Dinar', flag: '🇮🇶'),
    CurrencyEntity(code: 'IRR', name: 'Iranian Rial', flag: '🇮🇷'),
    CurrencyEntity(code: 'THB', name: 'Thai Baht', flag: '🇹🇭'),
    CurrencyEntity(code: 'MYR', name: 'Malaysian Ringgit', flag: '🇲🇾'),
    CurrencyEntity(code: 'IDR', name: 'Indonesian Rupiah', flag: '🇮🇩'),
    CurrencyEntity(code: 'PHP', name: 'Philippine Peso', flag: '🇵🇭'),
    CurrencyEntity(code: 'VND', name: 'Vietnamese Dong', flag: '🇻🇳'),
    CurrencyEntity(code: 'TWD', name: 'Taiwan Dollar', flag: '🇹🇼'),
    CurrencyEntity(code: 'PKR', name: 'Pakistani Rupee', flag: '🇵🇰'),
    CurrencyEntity(code: 'BGN', name: 'Bulgarian Lev', flag: '🇧🇬'),
    CurrencyEntity(code: 'CZK', name: 'Czech Koruna', flag: '🇨🇿'),
    CurrencyEntity(code: 'HUF', name: 'Hungarian Forint', flag: '🇭🇺'),
    CurrencyEntity(code: 'RON', name: 'Romanian Leu', flag: '🇷🇴'),
    CurrencyEntity(code: 'HRK', name: 'Croatian Kuna', flag: '🇭🇷'),
    CurrencyEntity(code: 'RSD', name: 'Serbian Dinar', flag: '🇷🇸'),
    CurrencyEntity(code: 'UAH', name: 'Ukrainian Hryvnia', flag: '🇺🇦'),
    CurrencyEntity(code: 'BYN', name: 'Belarusian Ruble', flag: '🇧🇾'),
    CurrencyEntity(code: 'KZT', name: 'Kazakhstani Tenge', flag: '🇰🇿'),
    CurrencyEntity(code: 'UZS', name: 'Uzbekistani Som', flag: '🇺🇿'),
    CurrencyEntity(code: 'AZN', name: 'Azerbaijani Manat', flag: '🇦🇿'),
    CurrencyEntity(code: 'GEL', name: 'Georgian Lari', flag: '🇬🇪'),
    CurrencyEntity(code: 'AMD', name: 'Armenian Dram', flag: '🇦🇲'),
    CurrencyEntity(code: 'TMT', name: 'Turkmenistani Manat', flag: '🇹🇲'),
    CurrencyEntity(code: 'KGS', name: 'Kyrgyzstani Som', flag: '🇰🇬'),
    CurrencyEntity(code: 'TJS', name: 'Tajikistani Somoni', flag: '🇹🇯'),
    CurrencyEntity(code: 'MDL', name: 'Moldovan Leu', flag: '🇲🇩'),
    CurrencyEntity(code: 'MKD', name: 'Macedonian Denar', flag: '🇲🇰'),
    CurrencyEntity(code: 'ALL', name: 'Albanian Lek', flag: '🇦🇱'),
    CurrencyEntity(
        code: 'BAM', name: 'Bosnia-Herzegovina Convertible Mark', flag: '🇧🇦'),
    CurrencyEntity(code: 'ISK', name: 'Icelandic Krona', flag: '🇮🇸'),
    CurrencyEntity(code: 'DKK', name: 'Danish Krone', flag: '🇩🇰'),
    CurrencyEntity(code: 'CLP', name: 'Chilean Peso', flag: '🇨🇱'),
    CurrencyEntity(code: 'COP', name: 'Colombian Peso', flag: '🇨🇴'),
    CurrencyEntity(code: 'PEN', name: 'Peruvian Sol', flag: '🇵🇪'),
    CurrencyEntity(code: 'UYU', name: 'Uruguayan Peso', flag: '🇺🇾'),
    CurrencyEntity(code: 'PYG', name: 'Paraguayan Guarani', flag: '🇵🇾'),
    CurrencyEntity(code: 'BOB', name: 'Bolivian Boliviano', flag: '🇧🇴'),
    CurrencyEntity(code: 'VES', name: 'Venezuelan Bolívar', flag: '🇻🇪'),
    CurrencyEntity(code: 'GYD', name: 'Guyanese Dollar', flag: '🇬🇾'),
    CurrencyEntity(code: 'SRD', name: 'Surinamese Dollar', flag: '🇸🇷'),
    CurrencyEntity(code: 'AWG', name: 'Aruban Florin', flag: '🇦🇼'),
    CurrencyEntity(
        code: 'ANG', name: 'Netherlands Antillean Guilder', flag: '🇨🇼'),
    CurrencyEntity(code: 'BBD', name: 'Barbadian Dollar', flag: '🇧🇧'),
    CurrencyEntity(code: 'BZD', name: 'Belize Dollar', flag: '🇧🇿'),
    CurrencyEntity(code: 'BMD', name: 'Bermudian Dollar', flag: '🇧🇲'),
    CurrencyEntity(code: 'BSD', name: 'Bahamian Dollar', flag: '🇧🇸'),
    CurrencyEntity(code: 'CUP', name: 'Cuban Peso', flag: '🇨🇺'),
    CurrencyEntity(code: 'DOP', name: 'Dominican Peso', flag: '🇩🇴'),
    CurrencyEntity(code: 'GTQ', name: 'Guatemalan Quetzal', flag: '🇬🇹'),
    CurrencyEntity(code: 'HNL', name: 'Honduran Lempira', flag: '🇭🇳'),
    CurrencyEntity(code: 'HTG', name: 'Haitian Gourde', flag: '🇭🇹'),
    CurrencyEntity(code: 'JMD', name: 'Jamaican Dollar', flag: '🇯🇲'),
    CurrencyEntity(code: 'KYD', name: 'Cayman Islands Dollar', flag: '🇰🇾'),
    CurrencyEntity(code: 'NIO', name: 'Nicaraguan Córdoba', flag: '🇳🇮'),
    CurrencyEntity(code: 'PAB', name: 'Panamanian Balboa', flag: '🇵🇦'),
    CurrencyEntity(code: 'TTD', name: 'Trinidad & Tobago Dollar', flag: '🇹🇹'),
    CurrencyEntity(code: 'XCD', name: 'East Caribbean Dollar', flag: '🇦🇬'),
    CurrencyEntity(code: 'AFN', name: 'Afghan Afghani', flag: '🇦🇫'),
    CurrencyEntity(code: 'BDT', name: 'Bangladeshi Taka', flag: '🇧🇩'),
    CurrencyEntity(code: 'BTN', name: 'Bhutanese Ngultrum', flag: '🇧🇹'),
    CurrencyEntity(code: 'KHR', name: 'Cambodian Riel', flag: '🇰🇭'),
    CurrencyEntity(code: 'LAK', name: 'Laotian Kip', flag: '🇱🇦'),
    CurrencyEntity(code: 'LKR', name: 'Sri Lankan Rupee', flag: '🇱🇰'),
    CurrencyEntity(code: 'MMK', name: 'Myanmar Kyat', flag: '🇲🇲'),
    CurrencyEntity(code: 'MNT', name: 'Mongolian Tugrik', flag: '🇲🇳'),
    CurrencyEntity(code: 'MVR', name: 'Maldivian Rufiyaa', flag: '🇲🇻'),
    CurrencyEntity(code: 'NPR', name: 'Nepalese Rupee', flag: '🇳🇵'),
    CurrencyEntity(code: 'DZD', name: 'Algerian Dinar', flag: '🇩🇿'),
    CurrencyEntity(code: 'AOA', name: 'Angolan Kwanza', flag: '🇦🇴'),
    CurrencyEntity(code: 'BWP', name: 'Botswanan Pula', flag: '🇧🇼'),
    CurrencyEntity(code: 'BIF', name: 'Burundian Franc', flag: '🇧🇮'),
    CurrencyEntity(code: 'CVE', name: 'Cape Verdean Escudo', flag: '🇨🇻'),
    CurrencyEntity(code: 'KMF', name: 'Comorian Franc', flag: '🇰🇲'),
    CurrencyEntity(code: 'CDF', name: 'Congolese Franc', flag: '🇨🇩'),
    CurrencyEntity(code: 'DJF', name: 'Djiboutian Franc', flag: '🇩🇯'),
    CurrencyEntity(code: 'ERN', name: 'Eritrean Nakfa', flag: '🇪🇷'),
    CurrencyEntity(code: 'ETB', name: 'Ethiopian Birr', flag: '🇪🇹'),
    CurrencyEntity(code: 'GMD', name: 'Gambian Dalasi', flag: '🇬🇲'),
    CurrencyEntity(code: 'GHS', name: 'Ghanaian Cedi', flag: '🇬🇭'),
    CurrencyEntity(code: 'GNF', name: 'Guinean Franc', flag: '🇬🇳'),
    CurrencyEntity(code: 'KES', name: 'Kenyan Shilling', flag: '🇰🇪'),
    CurrencyEntity(code: 'LSL', name: 'Lesotho Loti', flag: '🇱🇸'),
    CurrencyEntity(code: 'LRD', name: 'Liberian Dollar', flag: '🇱🇷'),
    CurrencyEntity(code: 'LYD', name: 'Libyan Dinar', flag: '🇱🇾'),
    CurrencyEntity(code: 'MGA', name: 'Malagasy Ariary', flag: '🇲🇬'),
    CurrencyEntity(code: 'MWK', name: 'Malawian Kwacha', flag: '🇲🇼'),
    CurrencyEntity(code: 'MRU', name: 'Mauritanian Ouguiya', flag: '🇲🇷'),
    CurrencyEntity(code: 'MUR', name: 'Mauritian Rupee', flag: '🇲🇺'),
    CurrencyEntity(code: 'MAD', name: 'Moroccan Dirham', flag: '🇲🇦'),
    CurrencyEntity(code: 'MZN', name: 'Mozambican Metical', flag: '🇲🇿'),
    CurrencyEntity(code: 'NAD', name: 'Namibian Dollar', flag: '🇳🇦'),
    CurrencyEntity(code: 'NGN', name: 'Nigerian Naira', flag: '🇳🇬'),
    CurrencyEntity(code: 'RWF', name: 'Rwandan Franc', flag: '🇷🇼'),
    CurrencyEntity(
        code: 'STN', name: 'São Tomé & Príncipe Dobra', flag: '🇸🇹'),
    CurrencyEntity(code: 'SCR', name: 'Seychellois Rupee', flag: '🇸🇨'),
    CurrencyEntity(code: 'SLE', name: 'Sierra Leonean Leone', flag: '🇸🇱'),
    CurrencyEntity(code: 'SOS', name: 'Somali Shilling', flag: '🇸🇴'),
    CurrencyEntity(code: 'SSP', name: 'South Sudanese Pound', flag: '🇸🇸'),
    CurrencyEntity(code: 'SDG', name: 'Sudanese Pound', flag: '🇸🇩'),
    CurrencyEntity(code: 'SZL', name: 'Swazi Lilangeni', flag: '🇸🇿'),
    CurrencyEntity(code: 'TZS', name: 'Tanzanian Shilling', flag: '🇹🇿'),
    CurrencyEntity(code: 'TND', name: 'Tunisian Dinar', flag: '🇹🇳'),
    CurrencyEntity(code: 'UGX', name: 'Ugandan Shilling', flag: '🇺🇬'),
    CurrencyEntity(code: 'ZMW', name: 'Zambian Kwacha', flag: '🇿🇲'),
    CurrencyEntity(code: 'ZWL', name: 'Zimbabwean Dollar', flag: '🇿🇼'),
    CurrencyEntity(code: 'FJD', name: 'Fijian Dollar', flag: '🇫🇯'),
    CurrencyEntity(code: 'PGK', name: 'Papua New Guinean Kina', flag: '🇵🇬'),
    CurrencyEntity(code: 'SBD', name: 'Solomon Islands Dollar', flag: '🇸🇧'),
    CurrencyEntity(code: 'TOP', name: 'Tongan Paʻanga', flag: '🇹🇴'),
    CurrencyEntity(code: 'VUV', name: 'Vanuatu Vatu', flag: '🇻🇺'),
    CurrencyEntity(code: 'WST', name: 'Samoan Tala', flag: '🇼🇸'),
    CurrencyEntity(code: 'XPF', name: 'CFP Franc', flag: '🇵🇫'),
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
