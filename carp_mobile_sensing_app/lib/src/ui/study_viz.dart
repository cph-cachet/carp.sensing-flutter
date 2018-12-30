part of mobile_sensing_app;

class StudyVisualization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
