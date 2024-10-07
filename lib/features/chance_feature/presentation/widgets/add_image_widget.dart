import 'package:flutter/material.dart';


class AddImageWidget extends StatelessWidget {
  const AddImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Icon indicating image upload
        Icon(
          Icons.image,
          size: 100,
          color: Colors.blueAccent,
        ),
        SizedBox(height: 20),
        // Add Images Button
        ElevatedButton(
          onPressed: () {
            // أضف الإجراء الذي تريد تنفيذه عند الضغط على الزر
            print("Add Images button pressed!");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // لون الزر
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Add Images',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        SizedBox(height: 20),
        // Text showing file size limit
        Text(
          '5MB maximum file size accepted in the following formats:',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
