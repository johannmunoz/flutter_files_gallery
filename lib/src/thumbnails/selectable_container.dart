import 'package:flutter/material.dart';

class SelectableContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const SelectableContainer({
    Key key,
    this.child,
    this.onTap,
  }) : super(key: key);
  @override
  _SelectableContainerState createState() => _SelectableContainerState();
}

class _SelectableContainerState extends State<SelectableContainer> {
  bool isSelected = true;
  @override
  Widget build(BuildContext context) {
    return _imageContainer();
  }

  Widget _imageContainer() {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        final sideWidth = boxConstraints.maxWidth;
        return GestureDetector(
          onTap: () {
            setState(() => isSelected = !isSelected);
            widget.onTap();
          },
          child: Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    child: Icon(
                      Icons.image,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    height: isSelected ? sideWidth - 10 : sideWidth,
                    width: isSelected ? sideWidth - 10 : sideWidth,
                    child: widget.child,
                  ),
                ),
                if (isSelected)
                  Align(
                    alignment: Alignment.topLeft,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Colors.white : Colors.transparent,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
