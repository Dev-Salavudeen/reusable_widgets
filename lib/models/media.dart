part of app.models;

typedef IMedia = List<IMediaItem>;

enum IMediaType { image, audio, video, document, unknown }

class IMediaItem {
  IMediaType type;
  Object? media;

  IMediaItem({required this.type, this.media});
  bool get isImage => type == IMediaType.image;
  bool get isAudio => type == IMediaType.audio;
  bool get isVideo => type == IMediaType.video;
  bool get isDocument => type == IMediaType.document;
  bool get isUnknown => type == IMediaType.unknown;

  IMediaItem.fromJson(Map<String, dynamic> json)
      : this(
          type: _parseContentType(json['type']),
          media: json.hasProp('media') ? _decodeMedia(json) : null,
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'type': type.index,
    };
    return json;
  }

  IMediaItem.empty() : this(type: IMediaType.unknown);

  static IMediaType _parseContentType(value) {
    if (value is int && value < IMediaType.values.length) {
      return IMediaType.values.elementAt(value);
    } else {
      var index = IMediaType.values.indexWhere((element) =>
          element.name.toLowerCase() == value.toString().toLowerCase());
      if (index.isNegative) return IMediaType.unknown;
      return IMediaType.values.elementAt(index);
    }
  }

  static _decodeMedia(json) {
    if (json['media'] == null) {
      return null;
    } else if (json['type'] == IMediaType.image.name) {
      return json['media'];
    } else if (json['type'] == IMediaType.audio.name) {
      return json['media'];
    } else if (json['type'] == IMediaType.video.name) {
      return json['media'];
    } else if (json['type'] == IMediaType.document.name) {
      return json['media'];
    } else {
      return null;
    }
  }
}
