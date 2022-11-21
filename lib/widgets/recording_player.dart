import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

class RecordingPlayer extends StatefulWidget {
  const RecordingPlayer({Key? key, required this.recordingId})
      : super(key: key);

  final String recordingId;

  @override
  State<StatefulWidget> createState() => _RecordingPlayerState();
}

class _RecordingPlayerState extends State<RecordingPlayer> {
  @override
  Widget build(final BuildContext context) {
    return HtmlWidget(
      '<iframe src="https://drive.google.com/file/d/${widget.recordingId}/preview?usp=sharing" title="شرح السؤال"></iframe>',
      factoryBuilder: () => RecordingPlayerWidgetFactory(),
    );
  }
}

class RecordingPlayerWidgetFactory extends WidgetFactory with WebViewFactory {}
