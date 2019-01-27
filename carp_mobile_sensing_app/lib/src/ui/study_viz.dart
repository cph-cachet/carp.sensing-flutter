part of mobile_sensing_app;

class StudyVisualization extends StatefulWidget {
  const StudyVisualization({Key key}) : super(key: key);
  static const String routeName = '/study';

  _StudyVizState createState() => _StudyVizState(bloc.study);
}

class _StudyVizState extends State<StudyVisualization> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  final StudyModel study;

  _StudyVizState(this.study) : super();

  @override
  Widget build(BuildContext context) {
    if (bloc.study != null) {
      return _buildStudyVisualization(context, study);
    } else {
      return _buildEmptyStudyPanel(context);
    }
  }

  Widget _buildEmptyStudyPanel(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study'),
      ),
      body: Center(
        child: Icon(
          Icons.school,
          size: 100,
          color: CACHET.ORANGE,
        ),
      ),
    );
  }

  Widget _buildStudyVisualization(BuildContext context, StudyModel study) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: _appBarHeight,
            pinned: true,
            floating: false,
            snap: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Theme.of(context).platform == TargetPlatform.iOS ? Icons.more_horiz : Icons.more_vert,
                ),
                tooltip: 'Settings',
                onPressed: _showSettings,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(study.name),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  study.image,
//                  Image.asset(
//                    bloc.study.image,
//                    fit: BoxFit.cover,
//                    height: _appBarHeight,
//                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(_buildStudyPanel(context, study)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStudyPanel(BuildContext context, StudyModel study) {
    List<Widget> children = List<Widget>();

    children.add(AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: _buildStudyControllerPanel(context, study),
    ));

    study.study.tasks.forEach((task) => children.add(_TaskPanel(task: task)));

    return children;
  }

  Widget _buildStudyControllerPanel(BuildContext context, StudyModel study) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: themeData.dividerColor))),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subhead,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  width: 72.0,
                  child: Icon(Icons.settings, size: 50, color: CACHET.CACHET_BLUE)),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _StudyControllerLine(study.description),
                _StudyControllerLine(study.userID, heading: 'User'),
                _StudyControllerLine(study.samplingStrategy, heading: 'Sampling Strategy'),
                _StudyControllerLine(study.dataEndpoint, heading: 'Data Endpoint'),
                StreamBuilder<ProbeState>(
                    stream: study.studyExecutorStateEvents,
                    initialData: ProbeState.created,
                    builder: (context, AsyncSnapshot<ProbeState> snapshot) {
                      if (snapshot.hasData)
                        return _StudyControllerLine(probeStateLabel(snapshot.data), heading: 'State');
                      else
                        return _StudyControllerLine(probeStateLabel(ProbeState.initialized), heading: 'State');
                    }),
                StreamBuilder<Datum>(
                    stream: study.samplingEvents,
                    builder: (context, AsyncSnapshot<Datum> snapshot) {
                      return _StudyControllerLine('${study.samplingSize}', heading: 'Sample Size');
                    }),
              ]))
            ],
          ),
        ),
      ),
    );
  }

  void _showSettings() {
    Scaffold.of(context).showSnackBar(const SnackBar(content: Text('Settings not implemented yet...', softWrap: true)));
  }
}

class _StudyControllerLine extends StatelessWidget {
  final String line, heading;

  _StudyControllerLine(this.line, {this.heading}) : super();

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: (heading == null)
                ? Text(line, textAlign: TextAlign.left, softWrap: true)
                : Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: '$heading: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: line),
                      ],
                    ),
                  )));
  }
}

class _TaskPanel extends StatelessWidget {
  _TaskPanel({Key key, this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> children = task.measures.map((measure) => _MeasureLine(measure: measure)).toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: themeData.dividerColor))),
      child: DefaultTextStyle(
          style: Theme.of(context).textTheme.subhead,
          child: SafeArea(
              top: false,
              bottom: false,
              child: Column(children: <Widget>[
                Row(children: <Widget>[
                  Icon(Icons.description, size: 40, color: CACHET.ORANGE),
                  Text('  ${task.name}', style: themeData.textTheme.title),
                ]),
                Column(children: children)
                //Expanded(child: Column(children: children))
              ]))),
    );
  }
}

class _MeasureLine extends StatelessWidget {
  _MeasureLine({Key key, this.measure})
      : assert(measure != null),
        super(key: key);

  final Measure measure;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Icon icon = Icon(ProbeDescription.probeTypeIcon[measure.type.name].icon, size: 25);

    final List<Widget> columnChildren = List<Widget>();
    columnChildren.add(Text(measure.name));
    columnChildren.add(Text(measure.toString(), style: themeData.textTheme.caption));

    final List<Widget> rowChildren = List<Widget>();
    if (icon != null) {
      rowChildren.add(SizedBox(
          width: 72.0,
          child: IconButton(
            icon: icon,
            onPressed: null,
          )));
    }
    rowChildren
        .addAll([Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: columnChildren))]);
    return MergeSemantics(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: rowChildren)),
    );
  }
}
