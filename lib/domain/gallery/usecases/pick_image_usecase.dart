import 'dart:io';

import 'package:camera_test_task/domain/gallery/repository/gallery_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PickImageUsecase {
  const PickImageUsecase(this._galleryRepository);

  final GalleryRepository _galleryRepository;

  Future<File?> call() async {
    return await _galleryRepository.pickeImage();
  }
}
