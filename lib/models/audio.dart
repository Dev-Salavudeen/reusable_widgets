part of app.models;

class IAudio extends IDocument {
  String? credits;

  IAudio(
      {super.id,
      super.description = const IParagraph.empty(),
      required super.title,
      required super.alt,
      required super.kind,
      required super.src,
      this.credits});

  IAudio.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    credits = json.hasProp('credits') ? json['credits'] : null;
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        if (credits != null) 'credits': credits,
      };
}
