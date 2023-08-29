part of mobile_sensing_app;

class ProbesList extends StatefulWidget {
  const ProbesList({Key? key}) : super(key: key);
  static const String routeName = '/probelist';

  @override
  ProbeListState createState() => ProbeListState();
}

class ProbeListState extends State<ProbesList> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> probes = ListTile.divideTiles(
        context: context,
        tiles: bloc.runningProbes
            .map<Widget>((probe) => _probeListTile(context, probe)));

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Probes'),
        //TODO - move actions/settings icon to the app level.
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
      ),
      body: Scrollbar(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          children: probes.toList(),
        ),
      ),
    );
  }

  Widget _probeListTile(BuildContext context, ProbeModel probe) {
    return StreamBuilder<ExecutorState>(
      stream: probe.stateEvents,
      initialData: ExecutorState.created,
      builder: (context, AsyncSnapshot<ExecutorState> snapshot) {
        if (snapshot.hasData) {
          return ListTile(
            isThreeLine: true,
            leading: probe.icon,
            title: Text(probe.name ?? 'Unknown'),
            subtitle: Text(probe.description ?? '...'),
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
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings not implemented yet...')));
  }
}
