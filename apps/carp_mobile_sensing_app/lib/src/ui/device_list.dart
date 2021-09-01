part of mobile_sensing_app;

class DevicesList extends StatefulWidget {
  const DevicesList({Key? key}) : super(key: key);
  static const String routeName = '/tasklist';
  _DevicesListState createState() => _DevicesListState();
}

class _DevicesListState extends State<DevicesList> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  Widget build(BuildContext context) {
    List<DeviceModel> devices = bloc.runningDevices.toList();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Devices'),
      ),
      body: StreamBuilder<UserTask>(
        stream: AppTaskController().userTaskEvents,
        builder: (context, AsyncSnapshot<UserTask> snapshot) {
          print('>> $snapshot');
          return Scrollbar(
            child: ListView.builder(
              itemCount: devices.length,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              itemBuilder: (context, index) =>
                  _buildTaskCard(context, devices[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, DeviceModel device) {
    return Center(
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: StreamBuilder<DeviceStatus>(
          stream: device.deviceEvents,
          initialData: DeviceStatus.unknown,
          builder: (context, AsyncSnapshot<DeviceStatus> snapshot) => Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: device.icon,
                title: Text(device.id),
                subtitle: Text(device.description),
                trailing: device.stateIcon,
              ),
              const Divider(),
              FlatButton(
                  child: const Text('How to use this device?'),
                  onPressed: () => print('Use the $device')),
              (device.status != DeviceStatus.connected)
                  ? Column(children: [
                      const Divider(),
                      FlatButton(
                        child: const Text('Connect to this device'),
                        onPressed: () => bloc.connectToDevice(device),
                      ),
                    ])
                  : Text(""),
              // ]
              //   (device.status != DeviceStatus.connected &&
              //           device.status != DeviceStatus.sampling)
              //       // (device.status != DeviceStatus.connected)
              //       ? ButtonBar(
              //           children: <Widget>[
              //             FlatButton(
              //                 child: const Text('CONNECT TO DEVICE'),
              //                 onPressed: () => bloc.connectToDevice(device)),
              //           ],
              //         )
              //       : Text(""),
            ],
          ),
        ),
      ),
    );
  }
}
