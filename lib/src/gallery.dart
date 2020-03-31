import 'package:files_gallery/src/file_icons_library.dart';
import 'package:files_gallery/src/file_types.dart';
import 'package:files_gallery/src/fullscreen/full_screen_file.dart';
import 'package:files_gallery/src/fullscreen/full_screen_image.dart';
import 'package:files_gallery/src/thumbnails/file_thumbnail.dart';
import 'package:files_gallery/src/thumbnails/image_thumbnail.dart';
import 'package:files_gallery/src/thumbnails/placeholder_container.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Gallery extends StatelessWidget {
  final List<GalleryFile> files;
  final List<GalleryUrl> urls;
  final OnRemoveMemoryFile onDeleteMemoryFile;
  final OnRemoveNetworkFile onDeleteNetworkFile;

  const Gallery({
    Key key,
    this.files,
    this.urls,
    this.onDeleteMemoryFile,
    this.onDeleteNetworkFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        var borderSize = 100.0;
        if (MediaQuery.of(context).orientation == Orientation.landscape) {
          borderSize = (boxConstraints.maxWidth / 6) - 2;
        } else {
          borderSize = (boxConstraints.maxWidth / 4) - 2;
        }

        return Row(
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 2.0,
                runSpacing: 2.0,
                children: [
                  if (files != null && files.isNotEmpty)
                    ...files
                        .asMap()
                        .map((index, galleryFile) => MapEntry(
                              index,
                              _buildMemoryMap(
                                  context, galleryFile, index, borderSize),
                            ))
                        .values
                        .toList(),
                  if (urls != null && urls.isNotEmpty)
                    ...urls
                        .asMap()
                        .map((index, galleryUrl) => MapEntry(
                              index,
                              _buildNetworkMap(
                                  context, galleryUrl, index, borderSize),
                            ))
                        .values
                        .toList()
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNetworkMap(BuildContext context, GalleryUrl galleryUrl,
      int index, double borderSize) {
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
      width: borderSize,
      height: borderSize,
      child: GestureDetector(
        onLongPress: () => print('long press'),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              if (isImage) {
                return FullScreenImage.network(
                  url,
                  onDeleteImage: () => onDeleteNetworkFile(index),
                );
              } else {
                return FullScreenFile(
                  fileicon: FileIcons.getFileIcon(ext),
                  filename: filename,
                  onDeleteImage: () => onDeleteNetworkFile(index),
                );
              }
            },
          ),
        ),
        child: PlaceholderContainer(
          child: isImage
              ? ImageThumbnail.network(url, borderSize: borderSize)
              : FileThumbnail(
                  filename: filename,
                  ext: ext,
                ),
        ),
      ),
    );
  }

  Widget _buildMemoryMap(
    BuildContext context,
    GalleryFile galleryFile,
    int index,
    double borderSize,
  ) {
    if (galleryFile == null || galleryFile.file == null) {
      galleryFile = GalleryFile(filename: 'file.file');
    }
    final ext = extension(galleryFile.filename);
    final isImage = _checkIfIsImage(ext);

    return Container(
      width: borderSize,
      height: borderSize,
      child: GestureDetector(
        onLongPress: () => print('long press'),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              if (isImage) {
                return FullScreenImage.file(
                  galleryFile.file,
                  onDeleteImage: () => onDeleteMemoryFile(index),
                );
              } else {
                return FullScreenFile(
                  fileicon: relative(FileIcons.getFileIcon(ext)),
                  filename: galleryFile.filename,
                  onDeleteImage: () => onDeleteMemoryFile(index),
                );
              }
            },
          ),
        ),
        child: PlaceholderContainer(
          child: isImage
              ? ImageThumbnail.file(galleryFile.file, borderSize: borderSize)
              : FileThumbnail(
                  filename: galleryFile.filename,
                  ext: ext,
                ),
        ),
      ),
    );
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

typedef void OnRemoveMemoryFile(int indexFile);
typedef void OnRemoveNetworkFile(int indexFile);
