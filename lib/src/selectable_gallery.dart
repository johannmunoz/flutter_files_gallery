import 'package:files_gallery/src/file_types.dart';
import 'package:files_gallery/src/thumbnails/file_thumbnail.dart';
import 'package:files_gallery/src/thumbnails/image_thumbnail.dart';
import 'package:files_gallery/src/thumbnails/selectable_container.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class SelectableGallery extends StatefulWidget {
  final List<GalleryFile> files;
  final List<GalleryUrl> urls;
  final OnSelectedFiles onSelectedFiles;
  final OnSelectedUrls onSelectedUrls;
  final bool reverse;

  const SelectableGallery({
    Key key,
    this.files,
    this.urls,
    this.onSelectedFiles,
    this.onSelectedUrls,
    this.reverse = false,
  }) : super(key: key);

  @override
  _SelectableGalleryState createState() => _SelectableGalleryState();
}

class _SelectableGalleryState extends State<SelectableGallery> {
  List<int> listSelectedFiles = [];
  List<int> listSelectedUrls = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _initLists());

    super.initState();
  }

  void _initLists() {
    if (widget.files != null && widget.files.isNotEmpty) {
      for (int i = 0; i < widget.files.length; i++) {
        listSelectedFiles.add(i);
      }
    }

    if (widget.urls != null && widget.urls.isNotEmpty) {
      for (int i = 0; i < widget.urls.length; i++) {
        listSelectedUrls.add(i);
      }
    }
    if (widget.onSelectedFiles != null) {
      if (widget.reverse) {
        listSelectedFiles = listSelectedFiles.reversed.toList();
      }
      widget.onSelectedFiles(listSelectedFiles);
    }
    if (widget.onSelectedUrls != null) {
      if (widget.reverse) {
        listSelectedUrls = listSelectedUrls.reversed.toList();
      }
      widget.onSelectedUrls(listSelectedUrls);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        final maxWidth = boxConstraints.maxWidth;
        final isMobile = maxWidth < 600;

        var rowItemsCount = 4;

        if (isMobile) {
          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            rowItemsCount = 8;
          }
        } else {
          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            rowItemsCount = 8;
          } else {
            rowItemsCount = 6;
          }
        }

        List<Widget> listNetworkFiles = widget.urls != null
            ? widget.urls
                .asMap()
                .map((index, galleryUrl) => MapEntry(
                      index,
                      _buildNetworkMap(context, galleryUrl, index),
                    ))
                .values
                .toList()
            : [];

        List<Widget> listMemoryFiles = widget.files != null
            ? widget.files
                .asMap()
                .map((index, galleryFile) => MapEntry(
                      index,
                      _buildMemoryMap(context, galleryFile, index),
                    ))
                .values
                .toList()
            : [];

        return GridView.count(
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.all(4),
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          crossAxisCount: rowItemsCount,
          children: <Widget>[...listNetworkFiles, ...listMemoryFiles],
        );
      },
    );
  }

  Widget _buildNetworkMap(
      BuildContext context, GalleryUrl galleryUrl, int index) {
    if (galleryUrl == null) {
      galleryUrl = GalleryUrl(
        filename: 'file.png',
        url: 'https://via.placeholder.com/300.png',
      );
    }

    final filename =
        galleryUrl.filename != null && galleryUrl.filename.isNotEmpty
            ? galleryUrl.filename
            : 'file.png';

    final url = galleryUrl.url != null && galleryUrl.url.isNotEmpty
        ? galleryUrl.url
        : 'https://via.placeholder.com/300.png';

    final ext = extension(filename);
    final isImage = _checkIfIsImage(ext);
    return Container(
      child: SelectableContainer(
        onTap: () {
          _addRemoveNetworkIndex(index);
          if (widget.onSelectedUrls != null) {
            widget.onSelectedUrls(listSelectedUrls);
          }
        },
        child: isImage
            ? ImageThumbnail.network(url)
            : FileThumbnail(
                filename: filename,
                ext: ext,
              ),
      ),
    );
  }

  Widget _buildMemoryMap(
      BuildContext context, GalleryFile galleryFile, int index) {
    if (galleryFile == null || galleryFile.file == null) {
      galleryFile = GalleryFile(filename: 'file.file');
    }
    final ext = extension(galleryFile.filename);
    final isImage = _checkIfIsImage(ext);

    return Container(
      child: SelectableContainer(
        onTap: () {
          _addRemoveFileIndex(index);
          if (widget.onSelectedFiles != null) {
            widget.onSelectedFiles(listSelectedFiles);
          }
        },
        child: isImage
            ? ImageThumbnail.file(galleryFile.file)
            : FileThumbnail(
                filename: galleryFile.filename,
                ext: ext,
              ),
      ),
    );
  }

  void _addRemoveNetworkIndex(int index) {
    final isOnList = listSelectedUrls.contains(index);
    if (isOnList) {
      listSelectedUrls.remove(index);
    } else {
      listSelectedUrls.add(index);
    }
    listSelectedUrls.sort();
    if (widget.reverse) {
      listSelectedUrls = listSelectedUrls.reversed.toList();
    }
  }

  void _addRemoveFileIndex(int index) {
    final isOnList = listSelectedFiles.contains(index);
    if (isOnList) {
      listSelectedFiles.remove(index);
    } else {
      listSelectedFiles.add(index);
    }
    listSelectedFiles.sort();
    if (widget.reverse) {
      listSelectedFiles = listSelectedFiles.reversed.toList();
    }
  }

  bool _checkIfIsImage(String ext) {
    switch (ext) {
      case '.png':
      case '.jpeg':
      case '.jpg':
        return true;
      default:
        return false;
    }
  }
}

typedef void OnSelectedFiles(List<int> indexesSelected);
typedef void OnSelectedUrls(List<int> indexesSelected);
