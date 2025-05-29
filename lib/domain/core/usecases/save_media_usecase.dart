import 'dart:io';

import 'package:camera_test_task/domain/core/repository/media_repository.dart';

abstract class SaveMediaUsecase {
  const SaveMediaUsecase(this._mediaRepository);

  final MediaRepository _mediaRepository;

  Future<File> getMediaFile();

  Future<void> call() async {
    final file = await getMediaFile();
    await _mediaRepository.saveFile(file.path);
    await file.delete();
  }
}
