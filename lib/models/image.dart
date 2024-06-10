part of app.models;

enum ImageType { png, jpeg, jpg, svg, webp, unknown }

class IImage extends IDocument {
  final double? height;
  final double? width;
  final String? credits;

  const IImage({
    super.id,
    super.alt,
    super.title = '',
    required super.src,
    required super.kind,
    this.height,
    this.width,
    this.credits,
    super.description,
  });

  IImage.fromJson(Map<String, dynamic> json)
      : this(
          id: json.hasProp('id') ? json['id'] as String : null,
          kind: json.hasProp('kind') ? json['kind'] as String : 'unknown',
          src: json.hasProp('src') ? json['src'] as String : '',
          alt: json.hasProp('alt') ? json['alt'] as String : null,
          title: json.hasProp('title') ? json['title'] as String : '',
          description: json.hasProp('description')
              ? IParagraph.fromJson(json)
              : const IParagraph.empty(),
          height: json.hasProp('height')
              ? (json['height'] as int).toDouble()
              : null,
          width:
              json.hasProp('width') ? (json['width'] as int).toDouble() : null,
          credits: json.hasProp('credits') ? json['credits'] as String : null,
        );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        if (height != null) 'height': height,
        if (width != null) 'width': width,
        if (credits != null) 'credits': credits,
      };

  bool get isEmpty => kind == "none" || src.isEmpty;

  const IImage.noImage() : this(title: "Unknown", kind: "none", src: "");

  factory IImage.fromUrl(String src) {
    return IImage(src: src, kind: getImageKind(src));
  }
}
