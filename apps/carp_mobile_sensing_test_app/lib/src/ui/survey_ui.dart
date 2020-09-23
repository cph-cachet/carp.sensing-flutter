part of mobile_sensing_app;

class SurveyVisualization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (bloc.surveyPage != null)
        ? bloc.surveyPage
        : Scaffold(
            appBar: AppBar(
              title: Text('Survey'),
            ),
            body: Center(
              child: Icon(
                Icons.spellcheck,
                size: 100,
                color: CACHET.ORANGE,
              ),
              //child: CircularProgressIndicator(),
            ),
          );
  }
}
