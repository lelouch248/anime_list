import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    return YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
      onReady: () {
        // Do something when the video player is ready.
      },
    );
  }
}
