part of mobile_sensing_app;

class DataVisualization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Visualization'),
      ),
      body: Center(
        child: Icon(
          Icons.show_chart,
          size: 100,
          color: CACHET.DARK_BLUE,
        ),
        //child: CircularProgressIndicator(),
      ),
    );
  }
}
