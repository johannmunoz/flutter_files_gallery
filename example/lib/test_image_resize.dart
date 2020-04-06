import 'package:files_gallery/files_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class TestImageResize extends StatefulWidget {
  @override
  _TestImageResizeState createState() => _TestImageResizeState();
}

class _TestImageResizeState extends State<TestImageResize> {
  final urls = [
    'https://firebasestorage.googleapis.com/v0/b/comm-unstable-fmlink/o/buildings%2F7Vs4BC4sfPFtbJPUyGCY%2Finspection_events%2FBDChzI4lP4t3zv4ek4Fx%2F2020-03-18T17%3A08%3A12.737192.jpg?alt=media&token=3a85f41a-1a30-415d-8799-f1702ce8c8cf',
  ];

  bool showGallery = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => DefaultCacheManager().emptyCache(),
        label: Text('CLEAR'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () => setState(() => showGallery = !showGallery),
                child: Text('Show/Hide'),
              ),
            ],
          ),
          if (showGallery)
            ShowGallery(
              // urls: [
              //   GalleryUrl(
              //     filename: 'image.jpg',
              //     url: url,
              //   ),
              // ],
              urls: urls
                  .map(
                    (url) => GalleryUrl(
                      filename: 'image.jpg',
                      url: url,
                    ),
                  )
                  .toList(),
            ),

          // ResizeImage(imageProvider),
        ],
      ),
    );
  }
}
