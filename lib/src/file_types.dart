import 'dart:io';

class GalleryFile {
  File file;
  String filename;
  File original;
  GalleryFile({
    this.file,
    this.filename,
    this.original,
  });
}

class GalleryUrl {
  String url;
  String filename;
  File original;
  GalleryUrl({
    this.url,
    this.filename,
    this.original,
  });
}
