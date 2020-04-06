import 'package:example/test_image_resize.dart';
import 'package:flutter/material.dart';

import 'package:files_gallery/files_gallery.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<FileItem> urls = [
    FileItem(
      id: 'https://firebasestorage.googleapis.com/v0/b/comm-unstable-fmlink/o/buildings%2F7Vs4BC4sfPFtbJPUyGCY%2Finspection_events%2FBDChzI4lP4t3zv4ek4Fx%2F2020-03-18T17%3A08%3A12.737192.jpg?alt=media&token=3a85f41a-1a30-415d-8799-f1702ce8c8cf',
      imageurl: 'https://homepages.cae.wisc.edu/~ece533/images/arctichare.png',
      fileicon: '/assets/fileicons/image.svg',
      value: ValueItem(name: 'test-image.png'),
    ),
    FileItem(
      id: 'https://firebasestorage.googleapis.com/v0/b/comm-unstable-fmlink/o/buildings%2F7Vs4BC4sfPFtbJPUyGCY%2Finspection_events%2FtYZGuhTvv6lWZJNoRTwv%2F2020-04-03T13%3A35%3A28.681523.jpg?alt=media&token=012ac266-6e1d-4467-b006-24cb36b3bf0d',
      imageurl: 'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
      fileicon: '/assets/fileicons/image.svg',
      value: ValueItem(name: 'test-image.png'),
    ),
    FileItem(
      id: 'https://firebasestorage.googleapis.com/v0/b/comm-unstable-fmlink/o/buildings%2F7Vs4BC4sfPFtbJPUyGCY%2Finspection_events%2FqKpNyOgbaA5M9HfsdnaR%2F2020-03-17T16%3A53%3A44.630165.jpg?alt=media&token=bc15a493-2256-4b43-b22a-5aa0f2f8f3a7',
      imageurl: 'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
      fileicon: 'assets/fileicons/pdf.svg',
      value: ValueItem(name: 'test-image.png'),
    ),
    FileItem(
      id: 'https://firebasestorage.googleapis.com/v0/b/comm-unstable-fmlink/o/buildings%2F7Vs4BC4sfPFtbJPUyGCY%2Finspection_events%2Fz7FUNSOWFVuSd3w6SIjZ%2F2020-04-01T13%3A30%3A07.107614.jpg?alt=media&token=0e26d5a8-693d-4a5b-9b8d-07bed56a0d35',
      imageurl: 'https://homepages.cae.wisc.edu/~ece533/images/arctichare.png',
      fileicon: '/assets/fileicons/image.svg',
      value: ValueItem(name: 'test-image.png'),
    ),
    FileItem(
      id: 'https://firebasestorage.googleapis.com/v0/b/comm-unstable-fmlink/o/buildings%2F7Vs4BC4sfPFtbJPUyGCY%2Finspection_events%2Fz7FUNSOWFVuSd3w6SIjZ%2F2020-04-01T13%3A30%3A23.482343.jpg?alt=media&token=58902d23-aa4c-49de-8a38-86e30bbc227f',
      imageurl: 'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
      fileicon: '/assets/fileicons/image.svg',
      value: ValueItem(name: 'test-image.png'),
    ),
    FileItem(
      id: 'https://firebasestorage.googleapis.com/v0/b/comm-unstable-fmlink/o/buildings%2F7Vs4BC4sfPFtbJPUyGCY%2Finspection_events%2FtYZGuhTvv6lWZJNoRTwv%2F2020-04-03T13%3A35%3A25.290154.jpg?alt=media&token=33d78fed-c132-42c7-93b7-92cd0cfdade2',
      imageurl: 'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
      fileicon: 'assets/fileicons/pdf.svg',
      value: ValueItem(name: 'test-image.png'),
    ),
    FileItem(),

    // 'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
    // 'https://homepages.cae.wisc.edu/~ece533/images/peppers.png',
    // 'https://homepages.cae.wisc.edu/~ece533/images/goldhill.png',
    // 'https://homepages.cae.wisc.edu/~ece533/images/mountain.png',
  ];
  List<int> selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Gallery'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          DefaultCacheManager().emptyCache();
        },
        label: Text('CLEAR'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Divider(
              color: Colors.orange,
              thickness: 10,
            ),
            Container(
              child: ShowGallery(
                urls: urls
                    .map(
                      (item) => GalleryUrl(
                        filename: item.value?.name,
                        url: item.id,
                      ),
                    )
                    .toList(),
                onDeleteNetworkFile: (index) =>
                    setState(() => urls.removeAt(index)),
              ),
            ),
            Divider(
              color: Colors.orange,
              thickness: 10,
            ),
            // Container(
            //   child: Gallery(
            //     readonly: true,
            //     urls: urls
            //         .map(
            //           (item) => GalleryUrl(
            //             filename: item.value?.name,
            //             url: item.id,
            //           ),
            //         )
            //         .toList(),
            //     onDeleteNetworkFile: (index) =>
            //         setState(() => urls.removeAt(index)),
            //   ),
            // ),
            Container(
              child: SelectableGallery(
                urls: urls
                    .map(
                      (item) => GalleryUrl(
                        filename: item.value?.name,
                        url: item.id,
                      ),
                    )
                    .toList(),
                onSelectedUrls: (indexes) {
                  setState(() => selectedFiles = indexes);
                },
              ),
            ),
            Text('Selected files: $selectedFiles')
          ],
        ),
      ),
    );
  }
}

class FileItem {
  String id;
  String fileicon;
  String imageurl;
  String bucketPath;
  ValueItem value;
  FileItem({
    this.id,
    this.fileicon,
    this.imageurl,
    this.bucketPath,
    this.value,
  });
}

class ValueItem {
  String name;
  Props props;
  ValueItem({
    this.name,
    this.props,
  });
}

class Props {
  bool completed;
  int progress;
  Props({
    this.completed,
    this.progress,
  });
}
