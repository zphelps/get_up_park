import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
    EmptyContent({
     this.title = 'Nothing here',
     this.message = 'Add a new item to get started',
     this.center = false,
  });
  final String title;
  final String message;
  final bool center;

  @override
  Widget build(BuildContext context) {
    if(center) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage('assets/notFound.png'),
              width: 200,
              height: 125,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 3),
            Text(
              message,
              style: TextStyle(fontSize: 13.0, color: Colors.grey.shade600, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 6),
          ],
        ),
      );
    }
    else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Image(
            image: AssetImage('assets/notFound.png'),
            width: 200,
            height: 125,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 3),
          Text(
            message,
            style: TextStyle(fontSize: 13.0, color: Colors.grey.shade600, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 6),
        ],
      );
    }

  }
}