import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class FullscreenImageViewer extends StatelessWidget {

  FullscreenImageViewer({required this.imageURL});

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: Colors.grey[900],
        ),
        backgroundColor: Colors.grey[50],
        toolbarHeight: 40,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        // onVerticalDragDown: (drag) {
        //   Navigator.of(context).pop();
        // },
        child: Center(
          // ignore: sized_box_for_whitespace
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.375,
            width: MediaQuery.of(context).size.width,
            child: PinchZoom(
              image: Hero(
                tag: imageURL,
                child: CachedNetworkImage(
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  placeholderFadeInDuration: Duration.zero,
                  imageUrl: imageURL,
                  fit: BoxFit.fitWidth,
                  width: 175,
                  placeholder: (context, url) => const Image(image: const AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                ),
              ),
              zoomedBackgroundColor: Colors.black.withOpacity(0.0),
              resetDuration: const Duration(milliseconds: 25),
              maxScale: 10,
            ),
            // child: Image(
            //   image: data['imageURL'].isEmpty ? AssetImage('assets/icon/icon.png') : NetworkImage(data['imageURL']),//AssetImage(data['imageURL']),
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
      ),
    );
  }
}
