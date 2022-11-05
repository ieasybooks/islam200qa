import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoCard extends StatefulWidget {
  const VideoCard({Key? key, required this.videosIds}) : super(key: key);

  final List<String> videosIds;

  @override
  State<StatefulWidget> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        enableCaption: false,
        interfaceLanguage: 'ar',
        showVideoAnnotations: false,
        strictRelatedVideos: true,
      ),
    )..onInit = () {
        if (widget.videosIds.length == 1) {
          _controller.cueVideoById(videoId: widget.videosIds[0]);
        } else {
          _controller.cuePlaylist(
            list: widget.videosIds,
            listType: ListType.playlist,
          );
        }
      };
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: <Widget>[
              YoutubePlayerScaffold(
                controller: _controller,
                builder: (context, player) => player,
              ),
            ] +
            (widget.videosIds.length > 1
                ? <Widget>[
                    const Text(
                      'تنبيه: يمكنك الإنتقال بين شروحات الأسئلة من خلال قائمة التشغيل.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ]
                : []),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
