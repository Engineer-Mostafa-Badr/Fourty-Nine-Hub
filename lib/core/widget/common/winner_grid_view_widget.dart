import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:intl/intl.dart';

import '../../../res/assets/assets.dart';
import '../../../res/style/styles.dart';

class WinnerGridViewWidget extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final String? title;
  final num? viewsCount;
  final String? date;
  final num? lastPrice;
  final num? rating;

  const WinnerGridViewWidget({
    super.key,
    this.imageUrl,
    this.name,
    this.title,
    this.viewsCount,
    this.date,
    this.lastPrice,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.amber.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildWinnerAvatar(),
          if (name != null) ...[
            const SizedBox(height: 12),
            _buildWinnerName(),
          ],
          if (title != null) ...[
            const SizedBox(height: 6),
            _buildWinnerTitle(),
          ],
          if (date != null) ...[
            const SizedBox(height: 6),
            _buildEndDate(context),
          ],
          if (lastPrice != null) ...[
            const SizedBox(height: 6),
            _buildLastPrice(),
          ],
          if (viewsCount != null) ...[
            const SizedBox(height: 8),
            _buildViewsCount(),
          ],


          if (rating != null) ...[
            const SizedBox(height: 8),
            _buildRating(),
          ],
        ],
      ),
    );
  }

  Widget _buildWinnerAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.amber.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              imageUrl ?? Assets.profile,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset(
                Assets.profile,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: -27,
          right: 0,
          child: SvgPicture.asset(Assets.crownIcon),
        ),
      ],
    );
  }

  Widget _buildWinnerName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        name!.isNotEmpty ? name! : 'Unknown Winner',
        style: Styles.mediumText(color: Colors.white),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }
  Widget _buildWinnerTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title!.isNotEmpty ? title! : 'Unknown Winner',
        style: Styles.mediumText(color: Colors.white),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRating() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${LocaleKeys.rating.localize}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          Text(
              _formatNumber(rating!) ,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildViewsCount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('👁', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            _formatNumber(viewsCount ?? 0),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndDate(BuildContext context) {
    return Text(
      _formatDate(date, context),
      style: Styles.mediumText(color: Colors.white),
    );
  }

  Widget _buildLastPrice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        '${_formatNumber(lastPrice ?? 0)} ${LocaleKeys.egp.localize}',
        style: Styles.mediumText(color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _formatDate(String? date, BuildContext context) {
    if (date == null || date.isEmpty) return 'N/A';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return 'Invalid Date';

    final isEnglish = context.locale == const Locale('en');
    final pattern = isEnglish ? 'd/M/yyyy' : 'yyyy/M/d';
    final locale = isEnglish ? 'en' : 'ar';

    return DateFormat(pattern, locale).format(parsed);
  }

  String _formatNumber(num number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(number % 1000000000 == 0 ? 0 : 1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(number % 1000000 == 0 ? 0 : 1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}K';
    }
    return number.toStringAsFixed(0);
  }
}