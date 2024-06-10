import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

import '../models/models.dart';

class MathMLView extends StatelessWidget {
  final IMathml data;
  final TextStyle? style;
  final EdgeInsets? padding;
  final TextAlign? textAlign;

  const MathMLView(
    this.data, {
    Key? key,
    this.style,
    this.padding,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TeXViewTextAlign? textAligned = textAlign != null
        ? TeXViewTextAlign.values.byName(textAlign!.name)
        : null;

    TeXViewStyle effectiveStyle = TeXViewStyle(
      height: style?.height?.toInt(),
      contentColor: style?.color,
      backgroundColor: style?.backgroundColor,
      sizeUnit: TeXViewSizeUnit.pixels,
      textAlign: textAligned,
      padding: TeXViewPadding.only(
        sizeUnit: TeXViewSizeUnit.pixels,
        top: padding?.top.toInt(),
        right: padding?.right.toInt(),
        bottom: padding?.bottom.toInt(),
        left: padding?.left.toInt(),
      ),
    );

    return TeXView(
      child: TeXViewDocument(
        data.text,
        style: effectiveStyle,
      ),
    );
  }
}
