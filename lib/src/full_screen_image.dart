import 'dart:io';

import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final ImageProvider image;
  final VoidCallback onDeleteImage;

  FullScreenImage.file(File file, {Key key, this.onDeleteImage})
      : image = FileImage(file),
        super(key: key);

  FullScreenImage.network(String src, {Key key, this.onDeleteImage})
      : image = NetworkImage(src),
        super(key: key);

  const FullScreenImage(this.image, {Key key, this.onDeleteImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image(
                image: image,
              ),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                color: Colors.black26,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildBackButton(context),
                    _buildDeleteButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconButton _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  IconButton _buildDeleteButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: Colors.white,
      ),
      onPressed: () async {
        var result = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                    'Are you sure you want to delete this file from the inspection?'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('CANCEL'),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('DELETE'),
                  ),
                ],
              ),
            ) ??
            false;

        if (result) {
          onDeleteImage();
          Navigator.pop(context);
        }
      },
    );
  }
}
