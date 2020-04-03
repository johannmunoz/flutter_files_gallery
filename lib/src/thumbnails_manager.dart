import 'dart:convert';
import 'dart:io';
import 'package:files_gallery/files_gallery.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:crypto/crypto.dart';
import 'package:image/image.dart';

class ThumbnailsManager {
  Future<File> _getNetworkThumbnail(String url) async {
    final hashUrl = _getHashUrl(url + '_thumbnail');

    File thumbFile = await DefaultCacheManager().getSingleFile(hashUrl);

    if (thumbFile != null) {
      return thumbFile;
    }

    final file = await _downloadFileToCache(url);

    final fileBytes = _getResizedFile(file);

    thumbFile = await _saveFileToCache(fileBytes, url);

    return thumbFile;
  }

  Future<File> getMemoryThumbnail(File file) async {
    final hashUrl = _getHashUrl(file.path + '_thumbnail');

    File thumbFile = await DefaultCacheManager().getSingleFile(hashUrl);

    if (thumbFile != null) {
      return thumbFile;
    }

    final fileBytes = _getResizedFile(file);

    thumbFile = await _saveFileToCache(fileBytes, file.path);

    return thumbFile;
  }

  Future<File> _downloadFileToCache(String url) async {
    return await DefaultCacheManager().getSingleFile(url);
  }

  List<int> _getResizedFile(File file) {
    Image image = decodeImage(file.readAsBytesSync());
    Image thumbnail = copyResize(
      image,
      width: 150,
      height: 150,
    );
    return encodePng(thumbnail);
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
          await ThumbnailsManager().getMemoryThumbnail(file.file);
      return GalleryFile(file: thumbnailFile, filename: file.filename);
    }).toList());
    return thumbnails;
  }

  GalleryUrl _checkNullNetworkItem(GalleryUrl galleryUrl) {
    if (galleryUrl == null) {
      galleryUrl = GalleryUrl(
        filename: 'file.png',
        url: 'https://via.placeholder.com/300.png',
      );
    }

    if (galleryUrl.filename == null || galleryUrl.filename.isEmpty) {
      galleryUrl.filename = 'file.png';
    }

    if (galleryUrl.url == null || galleryUrl.url.isEmpty) {
      galleryUrl.url = 'https://via.placeholder.com/300.png';
    }

    return galleryUrl;
  }

  GalleryFile _checkNullMemoryItem(GalleryFile galleryFile) {
    if (galleryFile == null || galleryFile.file == null) {
      galleryFile = GalleryFile(filename: 'file.file');
    }

    return galleryFile;
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
