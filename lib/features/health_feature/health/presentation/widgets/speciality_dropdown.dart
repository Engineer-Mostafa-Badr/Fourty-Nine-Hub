import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SpecialityDropdown<T> extends StatefulWidget {
  const SpecialityDropdown({
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
  _CustomDropdownHealthState<T> createState() =>
      _CustomDropdownHealthState<T>();
}

class _CustomDropdownHealthState<T> extends State<SpecialityDropdown<T>>
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
  void didUpdateWidget(SpecialityDropdown<T> oldWidget) {
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
                    // elevation: 4,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: widget.maxHeight,
                      ),
                      decoration: widget.dropdownDecoration ??
                          ShapeDecoration(
                            color: const Color(0xFFE1E1E1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shrinkWrap: true,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          return InkWell(
                            onTap: () {
                              setState(() => _selectedItem = item);
                              widget.onItemSelected(item);
                              _closeDropdown();
                            },
                            child: widget.itemBuilder != null
                                ? widget.itemBuilder!(item)
                                : Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Label(
                                text: widget.displayStringForItem(item),
                                style: widget.itemTextStyle ??
                                    Styles.headerText(
                                      fontSize: 28,
                                      height: 1.60,
                                      color: _selectedItem == item
                                          ? const Color(0xFFF33D49)
                                          : Colors.black,
                                    ),
                              ),
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
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal:12),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1
            ),
            borderRadius: BorderRadius.circular(15)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(
                text: _getDisplayText(),
                style:Styles.mediumText(fontWeight: FontWeight.w600, fontSize: 32),
                textAlign: widget.textAlign ?? TextAlign.start,
              ),
              Icon(
                isOpen
                    ? (widget.openedIcon ?? Icons.keyboard_arrow_up)
                    : (widget.closedIcon ?? Icons.keyboard_arrow_down),
                color: widget.iconColor ?? const Color(0xff0B1035),
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

    return widget.displayStringForItem(_selectedItem!);
  }
}
