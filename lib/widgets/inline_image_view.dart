import 'package:core_library/shared/file_utils.dart';
import 'package:flutter/material.dart';

class InlineImageView extends StatelessWidget {
  final String src;

  const InlineImageView({Key? key, required this.src}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: getImageProviderFromDataUrl(src, 1.0),
    );
  }
}
