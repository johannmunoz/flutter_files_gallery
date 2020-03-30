import 'dart:io';

import 'package:files_gallery/src/file_icons_library.dart';
import 'package:files_gallery/src/full_screen_file.dart';
import 'package:files_gallery/src/full_screen_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
                runSpacing: 2.0,
                children: [
                  if (files != null && files.isNotEmpty)
                    ...files
                        .asMap()
                        .map((index, file) => MapEntry(
                              index,
                              _buildMemoryMap(context, file, index, borderSize),
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
                            _buildNetworkMap(
                                context, filename, url, index, borderSize),
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

  GestureDetector _buildNetworkMap(BuildContext context, String filename,
      String url, int index, double borderSize) {
    final ext = extension(filename);
    final isImage = _checkIfIsImage(ext);
    return GestureDetector(
      onLongPress: () => print('long press'),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            final ext = extension(filename);
            if (_checkIfIsImage(ext)) {
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
      child: Container(
        color: Colors.black,
        height: borderSize,
        width: borderSize,
        alignment: Alignment.center,
        child: Stack(children: [
          Positioned.fill(
            child: Container(
              child: Icon(
                Icons.image,
                color: Colors.white,
              ),
            ),
          ),
          Positioned.fill(
            child: isImage
                ? _buildNetworkImageWidget(url, borderSize)
                : _buildFileWidget(filename, ext, borderSize),
          ),
        ]),
      ),
    );
  }

  Widget _buildMemoryMap(
    BuildContext context,
    File file,
    int index,
    double borderSize,
  ) {
    final ext = extension(file.path);
    final filename = basename(file.path);
    final isImage = _checkIfIsImage(ext);

    return GestureDetector(
      onLongPress: () => print('long press'),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            if (isImage) {
              return FullScreenImage.file(
                file,
                onDeleteImage: () => onDeleteMemoryFile(index),
              );
            } else {
              return FullScreenFile(
                fileicon: relative(FileIcons.getFileIcon(ext)),
                filename: filename,
                onDeleteImage: () => onDeleteMemoryFile(index),
              );
            }
          },
        ),
      ),
      child: Container(
        color: Colors.black,
        height: borderSize,
        width: borderSize,
        alignment: Alignment.center,
        child: Stack(children: [
          Positioned.fill(
            child: Container(
              child: Icon(
                Icons.image,
                color: Colors.white,
              ),
            ),
          ),
          Positioned.fill(
            child: isImage
                ? _buildMemoryImageWidget(file, borderSize)
                : _buildFileWidget(filename, ext, borderSize),
          ),
        ]),
      ),
    );
  }

  Container _buildMemoryImageWidget(File file, double borderSize) {
    return Container(
      child: FadeInImage(
        placeholder: Image.memory(kTransparentImage).image,
        image: FileImage(file),
        height: borderSize,
        width: borderSize,
        fit: BoxFit.cover,
      ),
    );
  }

  Container _buildNetworkImageWidget(String url, double borderSize) {
    return Container(
      child: FadeInImage(
        placeholder: Image.memory(kTransparentImage).image,
        image: NetworkImage(url),
        height: borderSize,
        width: borderSize,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildFileWidget(String filename, String ext, double borderSize) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            padding: EdgeInsets.all(15.0),
            color: Colors.grey[300],
            child: SvgPicture.asset(
              relative(FileIcons.getFileIcon(ext)),
              package: 'files_gallery',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            color: Colors.black26,
            child: Text(
              filename,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
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
