import 'package:flutter/material.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    required this.onItemSelected,
    this.selectedItem,
    this.hint = "Select an item",
    this.maxHeight = 300,
    this.itemBuilder,
    this.dropdownDecoration,
    this.buttonDecoration,
    this.buttonTextStyle,
    this.itemTextStyle,
    required this.displayStringForItem,
    this.textAlign,
    this.openedIcon,
    this.closedIcon,
    this.iconColor,
  });

  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T> onItemSelected;
  final String hint;
  final double maxHeight;
  final Widget Function(T item)? itemBuilder;
  final BoxDecoration? dropdownDecoration;
  final BoxDecoration? buttonDecoration;
  final TextStyle? buttonTextStyle;
  final TextStyle? itemTextStyle;
  final String Function(T item) displayStringForItem;
  final TextAlign? textAlign;
  final IconData? openedIcon;
  final IconData? closedIcon;
  final Color? iconColor;

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != oldWidget.selectedItem) {
      _selectedItem = widget.selectedItem;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleDropdown() {
    if (isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
    setState(() => isOpen = true);
  }

  void _closeDropdown() {
    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      setState(() => isOpen = false);
    });
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeDropdown,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 5,
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                offset: Offset(0, size.height + 5),
                child: SizeTransition(
                  axisAlignment: -1,
                  sizeFactor: _expandAnimation,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: widget.maxHeight,
                      ),
                      decoration: widget.dropdownDecoration ??
                          ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignCenter,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          return InkWell(
                            onTap: () {
      ManageVibration.vibrate();
                              setState(() => _selectedItem = item);
                              widget.onItemSelected(item);
                              _closeDropdown();
                            },
                            child: widget.itemBuilder != null
                                ? widget.itemBuilder!(item)
                                : ListTile(
                                    title: Text(
                                      widget.displayStringForItem(item),
                                      style: widget.itemTextStyle ??
                                          TextStyle(fontSize: 16),
                                    ),
                                    selected: _selectedItem == item,
                                  ),
                          );
                        },
                      ),
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

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: widget.buttonDecoration ??
              BoxDecoration(
                color: const Color(0xFF0B1035),
                borderRadius: BorderRadius.circular(8),
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  _getDisplayText(),
                  style: widget.buttonTextStyle ??
                      const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                  textAlign: widget.textAlign ?? TextAlign.center,
                ),
              ),
              Icon(
                isOpen
                    ? (widget.openedIcon ?? Icons.arrow_drop_up)
                    : (widget.closedIcon ?? Icons.arrow_drop_down),
                color: widget.iconColor ?? Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (_selectedItem == null) {
      return widget.hint;
    }

    return widget.displayStringForItem(_selectedItem as T);
  }
}
