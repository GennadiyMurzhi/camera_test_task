import 'dart:io';

import 'package:camera_test_task/domain/gallery/repository/gallery_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GalleryRepository)
class GalleryRepositoryImpl implements GalleryRepository {
  const GalleryRepositoryImpl(this._imagePicker);
  final ImagePicker _imagePicker;

  @override
  Future<File?> pickeImage() async {
    final XFile? xImageFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (xImageFile == null) {
      return null;
    }
    return File(xImageFile.path);
  }
}
