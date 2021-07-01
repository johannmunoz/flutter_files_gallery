import 'dart:convert';
import 'dart:io';
import 'package:files_gallery/files_gallery.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ThumbnailsManager {
  Future<GalleryFile> getNetworkThumbnail(GalleryUrl urlItem) async {
    urlItem = _checkNullNetworkItem(urlItem);

    final filenameBasename = basenameWithoutExtension(urlItem.filename);
    final filenameExtension = extension(urlItem.filename);
    final fileExtension = filenameExtension.isEmpty
        ? extension(urlItem.url).split('?').first
        : filenameExtension;

    final filename = filenameBasename + fileExtension;

    if (!_checkIfIsImage(extension(filename))) {
      Directory dir = await getTemporaryDirectory();
      final pathDestiny = join(dir.path, 'thumbnails', filename);
      final file = File(pathDestiny);
      return GalleryFile(file: file, filename: filename);
    }

    final hashUrl = _getHashUrl(urlItem.url + '_thumbnail');

    File thumbFile = await _getCacheFile(hashUrl);

    if (thumbFile != null) {
      File originalFile = await _getCacheFile(urlItem.url);

      return GalleryFile(
        file: thumbFile,
        filename: filename,
        original: originalFile,
      );
    }

    final file = await _downloadFileToCache(urlItem.url);

    final fileBytes = await _getResizedFile(file);

    thumbFile = await _saveFileToCache(fileBytes, urlItem.url);
    return GalleryFile(
      file: thumbFile,
      filename: filename,
      original: file,
    );
  }

  Future<File> _getNetworkThumbnail(String url) async {
    if (!_checkIfIsImage(extension(url).split('?').first)) {
      File thumbFile = await _getCacheFile(url);
      return thumbFile;
    }
    final hashUrl = _getHashUrl(url + '_thumbnail');

    File thumbFile = await _getCacheFile(hashUrl);

    if (thumbFile != null) {
      return thumbFile;
    }

    final file = await _downloadFileToCache(url);

    final fileBytes = _getResizedFile(file);

    thumbFile = await _saveFileToCache(await fileBytes, url);

    return thumbFile;
  }

  Future<GalleryFile> getMemoryThumbnail(GalleryFile fileItem) async {
    fileItem = _checkNullMemoryItem(fileItem);

    if (!_checkIfIsImage(extension(fileItem.filename))) {
      Directory dir = await getTemporaryDirectory();
      final pathDestiny = join(dir.path, 'thumbnails', fileItem.filename);
      final file = File(pathDestiny);
      return GalleryFile(file: file, filename: fileItem.filename);
    }
    final hashUrl = _getHashUrl(fileItem.file.path + '_thumbnail');

    File thumbFile = await _getCacheFile(hashUrl);

    if (thumbFile != null) {
      return GalleryFile(
        file: thumbFile,
        filename: fileItem.filename,
        original: fileItem.file,
      );
    }

    final fileBytes = _getResizedFile(fileItem.file);

    thumbFile = await _saveFileToCache(await fileBytes, fileItem.file.path);

    return GalleryFile(
      file: thumbFile,
      filename: fileItem.filename,
      original: fileItem.file,
    );
  }

  Future<File> _getMemoryThumbnail(File fileItem) async {
    if (!_checkIfIsImage(extension(fileItem.path))) {
      Directory dir = await getTemporaryDirectory();
      final pathDestiny = join(dir.path, 'thumbnails', basename(fileItem.path));
      final file = File(pathDestiny);
      return file;
    }
    final hashUrl = _getHashUrl(fileItem.path + '_thumbnail');

    File thumbFile = await _getCacheFile(hashUrl);

    if (thumbFile != null) {
      return thumbFile;
    }

    final fileBytes = await _getResizedFile(fileItem);

    thumbFile = await _saveFileToCache(fileBytes, fileItem.path);

    return thumbFile;
  }

  Future<File> _downloadFileToCache(String url) async {
    return await _getCacheFile(url);
  }

  Future<List<int>> _getResizedFile(File file) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      file.path,
      quality: 70,
      targetWidth: 200,
      targetHeight: 200,
    );
    return compressedFile.readAsBytes();
  }

  Future<File> _saveFileToCache(List<int> bytes, String url) async {
    final thumbUrl = _getHashUrl(url + '_thumbnail');
    final thumbnail = await DefaultCacheManager()
        .putFile(thumbUrl, bytes, fileExtension: 'png');
    return thumbnail;
  }

  String _getHashUrl(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  Future<List<GalleryFile>> getNetworkThumbnails(
      List<GalleryUrl> networkFiles) async {
    if (networkFiles == null) return [];
    final thumbnails = await Future.wait(networkFiles.map((url) async {
      url = _checkNullNetworkItem(url);
      final thumbnailFile =
          await ThumbnailsManager()._getNetworkThumbnail(url.url);
      return GalleryFile(file: thumbnailFile, filename: url.filename);
    }).toList());
    return thumbnails;
  }

  Future<List<GalleryFile>> getMemoryThumbnails(
      List<GalleryFile> memoryFiles) async {
    if (memoryFiles == null) return [];
    final thumbnails = await Future.wait(memoryFiles.map((file) async {
      file = _checkNullMemoryItem(file);
      final thumbnailFile =
          await ThumbnailsManager()._getMemoryThumbnail(file.file);
      return GalleryFile(file: thumbnailFile, filename: file.filename);
    }).toList());
    return thumbnails;
  }

  GalleryUrl _checkNullNetworkItem(GalleryUrl urlItem) {
    if (urlItem == null) {
      urlItem = GalleryUrl(
        filename: 'file.png',
        url: 'https://via.placeholder.com/300.png',
      );
    }

    if (urlItem.filename == null || urlItem.filename.isEmpty) {
      urlItem.filename = 'file.file';
    }

    if (urlItem.url == null || urlItem.url.isEmpty) {
      urlItem.url = 'https://via.placeholder.com/300.png';
    }

    return urlItem;
  }

  GalleryFile _checkNullMemoryItem(GalleryFile fileItem) {
    if (fileItem == null || fileItem.file == null) {
      fileItem = GalleryFile(filename: 'file.file');
    }

    return fileItem;
  }

  Future<File> _getCacheFile(String url) async {
    try {
      final thumbFile = await DefaultCacheManager().getSingleFile(url);
      return thumbFile;
    } catch (e) {
      return null;
    }
  }

  bool _checkIfIsImage(String ext) {
    switch (ext.toLowerCase()) {
      case '.png':
      case '.jpeg':
      case '.jpg':
      case '.gif':
      case '.svg':
      case '.ico':
      case '.tif':
      case '.tiff':
      case '.psd':
      case '.psb':
      case '.ami':
      case '.apx':
      case '.bmp':
      case '.bpg':
      case '.brk':
      case '.cur':
      case '.dds':
      case '.dng':
      case '.exr':
      case '.fpx':
      case '.gbr':
      case '.img':
      case '.jbig2':
      case '.jb2':
      case '.jng':
      case '.jxr':
      case '.pbm':
      case '.pgf':
      case '.pic':
      case '.raw':
      case '.webp':
      case '.eps':
        return true;
      default:
        return false;
    }
  }
}

class Thumbnails {
  List<GalleryFile> memoryThumbnails;
  List<GalleryFile> networkThumbnails;
  Thumbnails({
    this.memoryThumbnails,
    this.networkThumbnails,
  });
}
