part of app.models;

enum VideoType { mp4, mov, wmv, avi, mpeg, mkv, youtube }

enum VideoRatio { full, wide }

class IVideo extends IDocument {
  /// Resolution 1280x720 (minimum width 640 pixels) must be in JPG, GIF, or PNG image formats.
  List<IImage> thumbnails = [];

  String? credits;

  IVideo({
    super.id,
    super.description,
    required super.title,
    super.alt,
    required super.src,
    this.thumbnails = const [IImage.noImage()],
    required super.kind,
    this.credits,
  });

  IVideo.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    thumbnails = json.hasProp('thumbnails')
        ? (json['thumbnails'] as List).map((e) => IImage.fromJson(e)).toList()
        : [];
    credits = json.hasProp('credits') ? json['credits'] : null;
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        if (credits != null) 'credits': credits,
        'thumbnails': thumbnails.map((e) => e.toJson()).toList(),
      };
}

class VideoTypeCheck {
  static bool isYoutube(String? value) =>
      value?.toLowerCase() == VideoType.youtube.name.toLowerCase();
}
