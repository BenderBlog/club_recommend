import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  final List<ImageProvider> images;
  final int initalPage;
  const ImageView({super.key, required this.images, required this.initalPage});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('图片概览')),
      body: ExtendedImageGesturePageView.builder(
        controller: ExtendedPageController(
          initialPage: widget.initalPage,
          pageSpacing: 50,
        ),
        itemCount: widget.images.length,
        itemBuilder: (BuildContext context, int index) {
          return ExtendedImage(
            image: widget.images[index],
            fit: BoxFit.contain,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (ExtendedImageState state) {
              return GestureConfig(
                inPageView: true,
                initialScale: 1.0,
                maxScale: 5.0,
                animationMaxScale: 6.0,
                initialAlignment: InitialAlignment.center,
              );
            },
          );
        },
      ),
    );
  }
}
