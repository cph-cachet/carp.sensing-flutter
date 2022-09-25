part of mobile_sensing_app;

class StudyDeploymentPage extends StatefulWidget {
  const StudyDeploymentPage({super.key});
  static const String routeName = '/study';

  @override
  StudyDeploymentPageState createState() =>
      StudyDeploymentPageState(bloc.studyDeploymentModel);
}

class StudyDeploymentPageState extends State<StudyDeploymentPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  final StudyDeploymentModel studyDeploymentModel;

  StudyDeploymentPageState(this.studyDeploymentModel) : super();

  @override
  Widget build(BuildContext context) =>
      _buildStudyVisualization(context, bloc.studyDeploymentModel);

  Widget _buildStudyVisualization(
    BuildContext context,
    StudyDeploymentModel studyDeploymentModel,
  ) {
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
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? Icons.more_horiz
                      : Icons.more_vert,
                ),
                tooltip: 'Settings',
                onPressed: _showSettings,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(studyDeploymentModel.title),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  studyDeploymentModel.image,
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
            delegate: SliverChildListDelegate(
                _buildStudyPanel(context, studyDeploymentModel)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStudyPanel(
      BuildContext context, StudyDeploymentModel studyDeploymentModel) {
    List<Widget> children = [];

    children.add(AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: _buildStudyControllerPanel(context, studyDeploymentModel),
    ));

    for (var task in studyDeploymentModel.deployment.tasks) {
      children.add(_TaskPanel(task: task));
    }

    return children;
  }

  Widget _buildStudyControllerPanel(
      BuildContext context, StudyDeploymentModel studyDeploymentModel) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: themeData.dividerColor))),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subtitle1!,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  width: 72.0,
                  child: Icon(Icons.settings,
                      size: 50, color: CACHET.CACHET_BLUE)),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    _StudyControllerLine(studyDeploymentModel.title,
                        heading: 'Title'),
                    _StudyControllerLine(studyDeploymentModel.description),
                    _StudyControllerLine(studyDeploymentModel.studyDeploymentId,
                        heading: 'Deployment ID'),
                    _StudyControllerLine(studyDeploymentModel.userID,
                        heading: 'User'),
                    _StudyControllerLine(studyDeploymentModel.dataEndpoint,
                        heading: 'Data Endpoint'),
                    StreamBuilder<ExecutorState>(
                        stream: studyDeploymentModel.studyExecutorStateEvents,
                        initialData: ExecutorState.created,
                        builder:
                            (context, AsyncSnapshot<ExecutorState> snapshot) {
                          if (snapshot.hasData) {
                            return _StudyControllerLine(
                                ProbeDescription
                                    .probeStateLabel[snapshot.data!],
                                heading: 'State');
                          } else {
                            return _StudyControllerLine(
                                ProbeDescription
                                    .probeStateLabel[ExecutorState.initialized],
                                heading: 'State');
                          }
                        }),
                    StreamBuilder<DataPoint>(
                        stream: studyDeploymentModel.data,
                        builder: (context, AsyncSnapshot<DataPoint> snapshot) {
                          return _StudyControllerLine(
                              '${studyDeploymentModel.samplingSize}',
                              heading: 'Sample Size');
                        }),
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Settings not implemented yet...', softWrap: true)));
  }
}

class _StudyControllerLine extends StatelessWidget {
  final String? line, heading;

  _StudyControllerLine(this.line, {this.heading}) : super();

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: (heading == null)
                ? Text(line!, textAlign: TextAlign.left, softWrap: true)
                : Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: '$heading: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: line),
                      ],
                    ),
                  )));
  }
}

class _TaskPanel extends StatelessWidget {
  _TaskPanel({Key? key, this.task}) : super(key: key);

  final TaskDescriptor? task;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> children = task!.measures
        .map((measure) => _MeasureLine(measure: measure))
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: themeData.dividerColor))),
      child: DefaultTextStyle(
          style: Theme.of(context).textTheme.subtitle1!,
          child: SafeArea(
              top: false,
              bottom: false,
              child: Column(children: <Widget>[
                Row(children: <Widget>[
                  Icon(Icons.description, size: 40, color: CACHET.ORANGE),
                  Text('  ${task!.name}', style: themeData.textTheme.headline6),
                ]),
                Column(children: children)
                //Expanded(child: Column(children: children))
              ]))),
    );
  }
}

class _MeasureLine extends StatelessWidget {
  _MeasureLine({Key? key, this.measure}) : super(key: key);

  final Measure? measure;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Icon icon = (ProbeDescription.probeTypeIcon[measure!.type] != null)
        ? Icon(ProbeDescription.probeTypeIcon[measure!.type]!.icon, size: 25)
        : Icon(ProbeDescription.probeTypeIcon[DataType.UNKNOWN as String]!.icon,
            size: 25);

    final String name = ProbeDescription.descriptors[measure?.type]?.name ??
        measure.runtimeType.toString();

    final List<Widget> columnChildren = [];
    columnChildren.add(Text(name));
    columnChildren
        .add(Text(measure.toString(), style: themeData.textTheme.caption));

    final List<Widget> rowChildren = [];
    rowChildren.add(SizedBox(
        width: 72.0,
        child: IconButton(
          icon: icon,
          onPressed: null,
        )));

    rowChildren.addAll([
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren))
    ]);
    return MergeSemantics(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren)),
    );
  }
}
