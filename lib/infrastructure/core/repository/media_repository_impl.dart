import 'package:camera_test_task/domain/core/repository/media_repository.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: MediaRepository)
class MediaRepositoryImpl implements MediaRepository {
  @override
  Future<void> saveFile(String filePath) async {
    await ImageGallerySaverPlus.saveFile(filePath);
  }
}
