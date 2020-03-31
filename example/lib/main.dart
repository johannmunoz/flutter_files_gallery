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
      id: 'https://homepages.cae.wisc.edu/~ece533/images/arctichare.png',
      imageurl: 'https://homepages.cae.wisc.edu/~ece533/images/arctichare.png',
      fileicon: '/assets/fileicons/image.svg',
      value: ValueItem(name: 'test-image.png'),
    ),
    FileItem(
      id: 'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
      imageurl: 'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
      fileicon: '/assets/fileicons/image.svg',
      value: ValueItem(name: 'test-image-2.png'),
    ),
    FileItem(
      id: 'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
      imageurl: 'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
      fileicon: 'assets/fileicons/pdf.svg',
      value: ValueItem(name: 'test-image-3.pdf'),
    ),
    FileItem(
      // id: '',
      // imageurl: 'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
      // fileicon: 'assets/fileicons/doc.svg',
      // value: ValueItem(),
    ),

    // 'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
    // 'https://homepages.cae.wisc.edu/~ece533/images/peppers.png',
    // 'https://homepages.cae.wisc.edu/~ece533/images/goldhill.png',
    // 'https://homepages.cae.wisc.edu/~ece533/images/mountain.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Gallery'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Gallery(
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
        ],
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
