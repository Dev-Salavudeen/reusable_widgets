import 'package:core_lib/widgets/table_view.dart';
import 'package:flutter/widgets.dart';

import '../models/models.dart';
import 'inline_image_view.dart';
import 'mathml_view.dart';

// class ContentView extends StatelessWidget {
//   final IContentItem data;
//   final TextStyle? style;
//   final TextAlign? align;
//
//   const ContentView({Key? key, required this.data, this.style, this.align})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if (data.isText && data.value != null) {
//       return TextView(text: data.value!.toString(), style: style, align: align);
//     } else if (data.isInlineImage && data.value != null) {
//       return InlineImageView(src: data.value!.toString());
//     } else if (data.isMathml && data.value != null) {
//       return MathMLView(data.value! as IMathml);
//     } else {
//       return const SizedBox.shrink();
//     }
//   }
// }

class ContentInlineView extends StatelessWidget {
  final List<IContentItem> contents;
  final TextStyle? style;
  final TextAlign? align;

  const ContentInlineView(
      {Key? key, required this.contents, this.style, this.align})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var defaultStyle = DefaultTextStyle.of(context);
    return RichText(
      maxLines: defaultStyle.maxLines,
      overflow: defaultStyle.overflow,
      softWrap: defaultStyle.softWrap,
      textWidthBasis: defaultStyle.textWidthBasis,
      text: TextSpan(
        children: [
          for (var data in contents) _buildInlineSpan(defaultStyle, data),
        ],
      ),
    );
  }

  InlineSpan _buildInlineSpan(
      DefaultTextStyle defaultStyle, IContentItem data) {
    if (data.isText && data.value != null) {
      return TextSpan(text: data.value!.toString(), style: style);
    } else if (data.isInlineImage && data.value != null) {
      return WidgetSpan(child: InlineImageView(src: data.value!.toString()));
    } else if (data.isMathml && data.value != null) {
      return WidgetSpan(child: MathMLView(data.value! as IMathml));
    } else if (data.isTable && data.value != null) {
      return WidgetSpan(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: TableView(
            table: data.value! as ITable,
            cellTextStyle: style,
            headerTextStyle: style,
            foregroundColor: style?.color,
          ),
        ),
      );
    } else {
      return const TextSpan();
    }
  }
}
