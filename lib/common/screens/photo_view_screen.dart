import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatelessWidget {
  final String src;

  const PhotoViewScreen({Key key, this.src});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: PhotoView(
        imageProvider: NetworkImage(src),
      ),
    ));
  }
}
