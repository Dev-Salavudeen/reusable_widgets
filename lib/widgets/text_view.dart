import 'package:flutter/widgets.dart';

class TextView extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;

  const TextView({Key? key, required this.text, this.style, this.align})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: align,
    );
  }
}
