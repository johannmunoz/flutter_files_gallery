import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageThumbnail extends StatelessWidget {
  ImageThumbnail.file(File file, {Key key})
      : image = Image.file(file),
        super(key: key);

  ImageThumbnail.network(String src, {Key key})
      : image = Image.network(src),
        super(key: key);

  const ImageThumbnail({
    this.image,
    Key key,
  }) : super(key: key);

  final Image image;

  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return Container(
          child: FadeInImage(
            placeholder: Image.memory(kTransparentImage).image,
            image: image.image,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
