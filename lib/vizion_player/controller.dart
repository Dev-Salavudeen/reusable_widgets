part of 'vizion_player.dart';

final yt = YoutubeExplode();

class PlayerValue {
  final IVideo video;
  final VideoRatio ratio;
  final List<VideoQualityUrl> qualityUrls;
  VideoQualityUrl _source;

  PlayerValue(
    this.video,
    this.qualityUrls,
    this._source, {
    this.ratio = VideoRatio.full,
  });
}

class VizionController extends ValueNotifier<PlayerValue> {
  VizionController._(super.value);

  VideoQualityUrl get source => value._source;

  List<VideoQualityUrl> get qualities => value.qualityUrls;

  VideoPlayerController? _playerController;

  static Future<VizionController> fromVideo(IVideo video,
      {VideoRatio ratio = VideoRatio.full}) async {
    List<VideoQualityUrl> urls = await _getVideoUrlsFromVideo(video);
    var value = PlayerValue(video, urls, urls.first, ratio: ratio);
    return VizionController._(value);
  }

  Future<void> changeQuality(VideoQualityUrl source) async {
    _checkIfInitialized();
    await initialize(source);
    value = value.._source = source;
  }

  Future<void> initialize([VideoQualityUrl? source]) async {
    _playerController =
        VideoPlayerController.network(source?.url ?? this.source.url);
    await _playerController!.initialize();
  }

  Future<void> setLooping(bool looping) async {
    _checkIfInitialized();
    await _playerController!.setLooping(looping);
  }

  Future<void> play() async {
    _checkIfInitialized();
    await _playerController!.play();
  }

  Future<void> pause() async {
    _checkIfInitialized();
    await _playerController!.pause();
  }

  Future<void> setVolume(double volume) async {
    _checkIfInitialized();
    await _playerController!.setVolume(volume);
  }

  Future<void> seekTo(Duration position) async {
    _checkIfInitialized();
    await _playerController!.seekTo(position);
  }

  void _checkIfInitialized() {
    if (_playerController == null || !_playerController!.value.isInitialized) {
      throw StateError('not Initialized');
    }
  }

  @override
  void dispose() {
    _playerController?.dispose();
    super.dispose();
  }
}

Future<List<VideoQualityUrl>> _getVideoUrlsFromVideo(IVideo video) async {
  switch (video.kind) {
    case "youtube":
      return await getYoutubeQualityUrls(video.src);
    default:
      return [VideoQualityUrl(quality: defaultQuality, url: video.src)];
  }
}

Future<List<VideoQualityUrl>> getYoutubeQualityUrls(String videoId,
    [bool live = false]) async {
  var manifest = await yt.videos.streamsClient.getManifest(videoId);
  return manifest.video.map(videoStreamInfo2VideoQualityUrl).toList();
}

VideoQualityUrl videoStreamInfo2VideoQualityUrl(VideoStreamInfo element) {
  return VideoQualityUrl(
    quality: int.parse(element.qualityLabel.split('p')[0]),
    url: element.url.toString(),
  );
}
