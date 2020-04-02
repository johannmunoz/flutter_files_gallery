import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageThumbnail extends StatelessWidget {
  ImageThumbnail.file(File file, {Key key})
      : image = FileImage(file),
        super(key: key);

  ImageThumbnail.network(String src, {Key key})
      : image = NetworkImage(src),
        super(key: key);

  const ImageThumbnail({
    this.image,
    Key key,
  }) : super(key: key);

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return Container(
          child: FadeInImage(
            placeholder: Image.memory(kTransparentImage).image,
            image: ResizeImage(image, width: boxConstraints.maxWidth.floor()),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
