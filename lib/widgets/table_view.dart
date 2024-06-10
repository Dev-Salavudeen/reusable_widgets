import 'package:core_lib/core_library.dart';
import 'package:core_lib/shared/extensions.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class TableView extends StatelessWidget {
  final ITable table;
  final TableColumnWidth defaultColumnWidth;
  final TableBorder? border;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final Decoration? rowDecoration;
  final TextStyle? headerTextStyle;
  final TextStyle? cellTextStyle;
  final EdgeInsetsGeometry? cellPadding;
  final TableCellVerticalAlignment? verticalAlignment;
  final TableCellVerticalAlignment defaultVerticalAlignment;
  final Color? foregroundColor;
  const TableView({
    Key? key,
    required this.table,
    this.defaultColumnWidth = const FlexColumnWidth(),
    this.border,
    this.rowDecoration,
    this.textDirection,
    this.headerTextStyle,
    this.cellTextStyle,
    this.textBaseline,
    this.verticalAlignment,
    this.defaultVerticalAlignment = TableCellVerticalAlignment.top,
    this.cellPadding,
    this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = context.textTheme;

    var headerTextStyle = this.headerTextStyle ??
        textTheme.titleMedium?.copyWith(
          color: foregroundColor,
        );
    var cellTextStyle = this.cellTextStyle ??
        textTheme.bodyMedium?.copyWith(
          color: foregroundColor,
        );

    return Table(
      defaultColumnWidth: defaultColumnWidth,
      border: border,
      textDirection: textDirection,
      textBaseline: textBaseline,
      defaultVerticalAlignment: defaultVerticalAlignment,
      children: [
        // Header Rows
        for (var header in table.headers)
          TableRow(
            decoration: rowDecoration,
            children: [
              for (var cell in header.cells)
                TableCell(
                  verticalAlignment: verticalAlignment,
                  child: Padding(
                    padding: cellPadding ?? EdgeInsets.zero,
                    child: ContentInlineView(
                      contents: cell.name,
                      style: headerTextStyle,
                    ),
                  ),
                ),
            ],
          ),

        // Body Rows
        for (var body in table.rows)
          TableRow(
            decoration: rowDecoration,
            children: [
              for (var cell in body.cells)
                TableCell(
                  verticalAlignment: verticalAlignment,
                  child: Padding(
                    padding: cellPadding ?? EdgeInsets.zero,
                    child: Builder(
                      builder: (BuildContext context) {
                        if (cell.value != null) {
                          return ContentInlineView(
                            contents: cell.value!,
                            style: cellTextStyle,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
