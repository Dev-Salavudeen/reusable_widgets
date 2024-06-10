part of app.models;

class IMathml {
  String? id;
  String text;
  String? fallBackImage;
  String? alt;

  IMathml({this.id, required this.text, this.fallBackImage, this.alt});

  IMathml.fromJson(Map json)
      : this(
          id: json.hasProp('id') ? json['id'] as String : null,
          text: json.hasProp('text') ? json['text'] as String : '',
          fallBackImage: json.hasProp('fallBackImage')
              ? json['fallBackImage'] as String
              : null,
          alt: json.hasProp('alt') ? json['alt'] as String : null,
        );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'text': text,
        if (fallBackImage != null) 'fallBackImage': fallBackImage,
        if (alt != null) 'alt': alt,
      };
}
