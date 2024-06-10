import 'package:flutter/material.dart';

import '../shared/file_utils.dart';

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
