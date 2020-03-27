library files_gallery;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Gallery extends StatelessWidget {
  final List<ImageProvider> images;
  final VoidCallback onDeleteImage;

  Gallery.file(List<File> files, {Key key, this.onDeleteImage})
      : images = files.map((file) => FileImage(file)).toList(),
        super(key: key);

  Gallery.network(List<String> urls, {Key key, this.onDeleteImage})
      : images = urls.map((url) => NetworkImage(url)).toList(),
        super(key: key);

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
                children: images
                    .map(
                      (image) => Container(
                        child: FadeInImage(
                          placeholder: Image.memory(kTransparentImage).image,
                          image: image,
                          height: borderSize,
                          width: borderSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
