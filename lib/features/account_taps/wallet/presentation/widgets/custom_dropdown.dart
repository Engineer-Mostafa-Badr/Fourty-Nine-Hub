import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key,
    // required this.initialItem,
    required this.items,
    required this.onItemSelected,
    this.hint = "Select an item",
  });

  final List<MainCategoryWalletEntity> items; // Each item has 'id' and 'label'
  final ValueChanged<MainCategoryWalletEntity> onItemSelected;
  final String hint;

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool isOpen = false;
  String? selectedItem;
  late AnimationController _animationController;
  // late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // _opacityAnimation = CurvedAnimation(
    //   parent: _animationController,
    //   curve: Curves.easeInOut,
    // );
  }

  @override
  void dispose() {
    _animationController.dispose();
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
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    // var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, size.height + 5),
          child: Material(
            // elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 300,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: widget.items.map((item) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedItem = context.locale == Locales.english
                            ? item.nameEn
                            : item.nameAr;
                        widget.onItemSelected(item);
                      });
                      _closeDropdown();
                    },
                    child: ListTile(
                      title: Text(
                        context.locale == Locales.english
                            ? item.nameEn
                            : item.nameAr,
                        style: Styles.headerText(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
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
          decoration: BoxDecoration(
            color: const Color(0xFF0B1035),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Icon(
                  isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: Label(
                  text: selectedItem ?? widget.hint,
                  style: Styles.headerText(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
