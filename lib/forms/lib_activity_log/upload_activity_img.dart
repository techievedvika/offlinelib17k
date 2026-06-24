
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lib17000ft/forms/lib_activity_log/widget/custom_picker_option_card.dart';
import '../../components/custom_labeltext.dart';
import '../../configs/color/color.dart';

class UploadActivityImg extends StatefulWidget {
  final Function(List<File>) onImagesSelected;
  final List<File> selectedImages;

  const UploadActivityImg({
    super.key,
    required this.onImagesSelected,
    required this.selectedImages,
  });

  @override
  State<UploadActivityImg> createState() => _UploadActivityImgState();
}

class _UploadActivityImgState extends State<UploadActivityImg> {
  final ImagePicker _picker = ImagePicker();
  final int maxImages = 6;

  // Future<void> _pickImagesFromGallery() async {
  //   try {
  //     final List<XFile> pickedFiles =
  //     await _picker.pickMultiImage(imageQuality: 80);
  //
  //     if (pickedFiles.isNotEmpty) {
  //       List<File> files = pickedFiles.map((e) => File(e.path)).toList();
  //
  //       widget.onImagesSelected([...widget.selectedImages, ...files]);
  //
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     debugPrint("Error picking images: $e");
  //   }
  // }
  Future<void> _pickImagesFromGallery() async {
    try {
      final int currentCount = widget.selectedImages.length;
      final int remainingSlots = maxImages - currentCount;

      if (remainingSlots <= 0) {
        _showLimitReachedToast();
        return;
      }

      final List<XFile> pickedFiles = await _picker.pickMultiImage(imageQuality: 80);

      if (pickedFiles.isNotEmpty) {
        // Take only up to the remaining allowed slots
        List<File> newFiles = pickedFiles
            .take(remainingSlots)
            .map((e) => File(e.path))
            .toList();

        widget.onImagesSelected([...widget.selectedImages, ...newFiles]);

        if (pickedFiles.length > remainingSlots) {
          _showLimitReachedToast();
        }
        setState(() {});
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
  }

  // Future<void> _pickImageFromCamera() async {
  //   try {
  //     final XFile? pickedFile = await _picker.pickImage(
  //       source: ImageSource.camera,
  //       imageQuality: 80,
  //     );
  //
  //     if (pickedFile != null) {
  //       widget.onImagesSelected(
  //           [...widget.selectedImages, File(pickedFile.path)],
  //       );
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     debugPrint("Error picking image: $e");
  //   }
  // }
  Future<void> _pickImageFromCamera() async {
    if (widget.selectedImages.length >= maxImages) {
      _showLimitReachedToast();
      return;
    }
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        widget.onImagesSelected([...widget.selectedImages, File(pickedFile.path)]);
        setState(() {});
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _showLimitReachedToast() {
    Fluttertoast.showToast(
      msg: "Maximum $maxImages images allowed",
      backgroundColor: AppColors.error,
      textColor: Colors.white,
    );
  }

  /// SAFER REMOVE METHOD
  void _removeImage(int index) {
    final updatedList = [...widget.selectedImages]; // create safe copy
    updatedList.removeAt(index);

    widget.onImagesSelected(updatedList);

    setState(() {}); // ensure UI refresh
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAFAFA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add Photo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      PickerOptionCard(
                        icon: Icons.photo_library_rounded,
                        label: 'Gallery',
                        color: AppColors.secondary,
                        onTap: () {
                          Navigator.pop(context);
                          _pickImagesFromGallery();
                        },
                      ),
                      const SizedBox(width: 12),
                      PickerOptionCard(
                        icon: Icons.camera_alt_rounded,
                        label: 'Camera',
                        color: AppColors.secondary,
                        onTap: () {
                          Navigator.pop(context);
                          _pickImageFromCamera();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      backgroundColor: AppColors.errorContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(label: "Activity Photos"),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 200,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.shadow),
          ),
          child: widget.selectedImages.isNotEmpty
              ? GridView.builder(
            // itemCount: widget.selectedImages.length + 1,
            itemCount: widget.selectedImages.length < maxImages
                ? widget.selectedImages.length + 1
                : widget.selectedImages.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              // if (index == widget.selectedImages.length) {
              if (index == widget.selectedImages.length && widget.selectedImages.length < maxImages) {
                return GestureDetector(
                  onTap: _showPickerOptions,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border:
                      Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.add_a_photo,
                        color: Colors.grey),
                  ),
                );
              }

              return Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        widget.selectedImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
              : GestureDetector(
            onTap: _showPickerOptions,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo,
                    size: 50, color: Colors.grey),
                SizedBox(height: 8),
                Text("Tap to upload photos",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}