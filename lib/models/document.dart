part of app.models;

class IDocument {
  final String? id;
  final String kind;
  final String src;
  final String? alt;
  final String title;
  final IParagraph? description;

  const IDocument({
    this.id,
    required this.kind,
    required this.src,
    this.alt,
    required this.title,
    this.description,
  });

  IDocument.fromJson(Map<String, dynamic> json)
      : this(
          id: json.hasProp('id') ? json['id'] as String : null,
          kind: json.hasProp('kind') ? json['kind'] as String : 'unknown',
          src: json.hasProp('src') ? json['src'] as String : '',
          alt: json.hasProp('alt') ? json['alt'] as String : null,
          title: json.hasProp('title') ? json['title'] as String : '',
          description: json.hasProp('description')
              ? IParagraph.fromJson(json)
              : const IParagraph.empty(),
        );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'kind': kind,
        'src': src,
        if (alt != null) 'alt': alt,
        if (title != null) 'title': title,
        if (description != null) 'description': description?.toJson(),
      };
}
