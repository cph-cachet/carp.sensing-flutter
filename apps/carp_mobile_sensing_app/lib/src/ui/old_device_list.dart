// part of mobile_sensing_app;

// class DevicesList extends StatefulWidget {
//   const DevicesList({Key key}) : super(key: key);
//   static const String routeName = '/devicelist';
//   _DeviceListState createState() => _DeviceListState();
// }

// class _DeviceListState extends State<DevicesList> {
//   static final GlobalKey<ScaffoldState> scaffoldKey =
//       GlobalKey<ScaffoldState>();

//   Widget build(BuildContext context) {
//     Iterable<Widget> probes = ListTile.divideTiles(
//         context: context,
//         tiles: bloc.runningDevices
//             .map<Widget>((device) => _buildDeviceListTile(context, device)));

//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//         title: Text('Devices'),
//       ),
//       body: Scrollbar(
//         child: ListView(
//           padding: EdgeInsets.symmetric(vertical: 8.0),
//           children: probes.toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildDeviceListTile(BuildContext context, DeviceModel device) {
//     return StreamBuilder<DeviceStatus>(
//       stream: device.deviceEvents,
//       initialData: DeviceStatus.unknown,
//       builder: (context, AsyncSnapshot<DeviceStatus> snapshot) {
//         if (snapshot.hasData) {
//           return ListTile(
//             isThreeLine: true,
//             leading: device.icon,
//             title: Text('${device.name} - ${device.batteryLevel}%'),
//             subtitle: Text(device.description),
//             trailing: device.stateIcon,
//           );
//         } else if (snapshot.hasError) {
//           return Text('Error in device state - ${snapshot.error}');
//         }
//         return Text('Unknown');
//       },
//     );
//   }
// }
