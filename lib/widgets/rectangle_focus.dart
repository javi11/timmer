import 'package:flutter/material.dart';

class FocusRectangle extends StatelessWidget {
  final Color color;

  const FocusRectangle({Key key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipPath(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: color,
        ),
        clipper: _RectangleModePhoto(),
      ),
    );
  }
}

class _RectangleModePhoto extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    var reactPath = Path();

    reactPath.moveTo(30, 30);
    reactPath.lineTo(30, size.height - 80);
    reactPath.lineTo(size.width - 30, size.height - 80);
    reactPath.lineTo(size.width - 30, 30);

    path.addPath(reactPath, Offset(0, 0));
    path.addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    path.fillType = PathFillType.evenOdd;

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
