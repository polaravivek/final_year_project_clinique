import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 200,
      color: Colors.white,
      child: SafeArea(
        child: Text(
          'homepage',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }
}
