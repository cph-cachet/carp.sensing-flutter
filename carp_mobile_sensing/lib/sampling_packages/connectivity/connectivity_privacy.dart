part of connectivity;

/// A [BluetoothDatum] anonymizer function. Anonymizes the name and discovery name of each
/// discovered bluetooth device. Bluetooth devices' names may contain participants'
/// real name because people use their names to name their computers and phones.
Datum blueetoth_name_anoymizer(Datum datum) {
  assert(datum is BluetoothDatum);
  BluetoothDatum bt = datum as BluetoothDatum;
  bt.scanResult.forEach((result) {
    result.bluetoothDeviceName = sha1.convert(utf8.encode(result.bluetoothDeviceName)).toString();
    result.advertisementName = sha1.convert(utf8.encode(result.advertisementName)).toString();
  });
  return bt;
}

/// A [WifiDatum] anonymizer function. Anonymizes the wifi name (SSID) of the wifi network.
/// Wifi network names may contain participants' or house holds' real name because people use
/// their names to name their wifi.
Datum wifi_name_anoymizer(Datum datum) {
  assert(datum is WifiDatum);
  WifiDatum wd = datum as WifiDatum;
  return wd..ssid = sha1.convert(utf8.encode(wd.ssid)).toString();
}
