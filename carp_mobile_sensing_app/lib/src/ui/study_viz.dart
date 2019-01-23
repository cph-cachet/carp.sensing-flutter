part of mobile_sensing_app;

class StudyVisualization extends StatefulWidget {
  const StudyVisualization({Key key}) : super(key: key);

  static const String routeName = '/study';

  _StudyVizState createState() => _StudyVizState();
}

class _StudyVizState extends State<StudyVisualization> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  @override
  Widget build(BuildContext context) {
    if (bloc.study != null) {
      return _buildStudyVizualization(context, bloc.study);
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

  Widget _buildStudyVizualization(BuildContext context, StudyModel study) {
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
                  // This gradient ensures that the toolbar icons are distinct
                  // against the background image.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, -0.4),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: _buildStudyControllerPanel(context, study),
              ),
              _TaskPanel(
                icon: Icons.contact_mail,
                children: <Widget>[
                  _ContactItem(
                    icon: Icons.email,
                    tooltip: 'Send personal e-mail',
                    onPressed: () {
                      _scaffoldKey.currentState
                          .showSnackBar(const SnackBar(content: Text('Here, your e-mail application would open.')));
                    },
                    lines: const <String>[
                      'ali_connors@example.com',
                      'Personal',
                    ],
                  ),
                  _ContactItem(
                    icon: Icons.email,
                    tooltip: 'Send work e-mail',
                    onPressed: () {
                      _scaffoldKey.currentState
                          .showSnackBar(const SnackBar(content: Text('Summon your favorite e-mail application here.')));
                    },
                    lines: const <String>[
                      'aliconnors@example.com',
                      'Work',
                    ],
                  ),
                ],
              ),
              _TaskPanel(
                icon: Icons.location_on,
                children: <Widget>[
                  _ContactItem(
                    icon: Icons.map,
                    tooltip: 'Open map',
                    onPressed: () {
                      _scaffoldKey.currentState
                          .showSnackBar(const SnackBar(content: Text('This would show a map of San Francisco.')));
                    },
                    lines: const <String>[
                      '2000 Main Street',
                      'San Francisco, CA',
                      'Home',
                    ],
                  ),
                  _ContactItem(
                    icon: Icons.map,
                    tooltip: 'Open map',
                    onPressed: () {
                      _scaffoldKey.currentState
                          .showSnackBar(const SnackBar(content: Text('This would show a map of Mountain View.')));
                    },
                    lines: const <String>[
                      '1600 Amphitheater Parkway',
                      'Mountain View, CA',
                      'Work',
                    ],
                  ),
                  _ContactItem(
                    icon: Icons.map,
                    tooltip: 'Open map',
                    onPressed: () {
                      _scaffoldKey.currentState.showSnackBar(
                          const SnackBar(content: Text('This would also show a map, if this was not a demo.')));
                    },
                    lines: const <String>[
                      '126 Severyns Ave',
                      'Mountain View, CA',
                      'Jet Travel',
                    ],
                  ),
                ],
              ),
              _TaskPanel(
                icon: Icons.today,
                children: <Widget>[
                  _ContactItem(
                    lines: const <String>[
                      'Birthday',
                      'January 9th, 1989',
                    ],
                  ),
                  _ContactItem(
                    lines: const <String>[
                      'Wedding anniversary',
                      'June 21st, 2014',
                    ],
                  ),
                  _ContactItem(
                    lines: const <String>[
                      'First day in office',
                      'January 20th, 2015',
                    ],
                  ),
                  _ContactItem(
                    lines: const <String>[
                      'Last day in office',
                      'August 9th, 2018',
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
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
                  child: Icon(Icons.settings, size: 50, color: CACHET.PRIMARY_BLUE)),
              Expanded(
                  child: Column(children: [
                _buildStudyControllerLine(study.description),
                _buildStudyControllerLine(study.userID, heading: 'User'),
                _buildStudyControllerLine(study.samplingStrategy, heading: 'Sampling'),
                _buildStudyControllerLine(study.dataEndpoint, heading: 'Data Endpoint'),

                StreamBuilder<ProbeState>(
                    stream: bloc.studyExecutorStateEvents,
//                    initialData: ProbeState.created,
                    builder: (context, AsyncSnapshot<ProbeState> snapshot) {
                      if (snapshot.hasData)
                        return _buildStudyControllerLine(snapshot.data.toString(), heading: 'State');
                      else
                        return _buildStudyControllerLine(ProbeState.created.toString(), heading: 'State');
                    }),

                StreamBuilder<Datum>(
                    stream: bloc.samplingEvents,
                    builder: (context, AsyncSnapshot<Datum> snapshot) {
                      //if (snapshot.hasData) bloc.samplingSize++;
                      return _buildStudyControllerLine('${bloc.samplingSize}', heading: 'Sample Size');
                    }),

//                _buildStudyControllerLine(),
              ]))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudyControllerLine(String line, {String heading}) {
    return MergeSemantics(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
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

  void _showSettings() {
    Scaffold.of(context).showSnackBar(const SnackBar(content: Text('Settings not implemented yet...', softWrap: true)));
  }
}

class _TaskPanel extends StatelessWidget {
  const _TaskPanel({Key key, this.icon, this.children}) : super(key: key);

  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
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
                  child: Icon(icon, color: themeData.primaryColor)),
              Expanded(child: Column(children: children))
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  _ContactItem({Key key, this.icon, this.lines, this.tooltip, this.onPressed})
      : assert(lines.length > 1),
        super(key: key);

  final IconData icon;
  final List<String> lines;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> columnChildren =
        lines.sublist(0, lines.length - 1).map<Widget>((String line) => Text(line)).toList();
    columnChildren.add(Text(lines.last, style: themeData.textTheme.caption));

    final List<Widget> rowChildren = <Widget>[
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: columnChildren))
    ];
    if (icon != null) {
      rowChildren.add(SizedBox(
          width: 72.0, child: IconButton(icon: Icon(icon), color: themeData.primaryColor, onPressed: onPressed)));
    }
    return MergeSemantics(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: rowChildren)),
    );
  }
}
