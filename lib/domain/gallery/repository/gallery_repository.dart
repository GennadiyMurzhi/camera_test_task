import 'dart:io';

abstract class GalleryRepository {
  Future<File?> pickeImage();
}
