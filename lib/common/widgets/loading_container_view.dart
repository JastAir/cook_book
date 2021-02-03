import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoadingContainerView extends StatelessWidget {
  const LoadingContainerView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Colors.orange[400],
          ),
        ],
      ),
    );
  }
}
