import 'package:core_library/core_library.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:video_player/video_player.dart';

part 'models.dart';
part 'controller.dart';

class _CorePlayerScope extends InheritedWidget {
  final VizionController data;
  const _CorePlayerScope({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static VizionController of(BuildContext context) {
    final _CorePlayerScope? result =
        context.dependOnInheritedWidgetOfExactType<_CorePlayerScope>();
    assert(result != null, 'No VizionController found in context');
    return result!.data;
  }

  @override
  bool updateShouldNotify(_CorePlayerScope old) => old.data != data;
}

class VizionPlayer extends StatefulWidget {
  final VizionController controller;

  const VizionPlayer(this.controller, {Key? key}) : super(key: key);

  @override
  State<VizionPlayer> createState() => _VizionPlayerState();
}

class _VizionPlayerState extends State<VizionPlayer> {
  @override
  void initState() {
    super.initState();
    widget.controller.initialize();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CorePlayerScope(
      data: widget.controller,
      child: AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: VideoPlayer(widget.controller._playerController!),
      ),
    );
  }
}
