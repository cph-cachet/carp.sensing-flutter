part of mobile_sensing_app;

class DataVisualization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Visualization'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
