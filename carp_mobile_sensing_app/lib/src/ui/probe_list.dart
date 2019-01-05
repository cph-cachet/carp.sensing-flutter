part of mobile_sensing_app;

class ProbesList extends StatefulWidget {
  const ProbesList({Key key}) : super(key: key);

  //static const String routeName = '/material/list';

  @override
  _ProbeListState createState() => _ProbeListState();
}

class _ProbeListState extends State<ProbesList> {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Widget buildProbeListTile(BuildContext context, ProbeModel probe) {
    return MergeSemantics(
      child: ListTile(
        isThreeLine: true,
        //dense: _dense,
        //leading:  ExcludeSemantics(child: CircleAvatar(child: Text(snapshot.data.name.substring(0,2).toUpperCase()))),
        //leading: ExcludeSemantics(child: probe.icon),
        leading: Icon(
          probe.icon.icon,
          size: 50,
          color: probe.icon.color,
        ),
        title: Text(probe.name),
        subtitle: Text(probe.description),
        trailing: probe.isRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
    );
  }

//  Widget buildProbeListTile(BuildContext context, AsyncSnapshot<ProbeModel> snapshot) {
//    return MergeSemantics(
//      child: ListTile(
//        isThreeLine: true,
//        //dense: _dense,
//        //leading:  ExcludeSemantics(child: CircleAvatar(child: Text(snapshot.data.name.substring(0,2).toUpperCase()))),
//        leading: ExcludeSemantics(child: snapshot.data.icon),
//        title: Text(snapshot.data.name),
//        subtitle: Text(snapshot.data.description),
//        trailing: snapshot.data.isRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow),
//      ),
//    );
//  }

//  List<Widget> buildProbeList(BuildContext context) {
//    List<Widget> list = List<Widget>();
//    StreamBuilder(
//        stream: bloc.runningProbes,
//        builder: (context, AsyncSnapshot<ProbeModel> snapshot) {
//          if (snapshot.hasData) {
//            list.add(buildProbeListTile(context, snapshot));
//          } else if (snapshot.hasError) {
//            list.add(Text(snapshot.error.toString()));
//          }
//          //return Center(child: CircularProgressIndicator());
//        });
//    return list;
//  }

  @override
  Widget build(BuildContext context) {
//    final String layoutText = _dense ? ' \u2013 Dense' : '';
//    String itemTypeText;
//    switch (_itemType) {
//      case _MaterialListType.oneLine:
//      case _MaterialListType.oneLineWithAvatar:
//        itemTypeText = 'Single-line';
//        break;
//      case _MaterialListType.twoLine:
//        itemTypeText = 'Two-line';
//        break;
//      case _MaterialListType.threeLine:
//        itemTypeText = 'Three-line';
//        break;
//    }

//    Iterable<Widget> listProbes = bloc.runningProbes.map<Widget>((String item) => buildProbeListTile(context, item));
//    if (_showDividers) listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

    Iterable<Widget> probes = bloc.runningProbes.map<Widget>((probe) => buildProbeListTile(context, probe));
    probes = ListTile.divideTiles(context: context, tiles: probes);

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

  void _showSettings() {
    Scaffold.of(context).showSnackBar(const SnackBar(content: Text('Settings not implemented yet...')));
  }
}

//class OldProbesList extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    bloc.init();
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Sensing Probes'),
//      ),
//      body: StreamBuilder<ProbeModel>(
//        stream: bloc.runningProbes,
//        builder: (context, AsyncSnapshot<ProbeModel> snapshot) {
//          if (snapshot.hasData) {
//            return Text(snapshot.data.name);
////            return buildList(snapshot);
//          } else if (snapshot.hasError) {
//            return Text(snapshot.error.toString());
//          }
//          return Center(child: CircularProgressIndicator());
//        },
//      ),
//    );
//  }
//
//  Widget buildList(AsyncSnapshot<ProbeModel> snapshot) {
//    return GridView.builder(
//        //itemCount: snapshot.data.results.length,
//        //itemCount: bloc.runningProbes.length,
//        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//        itemBuilder: (BuildContext context, int index) {
//          return Text(snapshot.data.name);
//
////            Image.network(
////            'https://image.tmdb.org/t/p/w185${snapshot.data.results[index].poster_path}',
////            fit: BoxFit.cover,
////          );
//        });
//  }
//}
