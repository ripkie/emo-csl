import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ChooseMode.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  TextEditingController identityController = TextEditingController();
  TextEditingController macAddressController = TextEditingController();
  TextEditingController uuidController = TextEditingController();

  List<ScanResult> discoveredDevices = [];
  List<ScanResult> displayDevices = [];
  bool isDiscovering = false;

  @override
  void initState() {
    super.initState();
    requestPermissionAndLoad();
  }

  Future<void> requestPermissionAndLoad() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.locationWhenInUse.request();

    if (await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.locationWhenInUse.isGranted) {
      // Tidak perlu load connected untuk hasil scan saja
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Izin Bluetooth dan lokasi diperlukan untuk menggunakan aplikasi",
          ),
        ),
      );
    }
  }

  void searchDevices() async {
    final identity = identityController.text.toLowerCase();
    final mac = macAddressController.text.toLowerCase();
    final uuid = uuidController.text.toLowerCase();

    List<ScanResult> filtered =
        discoveredDevices.where((result) {
          final device = result.device;
          final name = result.advertisementData.localName.toLowerCase();
          final address = device.remoteId.str.toLowerCase();
          final deviceUuid = device.remoteId.str.toLowerCase();

          return name.contains(identity) ||
              address.contains(mac) ||
              deviceUuid.contains(uuid);
        }).toList();

    setState(() {
      displayDevices = filtered;
    });
  }

  void scanDevices() async {
    if (!await Permission.bluetoothScan.isGranted) {
      await Permission.bluetoothScan.request();
    }

    setState(() {
      discoveredDevices.clear();
      isDiscovering = true;
    });

    await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (!discoveredDevices.any(
          (d) => d.device.remoteId == r.device.remoteId,
        )) {
          setState(() {
            discoveredDevices.add(r);
            displayDevices = discoveredDevices;
          });
        }
      }
    });

    FlutterBluePlus.isScanning.listen((scanning) {
      if (!scanning) {
        setState(() {
          isDiscovering = false;
        });
      }
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      print('Terhubung ke ${device.platformName}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseModePage(deviceName: device.platformName),
        ),
      );
    } catch (e) {
      print('Gagal terhubung: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghubungkan ke perangkat")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Hubungkan dengan EMO!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Image.asset(
                'assets/images/Logo_CC.png',
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: identityController,
              decoration: InputDecoration(
                labelText: "Masukkan Identitas Perangkat",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: macAddressController,
              decoration: InputDecoration(
                labelText: "Masukkan MAC Address",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: uuidController,
              decoration: InputDecoration(
                labelText: "Masukkan UUID",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double buttonWidth = constraints.maxWidth * 0.6;
                  buttonWidth = buttonWidth > 300 ? 300 : buttonWidth;

                  return Column(
                    children: [
                      SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton.icon(
                          onPressed: searchDevices,
                          icon: Icon(Icons.search, color: Color(0xFFEFCB13)),
                          label: Text(
                            "CARI",
                            style: TextStyle(color: Color(0xFFCEE6F2)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF770606),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Atau",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton(
                          onPressed: scanDevices,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF770606),
                          ),
                          child: Text(
                            "PINDAI SEKARANG",
                            style: TextStyle(color: Color(0xFFCEE6F2)),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: displayDevices.length,
                itemBuilder: (context, index) {
                  final result = displayDevices[index];
                  final device = result.device;
                  final name = result.advertisementData.localName;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        name.isNotEmpty ? name : "(Tanpa Nama)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("MAC Address: ${device.remoteId.str}"),
                          Text("UUID: ${device.remoteId.str}"),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => connectToDevice(device),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF770606),
                          foregroundColor: Color(0xFFCEE6F2),
                        ),
                        child: Text("Connect"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
