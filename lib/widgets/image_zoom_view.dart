import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
//import 'package:core_library/models/image.dart';

import '../models/models.dart';

class ImageZoomView extends StatefulWidget {
  const ImageZoomView(
      {Key? key, required this.image, this.onSave, this.onShare})
      : super(key: key);
  final IImage image;
  final VoidCallback? onSave;
  final VoidCallback? onShare;

  @override
  State<ImageZoomView> createState() => _ImageZoomViewState();
}

class _ImageZoomViewState extends State<ImageZoomView> {
  bool showOptions = false;

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTapUp: _onTap,
          child: Stack(
            children: [
              Positioned(
                child: PhotoView(
                  onTapUp: (_, __, ___) => _onTap(__),
                  imageProvider: NetworkImage(widget.image.src),
                  errorBuilder: (context, error, stackTrace) {
                    return SizedBox(
                      width: 100,
                      height: 100,
                      child: Text(widget.image.alt ?? 'Image'),
                    );
                  },
                ),
              ),
              if (showOptions)
                Positioned(
                  child: SizedBox(
                    height: kToolbarHeight,
                    child: AppBar(
                      foregroundColor: colors.surface,
                      backgroundColor: colors.onSurface.withOpacity(.2),
                    ),
                  ),
                ),
              if (showOptions)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: IconTheme(
                    data: IconThemeData(color: colors.surface),
                    child: ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (widget.onShare != null)
                          IconButton(
                            onPressed: widget.onShare,
                            icon: const Icon(Icons.download),
                          ),
                        if (widget.onSave != null)
                          IconButton(
                            onPressed: widget.onSave!,
                            icon: const Icon(Icons.share_outlined),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(TapUpDetails details) {
    setState(() {
      showOptions = !showOptions;
    });
  }
}
