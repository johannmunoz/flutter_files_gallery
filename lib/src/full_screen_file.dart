import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FullScreenFile extends StatelessWidget {
  final VoidCallback onDeleteImage;
  final String filename;
  final String fileicon;

  const FullScreenFile({
    Key key,
    this.onDeleteImage,
    this.filename,
    this.fileicon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SvgPicture.asset(
                fileicon,
                width: MediaQuery.of(context).size.shortestSide / 3,
                fit: BoxFit.contain,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                width: double.infinity,
                child: Text(
                  filename,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title,
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
