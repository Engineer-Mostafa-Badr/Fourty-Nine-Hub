import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostMetaPanel extends StatelessWidget {
  const PostMetaPanel({
    super.key,
    required this.createdAt,
    this.views,
    this.retweets,
    this.quotes,
    this.likes,
    this.bookmarks,
    this.isArabic = false,
  });

  final DateTime createdAt;
  final int? views;
  final int? retweets;
  final int? quotes;
  final int? likes;
  final int? bookmarks;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {

    String formatSince(DateTime? createdAt, {String locale = 'en'}) {
      if (createdAt == null) return '';

      // dd: يوم | MMM: شهر مختصر | yyyy: سنة | hh:mm: ساعة/دقيقة | a: AM/PM
      final formatter = DateFormat('dd MMM yyyy hh:mm a', locale);

      return formatter.format(createdAt);
    }
    final sinceEn = createdAt != null ? formatSince(createdAt, locale: 'en') : '';
    final sinceAr = createdAt != null ? formatSince(createdAt, locale: 'ar') : '';


    final baseStyle = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 14,
      height: 1.2,
    );
    final bold = baseStyle.copyWith(
      color: Colors.grey.shade400,
      fontWeight: FontWeight.w700,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 4.0,left: 8,right: 8,bottom: 8),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.stretch,
       children: [
         // Row 1: time · date · views
         _RowLine(
           left:
           Text(
             Localizations.localeOf(context).languageCode == 'ar' ? sinceAr : sinceEn,
             style: const TextStyle(color: Colors.grey, fontSize: 16),
           ),
           right:
                const SizedBox()
         ),
         const Divider(height: 18, thickness: 0.4, color: Colors.grey),
         // Row 2: retweets & quotes
         if (likes != null || bookmarks != null)
           _RowLine(
               left: likes == null
                   ? const SizedBox()
                   : RichText(
                 text: TextSpan(
                   style: baseStyle,
                   children: [
                     TextSpan(
                       text: _compact(likes!, isArabic),
                       style: bold,
                     ),
                     TextSpan(text:   Localizations.localeOf(context).languageCode == 'ar' ? ' إعجابات' : ' Likes'),
                   ],
                 ),
               ),
               right:  const SizedBox()



           ),

         if (retweets != null || quotes != null)
           const Divider(height: 18, thickness: 0.4, color: Colors.grey),
         // Row 3: likes & bookmarks
         if (retweets != null || quotes != null)
           _RowLine(
             left: retweets == null
                 ? const SizedBox()
                 : RichText(
               text: TextSpan(
                 style: baseStyle,
                 children: [
                   TextSpan(
                     text: _compact(retweets!, isArabic),
                     style: bold,
                   ),
                   TextSpan(
                       text:
                       Localizations.localeOf(context).languageCode == 'ar'   ? ' المنشورات المُعاد نشرها'
                           : ' Retweets'),
                 ],
               ),
             ),
             right: quotes == null
                 ? const SizedBox()
                 : RichText(
               text: TextSpan(
                 style: baseStyle,
                 children: [
                   TextSpan(
                     text: _compact(quotes!, isArabic),
                     style: bold,
                   ),
                   TextSpan(
                       text:   Localizations.localeOf(context).languageCode == 'ar' ? ' اقتباسات' : ' Quotes'),
                 ],
               ),
             ),
           ),
       ],
            ),
    );
  }

  // ——— helpers ———

  static String _formatTimeDate(DateTime dt, bool ar) {
    // 12h time with am/pm localized; day + Arabic month name if ar
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final isPM = dt.hour >= 12;
    final ampm = ar ? (isPM ? 'م' : 'ص') : (isPM ? 'PM' : 'AM');

    final day = dt.day.toString().padLeft(2, '0');
    final monthName = ar ? _arMonth(dt.month) : DateFormat.MMM().format(dt);
    final year = dt.year.toString();

    final time = ar ? '$h:$m $ampm' : '$h:$m $ampm';
    final date = ar ? '$day $monthName $year' : '$day $monthName, $year';
    final text = ar ? '$time · $date' : '$time · $date';
    return ar ? _toArabicDigits(text) : text;
  }

  static String _arMonth(int m) {
    const months = [
      'يناير','فبراير','مارس','أبريل','مايو','يونيو',
      'يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'
    ];
    return (m >= 1 && m <= 12) ? months[m - 1] : '';
  }

  static String _compact(int v, bool ar) {
    String s;
    if (v >= 1000000000) {
      s = (v / 1000000000).toStringAsFixed(v % 1000000000 == 0 ? 0 : 1) + (ar ? 'B' : 'B');
    } else if (v >= 1000000) {
      s = (v / 1000000).toStringAsFixed(v % 1000000 == 0 ? 0 : 1) + (ar ? 'M' : 'M');
    } else if (v >= 1000) {
      s = (v / 1000).toStringAsFixed(v % 1000 == 0 ? 0 : 1) + (ar ? 'K' : 'K');
    } else {
      s = v.toString();
    }
    return ar ? _toArabicDigits(s) : s;
  }

  static String _toArabicDigits(String input) {
    const en = ['0','1','2','3','4','5','6','7','8','9'];
    const ar = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
    var out = input;
    for (var i = 0; i < 10; i++) {
      out = out.replaceAll(en[i], ar[i]);
    }
    return out;
  }
}

class _RowLine extends StatelessWidget {
  const _RowLine({required this.left, required this.right});
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        right,
      ],
    );
  }
}
