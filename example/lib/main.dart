import 'package:files_gallery/files_gallery.dart';
import 'package:flutter/material.dart';

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
  final List<String> urls = [
    'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
    'https://homepages.cae.wisc.edu/~ece533/images/arctichare.png',
    'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
    'https://homepages.cae.wisc.edu/~ece533/images/peppers.png',
    'https://homepages.cae.wisc.edu/~ece533/images/goldhill.png',
    'https://homepages.cae.wisc.edu/~ece533/images/mountain.png',
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
            color: Colors.blue,
            child: Gallery.network(
              urls,
              onDeleteFile: (index) {
                setState(() => urls.removeAt(index));
              },
            ),
          ),
        ],
      ),
    );
  }
}
