import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../helpers/manage_vibration.dart';

class OverlayCircularMenu extends StatefulWidget {
  final Widget mainIcon;
  final List<CircularMenuItem> menuItems;
  final double radius;
  final Color overlayColor;

  const OverlayCircularMenu({
    super.key,
    required this.mainIcon,
    required this.menuItems,
    this.radius = 100.0,
    this.overlayColor = Colors.black54,
  });

  @override
  _OverlayCircularMenuState createState() => _OverlayCircularMenuState();
}

class CircularMenuItem {
  final Widget icon;
  final Function() onPressed;

  CircularMenuItem({required this.icon, required this.onPressed});
}

class _OverlayCircularMenuState extends State<OverlayCircularMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _hideMenu();
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isOpen) {
      _hideMenu();
    } else {
      _showMenu();
    }
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  void _showMenu() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  void _hideMenu() {
    _controller.reverse().whenComplete(() {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      }
    });
  }

  void _handleItemTap(int index) {
    print('تم النقر على الأيقونة الفرعية رقم $index');
    // تنفيذ الإجراء المطلوب
    widget.menuItems[index].onPressed();

    // إغلاق القائمة بعد تنفيذ الإجراء
    _hideMenu();
    setState(() {
      _isOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              // الطبقة المظللة التي تغطي كامل الشاشة
              Positioned.fill(
                child: Container(
                  color: widget.overlayColor,
                ),
              ),

              // القائمة الدائرية مرتبطة بموقع الأيقونة الرئيسية
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0, 0),
                child: Material(
                  color: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // الأيقونات الفرعية
                      ...List.generate(widget.menuItems.length, (index) {
                        // حساب موقع كل أيقونة بناءً على زاوية معينة
                        final double angle =
                            (2 * pi / widget.menuItems.length) * index;

                        // حساب الموقع باستخدام دوال الزاوية
                        final double x = widget.radius * cos(angle);
                        final double y = widget.radius * sin(angle);

                        return AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(x, y) * _animation.value,
                              child: Transform.scale(
                                scale: _animation.value,
                                child: Opacity(
                                  opacity: _animation.value,
                                  child: InkWell(
                                    customBorder: CircleBorder(),
                                    onTap: () {
      ManageVibration.vibrate();
                                      print(
                                          '----------------------- Inside onTap -----------------------');
                                      _handleItemTap(index);
                                    },
                                    child: widget.menuItems[index].icon,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),

                      // عرض الأيقونة الرئيسية في المنتصف مع إمكانية الضغط عليها للإغلاق
                      InkWell(
                        customBorder: CircleBorder(),
                        onTap: _hideMenu,
                        child: widget.mainIcon,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // استخدام CompositedTransformTarget لربط الأيقونة الرئيسية بالقائمة المنبثقة
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: _toggleMenu,
        child: widget.mainIcon,
      ),
    );
  }
}