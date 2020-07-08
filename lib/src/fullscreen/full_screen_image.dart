import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatefulWidget {
  final ImageProvider image;
  final VoidCallback onDeleteImage;
  final OnRenameImage onRenameImage;
  final bool readonly;
  final String filename;

  FullScreenImage.file(
    File file, {
    @required this.onDeleteImage,
    @required this.filename,
    this.readonly = false,
    this.onRenameImage,
    Key key,
  })  : image = FileImage(file),
        super(key: key);

  FullScreenImage.network(
    String src, {
    @required this.onDeleteImage,
    @required this.filename,
    this.readonly = false,
    this.onRenameImage,
    Key key,
  })  : image = NetworkImage(src),
        super(key: key);

  const FullScreenImage(
    this.image, {
    @required this.onDeleteImage,
    @required this.filename,
    this.readonly = false,
    this.onRenameImage,
    Key key,
  }) : super(key: key);

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  String filename = '';
  @override
  void initState() {
    filename = widget.filename;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image(
                image: widget.image,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white10,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                width: double.infinity,
                child: Text(
                  filename,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .apply(color: Colors.white54),
                ),
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
                    if (!widget.readonly)
                      Row(
                        children: <Widget>[
                          if (widget.onRenameImage != null)
                            _buildRenameButton(context),
                          _buildDeleteButton(context),
                        ],
                      ),
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
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return IconButton(
      icon: Icon(
        isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
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
                title: Text('Are you sure you want to delete this item?'),
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
          widget.onDeleteImage();
          Navigator.pop(context);
        }
      },
    );
  }

  IconButton _buildRenameButton(BuildContext context) {
    final textController = TextEditingController();
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: Colors.white,
      ),
      onPressed: () async {
        var result = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Rename file'),
                content: TextField(
                  controller: textController,
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'File name'),
                  keyboardType: TextInputType.text,
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('CANCEL'),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('RENAME'),
                  ),
                ],
              ),
            ) ??
            false;

        if (result) {
          final ext = extension(widget.filename);
          setState(() => filename = '${textController.text}$ext');
          widget.onRenameImage(filename);
        }
        textController.clear();
      },
    );
  }
}

typedef void OnRenameImage(String filename);
