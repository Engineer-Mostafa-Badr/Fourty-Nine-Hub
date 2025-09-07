import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../logic/currency_cubit.dart';
import '../widgets/exchange_rate_display_widget.dart';

class CurrencyExchangePage extends StatefulWidget {
  const CurrencyExchangePage({super.key});

  @override
  State<CurrencyExchangePage> createState() => _CurrencyExchangePageState();
}

class _CurrencyExchangePageState extends State<CurrencyExchangePage> {
  final TextEditingController _amountController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = '1000.00';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.grey.shade50,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leading: SizedBox(
            width: 30,
            height: 30,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Text(
            context.isArabic ? 'تبديل العملات' : 'Exchange',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: BlocConsumer<CurrencyCubit, CurrencyState>(
        listener: (context, state) {
          if (state is CurrencyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<CurrencyCubit>();

          return SingleChildScrollView(
            child: Column(
              children: [
                // Main conversion card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xff0B1035), Color(0xffddf6f3)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        !context.isArabic ? 'تبديل العملات' : 'Change Currency',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        !context.isArabic
                            ? 'تبديل العملات بشكل سريع وعرض السعر للعملة في الوقت الحالي'
                            : 'Changing its currency instantaneously and\nknowing the currency rate moment by moment',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // From Currency Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              !context.isArabic ? 'المبلغ' : 'Amount',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // إصلاح الـ Row الأول - Amount Section
                            Row(
                              children: [
                                // Currency selector - مع تحديد عرض ثابت
                                GestureDetector(
                                  onTap: () =>
                                      _showFromCurrencySelector(context, cubit),
                                  child: Container(
                                    width: 120, // عرض ثابت
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _getCurrencyFlag(cubit.fromCurrency),
                                          style: const TextStyle(
                                              fontSize: 24), // قللت الحجم
                                        ),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            cubit.fromCurrency,
                                            style: const TextStyle(
                                              fontSize: 20, // قللت الحجم
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.keyboard_arrow_down,
                                            size: 16),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                    width: 8), // مسافة ثابتة بدلاً من Spacer

                                // Amount input - استخدام Expanded
                                Expanded(
                                  child: SizedBox(
                                    height: 45,
                                    child: TextField(
                                      controller: _amountController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        fontSize: 16, // قللت الحجم
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffEFEFEF)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffEFEFEF)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffEFEFEF)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7)),
                                        ),
                                        hintText: '0.00',
                                      ),
                                      onChanged: (value) {
                                        final amount =
                                            double.tryParse(value) ?? 0.0;
                                        cubit.setAmount(amount);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Swap button
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Color(0xffE7E7EE),
                                    thickness: 1,
                                  ),
                                ),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      ManageVibration.vibrate();
                                      cubit.swapCurrencies();
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1B2951),
                                        shape: BoxShape.circle,
                                        // borderRadius: BorderRadius.circular(25),
                                      ),
                                      // child: const Icon(
                                      //   Icons.swap_vert,
                                      //   color: Colors.white,
                                      //   size: 24,
                                      // ),
                                      child: SvgPicture.asset(
                                        Assets.swapIcon,
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Color(0xffE7E7EE),
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                            Text(
                              !context.isArabic
                                  ? 'المبلغ المحول'
                                  : 'Converted Amount',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // إصلاح الـ Row الثاني - Converted Amount Section
                            Row(
                              children: [
                                // To Currency selector - مع تحديد عرض ثابت
                                GestureDetector(
                                  onTap: () =>
                                      _showToCurrencySelector(context, cubit),
                                  child: Container(
                                    width: 120, // نفس العرض
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _getCurrencyFlag(cubit.toCurrency),
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            cubit.toCurrency,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.keyboard_arrow_down,
                                            size: 16),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // Converted amount display - استخدام Expanded
                                Expanded(
                                  child: Container(
                                    height: 45,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color: const Color(0xffEFEFEF)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        state is CurrencyConverted
                                            ? state
                                                .exchangeRate.conversionResult
                                                .toStringAsFixed(2)
                                            : '00.00',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Calculate button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x40000000), // #00000040
                          offset: Offset(0, 4), // x: 0, y: 4
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton(
                      onPressed: state is CurrencyLoading
                          ? null
                          : () {
                              ManageVibration.vibrate();
                              FocusScope.of(context).unfocus();
                              final amount =
                                  double.tryParse(_amountController.text) ??
                                      0.0;
                              cubit.setAmount(amount);
                              cubit.convertCurrency();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2951),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0, // إزالة الظل الافتراضي
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: state is CurrencyLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              !context.isArabic ? 'حساب' : 'Calculate',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),

                // Exchange rate info
                if (state is CurrencyConverted) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      !context.isArabic
                          ? 'سعر الصرف الإرشادي'
                          : 'Indicative Exchange Rate',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '1 ${state.exchangeRate.baseCode} = ${state.exchangeRate.conversionRate.toStringAsFixed(2)} ${state.exchangeRate.targetCode}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Expandable rates section
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                    if (_isExpanded) {
                      cubit.getAllExchangeRates(cubit.fromCurrency);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2951),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            !context.isArabic
                                ? 'يمكنك مراجعة سعر الصرف\nفي جميع دول العالم'
                                : 'You can check the current exchange rate\nin all countries of the world',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                // Exchange rates list
                if (_isExpanded) ...[
                  const SizedBox(height: 16),
                  BlocBuilder<CurrencyCubit, CurrencyState>(
                    builder: (context, state) {
                      if (state is CurrencyRatesLoaded) {
                        return ExchangeRateDisplayWidget(
                          currencyRates: state.currencyRates,
                          baseCurrency: cubit.fromCurrency,
                        );
                      } else if (state is CurrencyLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF1B2951)),
                            ),
                          ),
                        );
                      } else if (cubit.allRates != null) {
                        return ExchangeRateDisplayWidget(
                          currencyRates: cubit.allRates,
                          baseCurrency: cubit.fromCurrency,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getCurrencyFlag(String code) {
    final flagMap = {
      'USD': '🇺🇸',
      'EUR': '🇪🇺',
      'GBP': '🇬🇧',
      'JPY': '🇯🇵',
      'AUD': '🇦🇺',
      'CAD': '🇨🇦',
      'CHF': '🇨🇭',
      'CNY': '🇨🇳',
      'SEK': '🇸🇪',
      'NZD': '🇳🇿',
      'AED': '🇦🇪',
      'SAR': '🇸🇦',
      'QAR': '🇶🇦',
      'KWD': '🇰🇼',
      'BHD': '🇧🇭',
      'OMR': '🇴🇲',
      'EGP': '🇪🇬',
      'INR': '🇮🇳',
      'BRL': '🇧🇷',
      'RUB': '🇷🇺',
    };
    return flagMap[code] ?? '💱';
  }

  void _showFromCurrencySelector(BuildContext context, CurrencyCubit cubit) {
    _showCurrencySelector(
      context,
      cubit.availableCurrencies,
      cubit.fromCurrency,
      (currency) {
        cubit.setFromCurrency(currency);
        setState(() {});
      },
    );
  }

  void _showToCurrencySelector(BuildContext context, CurrencyCubit cubit) {
    _showCurrencySelector(
      context,
      cubit.availableCurrencies,
      cubit.toCurrency,
      (currency) {
        cubit.setToCurrency(currency);
        setState(() {});
      },
    );
  }

  void _showCurrencySelector(
    BuildContext context,
    List<dynamic> currencies,
    String selectedCurrency,
    Function(String) onSelected,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Color(0xff000000), width: 1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            Container(
              width: 150,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xff000000),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                !context.isArabic ? 'اختر العملة' : 'Choose Currency',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  final isSelected = currency.code == selectedCurrency;
                  return RadioListTile<String>(
                    value: currency.code,
                    groupValue: selectedCurrency,
                    onChanged: (value) {
                      if (value != null) {
                        onSelected(value);
                        Navigator.pop(context);
                      }
                    },
                    secondary: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade100,
                      child: Text(
                        currency.flag,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    title: Text(
                      '${currency.code} - ${currency.name}',
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    activeColor: AppColors.PRIMARY_COLOR,
                    controlAffinity: ListTileControlAffinity.trailing,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40000000), // #00000040
                      offset: Offset(0, 4), // x: 0, y: 4
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.PRIMARY_COLOR,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    context.isArabic ? 'تم' : 'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
