import 'package:flutter/material.dart';

class SelectableContainer extends StatefulWidget {
  final Widget child;
  final double borderSize;
  final VoidCallback onTap;
  const SelectableContainer({
    Key key,
    this.child,
    this.borderSize,
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
    return GestureDetector(
      onTap: () {
        setState(() => isSelected = !isSelected);
        widget.onTap();
      },
      child: Container(
        height: widget.borderSize,
        width: widget.borderSize,
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
                height: isSelected ? widget.borderSize - 10 : widget.borderSize,
                width: isSelected ? widget.borderSize - 10 : widget.borderSize,
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
  }
}
