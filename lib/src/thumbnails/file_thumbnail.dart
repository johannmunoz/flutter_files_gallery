import 'package:files_gallery/src/file_icons_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';

class FileThumbnail extends StatelessWidget {
  const FileThumbnail({Key key, @required this.filename, @required this.ext})
      : super(key: key);

  final String filename;
  final String ext;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            padding: EdgeInsets.all(30.0),
            color: Colors.grey[300],
            child: SvgPicture.asset(
              relative(FileIcons.getFileIcon(ext)),
              package: 'files_gallery',
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                filename,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
