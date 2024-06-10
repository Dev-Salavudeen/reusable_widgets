import 'package:cached_network_image/cached_network_image.dart';
import 'package:core_library/core_library.dart';
import 'package:core_library/shared/file_utils.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final IImage data;
  final double scale;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Map<String, String>? headers;
  final bool zoomEnabled;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  bool get hasCredits => data.credits != null && data.credits!.isNotEmpty;

  const ImageView({
    Key? key,
    IImage? data,
    this.zoomEnabled = true,
    this.scale = 1.0,
    this.headers,
    this.padding,
    this.borderRadius,
    this.height,
    this.width,
    this.fit,
  })  : data = data ?? const IImage.noImage(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: AbsorbPointer(
        absorbing: !zoomEnabled,
        child: GestureDetector(
          onTap: () => _isImageTapped(context),
          child: Builder(
            builder: (BuildContext context) {
              if (borderRadius != null) {
                return ClipRRect(
                  borderRadius: borderRadius!,
                  child: _renderImage(),
                );
              } else {
                return _renderImage();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _renderImage() {
    return Image(
      fit: BoxFit.fill,
      image: _getImageProvider(),
      errorBuilder: _errorBuilder,
    );
  }

  void _isImageTapped(BuildContext context) {
    if (zoomEnabled) context.goto(() => ImageZoomView(image: data));
  }

  Widget _errorBuilder(BuildContext context, Object error, StackTrace? stack) {
    return Container(
      color: context.theme.splashColor,
    );
  }

  ImageProvider _getImageProvider() {
    if (isDataUri(data.src)) {
      return getImageProviderFromDataUrl(data.src, scale);
    } else {
      return CachedNetworkImageProvider(
        data.src,
        scale: scale,
        headers: headers,
      );
    }
  }
}
