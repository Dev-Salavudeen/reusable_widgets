part of 'models.dart';

class ITableCell {
  final List<IContentItem>? value;

  ITableCell({this.value});

  ITableCell.fromJson(JSON json)
      : this(
          value: json.hasProp('value')
              ? (json['value'] as List)
                  .map((e) => IContentItem.fromJson(e))
                  .toList()
              : [],
        );

  JSON toJson() => {"value": value?.map((e) => e.toJson()).toList()};
}

class ITableHeadCell {
  final List<IContentItem> name;

  ITableHeadCell({required this.name});

  ITableHeadCell.fromJson(JSON json)
      : this(
          name: json.hasProp('name')
              ? (json['name'] as List)
                  .map((e) => IContentItem.fromJson(e))
                  .toList()
              : [],
        );

  JSON toJson() => {
        "name": name.map((e) => e.toJson()).toList(),
      };
}

class ITableHeader {
  final List<ITableHeadCell> cells;

  ITableHeader({required this.cells});

  ITableHeader.fromJson(JSON json)
      : this(
          cells: (json['cells'] ?? [])
              .map((e) => ITableHeadCell.fromJson(e))
              .toList(),
        );

  JSON toJson() => {"cells": cells.map((e) => e.toJson()).toList()};
}

class ITableRow {
  final List<ITableCell> cells;

  ITableRow({required this.cells});

  ITableRow.fromJson(JSON json)
      : this(
          cells:
              (json['cells'] ?? []).map((e) => ITableCell.fromJson(e)).toList(),
        );

  JSON toJson() => {"cells": cells.map((e) => e.toJson()).toList()};
}

class ITable {
  final List<ITableHeader> headers;
  final List<ITableRow> rows;

  ITable({required this.headers, required this.rows});

  ITable.fromJson(JSON json)
      : this(
          headers: json.hasProp('headers')
              ? (json['headers'] as List)
                  .map((e) => ITableHeader.fromJson(e))
                  .toList()
              : [],
          rows: json.hasProp('rows')
              ? (json['rows'] as List)
                  .map((e) => ITableRow.fromJson(e))
                  .toList()
              : [],
        );

  JSON toJson() => {
        "headers": headers.map((e) => e.toJson()).toList(),
        "rows": rows.map((e) => e.toJson()).toList(),
      };
}
