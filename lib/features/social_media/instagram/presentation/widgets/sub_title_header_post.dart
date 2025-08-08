import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';

class SubTitleHeaderPost extends StatefulWidget {
  const SubTitleHeaderPost({
    super.key,
    this.country = '',
    required this.isReel,
    this.songName,
  });

  final String country;
  final bool isReel;
  final String? songName;

  @override
  _SubTitleHeaderPostState createState() => _SubTitleHeaderPostState();
}

class _SubTitleHeaderPostState extends State<SubTitleHeaderPost> {
  bool _showCity = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    if (widget.country.isNotEmpty && widget.songName != null) {
      _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
        if (mounted) {
          setState(() {
            _showCity = !_showCity;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // إذا لم يكن هناك اسم مدينة ويوجد اسم أغنية
    if (widget.country.isEmpty && widget.songName != null) {
      return FittedBox(
        child: Row(
          children: [
            SvgPicture.asset(
              Assets.musicNoteIcon,
              height: 14,
              width: 14,
              // color: Colors.white,
              colorFilter: ColorFilter.mode(
                widget.isReel ? Colors.white : Colors.black,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 2),
            Label(
              text: widget.songName!,
              style: Styles.mediumText(
                fontSize: 24,
                color: widget.isReel ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      );
    }

    // الحالة الافتراضية مع التبديل
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.3), // يبدأ من الأعلى
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Row(
        key: ValueKey(_showCity),
        mainAxisSize: MainAxisSize.min,
        children: [
          // التبديل بين اسم المدينة واسم الأغنية
          if (!_showCity) ...[
            SvgPicture.asset(
              Assets.musicNoteIcon,
              height: 14,
              width: 14,
              // color: widget.isReel ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 2),
          ],
          FittedBox(
            child: Label(
              text: _showCity
                  ? widget.country
                  : (widget.songName ?? widget.country),
              style: Styles.mediumText(
                fontSize: 24,
                color: widget.isReel ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
