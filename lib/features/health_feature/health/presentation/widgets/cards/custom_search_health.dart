import 'package:flutter/material.dart';

class CustomSearchHealth extends StatelessWidget {
  final Function(String)? onSearch;

  const CustomSearchHealth({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2C3E50), // Navy desaturated blue border
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onChanged: onSearch,
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Colors.black54),
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );;
  }
}
