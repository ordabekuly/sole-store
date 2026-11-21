import 'package:flutter/material.dart';

class CloudProductImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  const CloudProductImage({
    super.key,
    required this.url,
    this.fit = BoxFit.contain,
  });
  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const Center(child: Icon(Icons.image_not_supported_outlined));
    }
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : const Center(child: CircularProgressIndicator()),
      errorBuilder: (_, error, stack) =>
          const Center(child: Icon(Icons.broken_image_outlined)),
    );
  }
}
