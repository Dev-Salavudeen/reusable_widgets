part of app.models;

class IParagraph {
  final List<IContentItem> content;

  const IParagraph({required this.content});

  IParagraph.fromJson(Map<String, dynamic> json)
      : this(
          content: json.hasProp('content')
              ? (json['content'] as List)
                  .map((e) => IContentItem.fromJson(e))
                  .toList()
              : [],
        );

  const IParagraph.empty() : this(content: const []);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content.map((v) => v.toJson()).toList();
    return data;
  }
}
