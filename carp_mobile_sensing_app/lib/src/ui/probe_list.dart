part of mobile_sensing_app;

class ProbesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bloc.init();
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensing Probes'),
      ),
      body: StreamBuilder(
        stream: bloc.runningProbes,
        builder: (context, AsyncSnapshot<ProbeModel> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.name);
//            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ProbeModel> snapshot) {
    return GridView.builder(
        //itemCount: snapshot.data.results.length,
        //itemCount: bloc.runningProbes.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Text(snapshot.data.name);

//            Image.network(
//            'https://image.tmdb.org/t/p/w185${snapshot.data.results[index].poster_path}',
//            fit: BoxFit.cover,
//          );
        });
  }
}
