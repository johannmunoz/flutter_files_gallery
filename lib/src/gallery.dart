import 'dart:io';

import 'package:files_gallery/src/file_icons_library.dart';
import 'package:files_gallery/src/full_screen_file.dart';
import 'package:files_gallery/src/full_screen_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:path/path.dart';

class Gallery extends StatelessWidget {
  final List<File> files;
  final List<String> urls;
  final OnRemoveMemoryFile onDeleteMemoryFile;
  final OnRemoveNetworkFile onDeleteNetworkFile;

  const Gallery(
      {Key key,
      this.files,
      this.urls,
      this.onDeleteMemoryFile,
      this.onDeleteNetworkFile})
      : super(key: key);

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
                children: [
                  if (files != null && files.isNotEmpty)
                    ...files
                        .asMap()
                        .map((index, file) => MapEntry(
                              index,
                              GestureDetector(
                                onLongPress: () => print('long press'),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      final ext = extension(file.path);
                                      if (_isImage(ext)) {
                                        return FullScreenImage.file(
                                          file,
                                          onDeleteImage: () =>
                                              onDeleteMemoryFile(index),
                                        );
                                      } else {
                                        final filename = basename(file.path);
                                        return FullScreenFile(
                                          fileicon: FileIcons.getFileIcon(ext),
                                          filename: filename,
                                          onDeleteImage: () =>
                                              onDeleteMemoryFile(index),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                child: Container(
                                  child: FadeInImage(
                                    placeholder:
                                        Image.memory(kTransparentImage).image,
                                    image: FileImage(file),
                                    height: borderSize,
                                    width: borderSize,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ))
                        .values
                        .toList(),
                  if (urls != null && urls.isNotEmpty)
                    ...urls
                        .asMap()
                        .map((index, fullUrl) {
                          var url = 'https://via.placeholder.com/300.png';
                          var filename = 'file.png';
                          final paths = fullUrl.split('+');
                          if (paths.isNotEmpty) {
                            url = paths.first;
                            filename = paths.last;
                          }
                          return MapEntry(
                            index,
                            GestureDetector(
                              onLongPress: () => print('long press'),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    final ext = extension(filename);
                                    if (_isImage(ext)) {
                                      return FullScreenImage.network(
                                        url,
                                        onDeleteImage: () =>
                                            onDeleteNetworkFile(index),
                                      );
                                    } else {
                                      return FullScreenFile(
                                        fileicon: FileIcons.getFileIcon(ext),
                                        filename: filename,
                                        onDeleteImage: () =>
                                            onDeleteNetworkFile(index),
                                      );
                                    }
                                  },
                                ),
                              ),
                              child: Container(
                                child: FadeInImage(
                                  placeholder:
                                      Image.memory(kTransparentImage).image,
                                  image: NetworkImage(url),
                                  height: borderSize,
                                  width: borderSize,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        })
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

  bool _isImage(String ext) {
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
