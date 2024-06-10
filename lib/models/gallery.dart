part of app.models;

class IGallery {
  String? id;
  IContentItem? title;
  String? credits;
  List gallery;
  List<IImage> thumbnail;

  IGallery({
    this.id,
    this.title,
    this.credits,
    required this.gallery,
    required this.thumbnail,
  });

  IGallery.fromJson(Map<String, dynamic> json)
      : this(
          id: json.hasProp('id') ? json['id'] as String : null,
          title:
              json.hasProp('title') ? IContentItem.fromJson(json['title']) : null,
          credits: json.hasProp('credits') ? json['credits'] as String : null,
          gallery:
              json.hasProp('gallery') ? (json['gallery'] as List).toList() : [],
          thumbnail: json.hasProp('thumbnail')
              ? (json['thumbnail'] as List)
                  .map((e) => IImage.fromJson(e))
                  .toList()
              : [],
        );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'title': title?.toJson(),
        if (credits != null) 'credits': credits,
        'gallery': gallery.toList(),
        'thumbnail': thumbnail.toList()
      };
}
