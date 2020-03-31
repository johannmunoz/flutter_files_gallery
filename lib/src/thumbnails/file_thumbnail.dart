import 'package:files_gallery/src/file_icons_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';

class FileThumbnail extends StatelessWidget {
  const FileThumbnail({
    Key key,
    @required this.filename,
    @required this.ext,
    @required this.borderSize,
  }) : super(key: key);

  final String filename;
  final String ext;
  final double borderSize;

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
              width: borderSize / 5,
              height: borderSize / 5,
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
