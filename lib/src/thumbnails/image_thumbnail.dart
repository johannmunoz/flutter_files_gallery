import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageThumbnail extends StatelessWidget {
  ImageThumbnail.file(File file, {Key key, this.borderSize})
      : image = FileImage(file),
        super(key: key);

  ImageThumbnail.network(String src, {Key key, this.borderSize})
      : image = NetworkImage(src),
        super(key: key);

  const ImageThumbnail({
    this.image,
    this.borderSize,
    Key key,
  }) : super(key: key);

  final ImageProvider image;
  final double borderSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FadeInImage(
        placeholder: Image.memory(kTransparentImage).image,
        image: image,
        height: borderSize,
        width: borderSize,
        fit: BoxFit.cover,
      ),
    );
  }
}
