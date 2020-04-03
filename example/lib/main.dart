import 'package:flutter/material.dart';

import 'package:files_gallery/files_gallery.dart';

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
      id: 'https://firebasestorage.googleapis.com/v0/b/comm-unstable-fmlink/o/buildings%2F7Vs4BC4sfPFtbJPUyGCY%2Finspection_events%2Fz7FUNSOWFVuSd3w6SIjZ%2F2020-04-01T13%3A29%3A56.100303.pdf?alt=media&token=99c7204c-9deb-4d49-8338-10624639ff86',
      imageurl: 'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
      fileicon: '/assets/fileicons/image.svg',
      value: ValueItem(name: 'test-pdf.pdf'),
    ),
    FileItem(
      id: 'https://firebasestorage.googleapis.com/v0/b/comm-unstable-fmlink/o/buildings%2F7Vs4BC4sfPFtbJPUyGCY%2Finspection_events%2Fz7FUNSOWFVuSd3w6SIjZ%2F2020-04-01T13%3A30%3A01.767335.jpeg?alt=media&token=8c44b525-28e9-4e6e-a0f2-580296e3c8d7',
      imageurl: 'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
      fileicon: 'assets/fileicons/pdf.svg',
      value: ValueItem(name: 'test-image-3.pdf'),
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
