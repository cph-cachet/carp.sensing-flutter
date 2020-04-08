part of mobile_sensing_app;

class ProbesList extends StatefulWidget {
  const ProbesList({Key key}) : super(key: key);

  static const String routeName = '/probelist';

  _ProbeListState createState() => _ProbeListState();
}

class _ProbeListState extends State<ProbesList> {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    Iterable<Widget> probes = ListTile.divideTiles(
        context: context, tiles: bloc.runningProbes.map<Widget>((probe) => _buildProbeListTile(context, probe)));

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Probes'),
        //TODO - move actions/settings icon to the app level.
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Theme.of(context).platform == TargetPlatform.iOS ? Icons.more_horiz : Icons.more_vert,
            ),
            tooltip: 'Settings',
            onPressed: _showSettings,
          ),
        ],
      ),
      body: Scrollbar(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: probes.toList(),
        ),
      ),
    );
  }

  Widget _buildProbeListTile(BuildContext context, ProbeModel probe) {
    return StreamBuilder<ProbeState>(
      stream: probe.stateEvents,
      initialData: ProbeState.created,
      builder: (context, AsyncSnapshot<ProbeState> snapshot) {
        if (snapshot.hasData) {
          return ListTile(
            isThreeLine: true,
            leading: probe.icon,
            title: Text(probe.name),
            subtitle: Text(probe.description),
//            subtitle: Text(probe.measure.toString()),
            trailing: probe.stateIcon,
          );
        } else if (snapshot.hasError) {
          return Text('Error in probe state - ${snapshot.error}');
        }
        return Text('Unknown');
      },
    );
  }

  void _showSettings() {
    Scaffold.of(context).showSnackBar(const SnackBar(content: Text('Settings not implemented yet...')));
  }
}
