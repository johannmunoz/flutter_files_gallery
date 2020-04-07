import 'package:flutter/material.dart';

class PlaceholderContainer extends StatelessWidget {
  final Widget child;
  final Widget placeholder;

  const PlaceholderContainer({Key key, this.child, this.placeholder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Stack(
        children: [
          if (placeholder != null)
            Align(
              alignment: Alignment.center,
              child: placeholder,
            )
          else
            Positioned.fill(
              child: Container(
                child: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
              ),
            ),
          if (child != null)
            Positioned.fill(
              child: child,
            ),
        ],
      ),
    );
  }
}
