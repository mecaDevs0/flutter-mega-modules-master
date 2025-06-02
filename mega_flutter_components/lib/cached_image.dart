import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String image;
  final double? height;
  final BoxFit fit;

  const CachedImage(
    this.image, {
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty || !Uri.parse(image).isAbsolute) {
      return Container();
    }

    return CachedNetworkImage(
      height: height,
      imageUrl: image,
      fit: fit,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return Center(
          child: CircularProgressIndicator(value: downloadProgress.progress),
        );
      },
      errorWidget: (context, url, error) => const Icon(
        Icons.image_not_supported,
      ),
    );
  }
}
