import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/models.dart';

enum Type { hls, mp4, youtube, flv }

class VideoView extends StatefulWidget {
  const VideoView({Key? key, required this.data}) : super(key: key);

  final IVideo data;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    loadVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        print('snapshot is ${snapshot.connectionState.name}');
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return Column(
            children: [
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(controller),
              ),
              Text(
                  "${controller.value.position.toString()}/ ${controller.value.duration.toString()}"),
              VideoProgressIndicator(controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    backgroundColor: Colors.redAccent,
                    playedColor: Colors.green,
                    bufferedColor: Colors.purple,
                  )),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }

                        setState(() {});
                      },
                      icon: Icon(controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow)),
                  IconButton(
                      onPressed: () {
                        controller.seekTo(Duration(seconds: 0));
                        setState(() {});
                      },
                      icon: Icon(Icons.stop))
                ],
              ),
              if (widget.data.credits != null)
                Text('Credits : ${widget.data.credits}')
            ],
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  loadVideoPlayer() async {
    print(
        'srs is ${widget.data.src}--${widget.data.kind}--${widget.data.kind == Type.mp4.name}--${widget.data.kind == Type.flv.name}');
    if (widget.data.kind == Type.mp4.name)
      controller = VideoPlayerController.network(widget.data.src);
    if (widget.data.kind == Type.flv.name) {
      print('inside flv');
      controller = VideoPlayerController.asset(
        package: 'lib_file',
        widget.data.src,
      );
    }
    print('controller got is ${controller.value.isInitialized}');
    controller.addListener(() {
      if (controller.value.hasError)
        print('controller error is ${controller.value.errorDescription}');
      if (controller.value.isInitialized)
        print('controller init is ${controller.value.duration}');
      if (controller.value.isBuffering)
        print('controller buffer is ${controller.value.playbackSpeed}');
      setState(() {});
    });
    _initializeVideoPlayerFuture = controller.initialize().then((_) {
      setState(() {});
      print('after initialize');
      return;
    });
  }
}
