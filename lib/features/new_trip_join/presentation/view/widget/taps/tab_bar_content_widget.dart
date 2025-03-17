import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../../core/localization/locale_keys.g.dart';

class TabBarContentWidget extends StatefulWidget {
  final TabController tabController;

  const TabBarContentWidget({super.key, required this.tabController});

  @override
  _TabBarContentWidgetState createState() => _TabBarContentWidgetState();
}

class _TabBarContentWidgetState extends State<TabBarContentWidget> {
  final List<String> hints = [
    "Explore trips that are active at the moment.",
    "Manage and review your bookings here.",
    "Check your ongoing trips and track progress.",
    "See your past trips and history."
  ];

  final List<List<String>> tabContents = [
    [],
    [],
    [],
    [],
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.tabController,
      builder: (context, child) {
        int index = widget.tabController.index;
        bool isEmpty = tabContents[index].isEmpty;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  hints[index],
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            ),
            Expanded(
              child: isEmpty
                  ? Center(
                      child: Text(_emptyMessage(
                      index,
                      LocaleKeys.thereIsNoTripsInThisList.localize,
                    )))
                  : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: tabContents[index].length,
                      itemBuilder: (context, i) {
                        return ListTile(title: Text(tabContents[index][i]));
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  String _emptyMessage(int index, String message) {
    switch (index) {
      case 0:
        return message;
      case 1:
        return message;
      case 2:
        return message;
      case 3:
        return message;
      default:
        return message;
    }
  }
}
