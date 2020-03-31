import 'package:flutter/material.dart';

class PlaceholderContainer extends StatelessWidget {
  final Widget child;

  const PlaceholderContainer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Stack(children: [
        Positioned.fill(
          child: Container(
            child: Icon(
              Icons.image,
              color: Colors.white,
            ),
          ),
        ),
        Positioned.fill(
          child: child,
        ),
      ]),
    );
  }
}
