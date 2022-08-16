// youtube player
// only for android and ios

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayer extends StatelessWidget {
  final String videoId;
  const YoutubeVideoPlayer(this.videoId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        hideControls: false,
        showLiveFullscreenButton: false,
        mute: false,
      ),
    );

    return YoutubePlayer(
      controller: controller,
      progressIndicatorColor: Colors.amber,
      showVideoProgressIndicator: true,
      progressColors: const ProgressBarColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),
    );

    // full screen (unstable)
    // return YoutubePlayerBuilder(
    //     player: YoutubePlayer(
    //       controller: controller,
    //     ),
    //     builder: (context, player) {
    //       return Column(
    //         children: [
    //           // some widgets
    //           player,
    //           //some other widgets
    //         ],
    //       );
    //     });
  }
}

// Widget youtubePlayer(String videoId) {
//   YoutubePlayerController controller = YoutubePlayerController(
//     initialVideoId: videoId,
//     flags: const YoutubePlayerFlags(
//       autoPlay: false,
//       mute: false,
//     ),
//   );
//
//   YoutubePlayer(
//     controller: controller,
//     showVideoProgressIndicator: true,
//   );
//
//   return YoutubePlayerBuilder(
//       player: YoutubePlayer(
//         controller: controller,
//       ),
//       builder: (context, player) {
//         return Column(
//           children: [
//             // some widgets
//             player,
//             //some other widgets
//           ],
//         );
//       });
// }
