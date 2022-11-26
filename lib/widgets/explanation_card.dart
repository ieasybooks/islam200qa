import 'package:flutter/material.dart';
import 'package:islam200qa/widgets/recording_player.dart';
import 'package:islam200qa/widgets/video_player.dart';

class ExplanationCard extends StatefulWidget {
  const ExplanationCard({
    Key? key,
    required this.videoId,
    required this.recordingId,
  }) : super(key: key);

  final String videoId;
  final String recordingId;

  @override
  State<ExplanationCard> createState() => _ExplanationCardState();
}

class _ExplanationCardState extends State<ExplanationCard>
    with SingleTickerProviderStateMixin {
  final List<Widget> tabs = [
    const Tab(text: 'فيديو للشرح'),
    const Tab(text: 'تسجيل صوتي للشرح'),
  ];

  late TabController _tabController;
  int _tabIndex = 0;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);

    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: <Widget>[
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black,
            tabs: tabs,
          ),
          Container(
            child: [
              VideoPlayer(videoId: widget.videoId),
              RecordingPlayer(recordingId: widget.recordingId),
            ][_tabIndex],
          ),
        ],
      ),
    );
  }
}
