part of app.models;

typedef IContent = List<IContentItem>;

enum IContentType { text, inlineImage, mathML, table, unknown }

class IContentItem<T extends Object> {
  IContentType type;
  String? style;
  T? value;

  IContentItem({required this.type, this.style, this.value});

  bool get isText => type == IContentType.text;
  bool get isInlineImage => type == IContentType.inlineImage;
  bool get isMathml => type == IContentType.mathML;
  bool get isTable => type == IContentType.table;
  bool get isUnknown => type == IContentType.unknown;

  IContentItem.fromJson(Map<String, dynamic> json)
      : this(
          type: _parseContentType(json['type']),
          style: json.hasProp('style') ? json['style'] as String : null,
          value: json.hasProp('value') ? _decodeContent(json) : null,
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'type': type.name,
      'style': style.toString(),
      'value': value is IMathml ? (value as IMathml).toJson() : value,
    };
    return json;
  }

  IContentItem.empty() : this(type: IContentType.unknown);

  @override
  bool operator ==(Object other) {
    return other is IContentItem && other.type == type && other.value == value;
  }

  static IContentType _parseContentType(value) {
    if (value is int && value < IContentType.values.length) {
      return IContentType.values.elementAt(value);
    } else {
      var index = IContentType.values.indexWhere((element) =>
          element.name.toLowerCase() == value.toString().toLowerCase());
      if (index.isNegative) return IContentType.unknown;
      return IContentType.values.elementAt(index);
    }
  }

  static _decodeContent(json) {
    if (json['value'] == null) {
      return null;
    } else if (json['type'] == IContentType.text.name) {
      return json['value'];
    } else if (json['type'] == IContentType.inlineImage.name) {
      return json['value'];
    } else if (json['type'] == IContentType.mathML.name) {
      return IMathml.fromJson(json['value']);
    } else if (json['type'] == IContentType.table.name) {
      return ITable.fromJson(json['value']);
    } else {
      return null;
    }
  }

  @override
  // TODO: implement hashCode
  int get hashCode => type.hashCode ^ value.hashCode ^ style.hashCode;
}
