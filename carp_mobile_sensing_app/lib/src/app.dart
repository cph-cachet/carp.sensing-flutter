part of mobile_sensing_app;

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: ProbesList(),
      ),
    );
  }
}
