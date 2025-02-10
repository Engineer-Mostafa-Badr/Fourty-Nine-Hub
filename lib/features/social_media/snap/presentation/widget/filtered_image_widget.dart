import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class FilteredImageWidget extends StatefulWidget {
  const FilteredImageWidget({super.key});

  @override
  FilteredImageWidgetState createState() => FilteredImageWidgetState();
}

class FilteredImageWidgetState extends State<FilteredImageWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickAndFilterImage() async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      await _applyFilterToImage();
    }
  }

  Future<void> _applyFilterToImage() async {
    if (_selectedImage == null) return;

    // final filteredImage = await Navigator.of(context).push<File>(
    // MaterialPageRoute(
    // builder: (context) => PhotoFilter(
    //   image: _selectedImage!,
    //   presets: defaultColorFilters,
    //   cancelIcon: Icons.cancel,
    //   applyIcon: Icons.check,
    //   backgroundColor: Colors.black,
    //   sliderColor: Colors.blue,
    //   sliderLabelStyle: const TextStyle(color: Colors.white),
    //   bottomButtonsTextStyle: const TextStyle(color: Colors.white),
    //   presetsLabelTextStyle: const TextStyle(color: Colors.white),
    //   applyingTextStyle: const TextStyle(color: Colors.white),
    //   compressImage: true,
    //   onFinishApplyingFilter: (p0) async {
    //     if (p0 != null) {
    //       await GallerySaver.saveImage(p0.path);
    //       _selectedImage = p0;
    //       setState(() {});
    //     }
    //   },
    // ),
    // ),
    // );

    // if (filteredImage != null) {
    //   setState(() {
    //     _selectedImage = filteredImage;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text('Image Filter App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickAndFilterImage,
              child: const Text('Pick and Filter Image'),
            ),
            const SizedBox(height: 20),
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 300,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
