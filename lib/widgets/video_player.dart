import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({Key? key, required this.videoId}) : super(key: key);

  final String videoId;

  @override
  State<StatefulWidget> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  @override
  Widget build(final BuildContext context) {
    return HtmlWidget(
      '<iframe src="https://www.youtube.com/embed/${widget.videoId}?rel=0" title="شرح السؤال" frameborder="0" allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>',
      factoryBuilder: () => VideoPlayerWidgetFactory(),
    );
  }
}

class VideoPlayerWidgetFactory extends WidgetFactory with WebViewFactory {}
