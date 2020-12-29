part of carp_webservices_example_app;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    bloc.init();
  }

  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CARP Authentication Example'),
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 80,
            width: 200,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: TextButton.icon(
              onPressed: () => bloc.authenticate(
                context,
                username: 'sys1admin1DK@cachet.dk',
              ),
              icon: Icon(Icons.login),
              label: Text(
                'LOGIN',
                style: TextStyle(fontSize: 35),
              ),
            ),
          ),
          StreamBuilder(
            stream: CarpService().authStateChanges,
            builder: (BuildContext context, AsyncSnapshot<AuthEvent> event) =>
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: Text(
                        'Authentication status: ${(CarpService().authenticated) ? 'Authenticated' : 'Not authenticated'}')),
          )
        ],
      )),
    );
  }
}
