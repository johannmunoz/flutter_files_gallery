import 'package:files_gallery/src/file_icons_library.dart';
import 'package:files_gallery/src/file_types.dart';
import 'package:files_gallery/src/fullscreen/full_screen_file.dart';
import 'package:files_gallery/src/fullscreen/full_screen_image.dart';
import 'package:files_gallery/src/thumbnails/file_thumbnail.dart';
import 'package:files_gallery/src/thumbnails/image_thumbnail.dart';
import 'package:files_gallery/src/thumbnails/placeholder_container.dart';
import 'package:files_gallery/src/thumbnails_manager.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class Gallery extends StatelessWidget {
  final List<GalleryFile> files;
  final List<GalleryUrl> urls;
  final OnRemoveMemoryFile onDeleteMemoryFile;
  final OnRemoveNetworkFile onDeleteNetworkFile;
  final bool readonly;

  const Gallery({
    Key key,
    this.files,
    this.urls,
    this.onDeleteMemoryFile,
    this.onDeleteNetworkFile,
    this.readonly = false,
  }) : super(key: key);

  Future<Thumbnails> _getThumbnails() async {
    final networkThumbnails =
        await ThumbnailsManager().getNetworkThumbnails(urls);
    final memoryThumbnails =
        await ThumbnailsManager().getMemoryThumbnails(files);

    return Thumbnails(
      memoryThumbnails: memoryThumbnails,
      networkThumbnails: networkThumbnails,
    );
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

        return FutureBuilder<Thumbnails>(
          future: _getThumbnails(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final thumbnails = snapshot.data;
              List<Widget> listNetworkFiles =
                  thumbnails?.networkThumbnails != null
                      ? thumbnails.networkThumbnails
                          .asMap()
                          .map((index, galleryFile) => MapEntry(
                                index,
                                _buildNetworkMap(context, galleryFile, index),
                              ))
                          .values
                          .toList()
                      : [];

              List<Widget> listMemoryFiles =
                  thumbnails?.memoryThumbnails != null
                      ? thumbnails.memoryThumbnails
                          .asMap()
                          .map((index, galleryFile) => MapEntry(
                                index,
                                _buildMemoryMap(context, galleryFile, index),
                              ))
                          .values
                          .toList()
                      : [];
              if (listNetworkFiles.isEmpty && listMemoryFiles.isEmpty) {
                return Container();
              } else {
                return GridView.count(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.all(4),
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  crossAxisCount: rowItemsCount,
                  children: [...listNetworkFiles, ...listMemoryFiles],
                );
              }
            } else {
              return Container();
            }
          },
        );
      },
    );
  }

  Widget _buildNetworkMap(
      BuildContext context, GalleryFile galleryFile, int index) {
    final ext = extension(galleryFile.filename);

    final isImage = _checkIfIsImage(ext);
    return Container(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              if (isImage) {
                return FullScreenImage.network(
                  urls[index].url,
                  onDeleteImage: () => onDeleteNetworkFile(index),
                  readonly: readonly,
                );
              } else {
                return FullScreenFile(
                  fileicon: FileIcons.getFileIcon(ext),
                  filename: galleryFile.filename,
                  onDeleteImage: () => onDeleteNetworkFile(index),
                  readonly: readonly,
                );
              }
            },
          ),
        ),
        child: PlaceholderContainer(
          child: isImage
              ? ImageThumbnail.file(galleryFile.file)
              : FileThumbnail(
                  filename: galleryFile.filename,
                  ext: ext,
                ),
        ),
      ),
    );
  }

  Widget _buildMemoryMap(
      BuildContext context, GalleryFile galleryFile, int index) {
    final ext = extension(galleryFile.filename);
    final isImage = _checkIfIsImage(ext);

    return Container(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              if (isImage) {
                return FullScreenImage.file(
                  files[index].file,
                  onDeleteImage: () => onDeleteMemoryFile(index),
                  readonly: readonly,
                );
              } else {
                return FullScreenFile(
                  fileicon: relative(FileIcons.getFileIcon(ext)),
                  filename: galleryFile.filename,
                  onDeleteImage: () => onDeleteMemoryFile(index),
                  readonly: readonly,
                );
              }
            },
          ),
        ),
        child: PlaceholderContainer(
          child: isImage
              ? ImageThumbnail.file(galleryFile.file)
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
