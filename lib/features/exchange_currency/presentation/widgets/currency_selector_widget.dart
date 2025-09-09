// import 'package:flutter/material.dart';
// import '../../domain/entities/currency_entity.dart';

// class CurrencySelectorWidget extends StatelessWidget {
//   final String selectedCurrency;
//   final List<CurrencyEntity> currencies;
//   final Function(String) onCurrencySelected;
//   final String title;

//   const CurrencySelectorWidget({
//     Key? key,
//     required this.selectedCurrency,
//     required this.currencies,
//     required this.onCurrencySelected,
//     required this.title,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade300),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: ListTile(
//             leading: CircleAvatar(
//               radius: 20,
//               backgroundColor: Colors.grey.shade100,
//               child: Text(
//                 _getCurrencyFlag(selectedCurrency),
//                 style: const TextStyle(fontSize: 20),
//               ),
//             ),
//             title: Text(
//               selectedCurrency,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             subtitle: Text(_getCurrencyName(selectedCurrency)),
//             trailing: const Icon(Icons.keyboard_arrow_down),
//             onTap: () => _showCurrencySelector(context),
//           ),
//         ),
//       ],
//     );
//   }

//   String _getCurrencyFlag(String code) {
//     final currency = currencies.firstWhere(
//       (c) => c.code == code,
//       orElse: () => CurrencyEntity(code: code, name: code, flag: '💱'),
//     );
//     return currency.flag;
//   }

//   String _getCurrencyName(String code) {
//     final currency = currencies.firstWhere(
//       (c) => c.code == code,
//       orElse: () => CurrencyEntity(code: code, name: code, flag: '💱'),
//     );
//     return currency.name;
//   }

//   void _showCurrencySelector(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => SizedBox(
//         height: MediaQuery.of(context).size.height * 0.8,
//         child: Column(
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               margin: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 'Choose Currency',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: currencies.length,
//                 itemBuilder: (context, index) {
//                   final currency = currencies[index];
//                   final isSelected = currency.code == selectedCurrency;
//                   return ListTile(
//                     leading: CircleAvatar(
//                       radius: 20,
//                       backgroundColor: Colors.grey.shade100,
//                       child: Text(
//                         currency.flag,
//                         style: const TextStyle(fontSize: 18),
//                       ),
//                     ),
//                     title: Text(
//                       '${currency.code} - ${currency.name}',
//                       style: TextStyle(
//                         fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                       ),
//                     ),
//                     trailing: isSelected
//                         ? const Icon(Icons.check_circle, color: Colors.blue)
//                         : null,
//                     onTap: () {
//                       onCurrencySelected(currency.code);
//                       Navigator.pop(context);
//                     },
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF1B2951),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     'Done',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }