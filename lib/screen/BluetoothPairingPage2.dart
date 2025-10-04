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

  List<ScanResult> scannedDevices = [];
  List<BluetoothDevice> connectedDevices = [];
  List<dynamic> displayDevices = [];

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
      scanDevices();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Izin Bluetooth dan lokasi diperlukan untuk menggunakan aplikasi",
          ),
        ),
      );
    }
  }

  void updateDisplayDevices() {
    final scannedIds = scannedDevices.map((s) => s.device.remoteId).toSet();

    final combined = [
      ...scannedDevices,
      ...connectedDevices.where((c) => !scannedIds.contains(c.remoteId)),
    ];

    setState(() {
      displayDevices = combined;
    });
  }

  void scanDevices() async {
    scannedDevices.clear();
    connectedDevices.clear();
    setState(() => isDiscovering = true);

    connectedDevices = await FlutterBluePlus.connectedSystemDevices;

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (!scannedDevices.any(
          (existing) => existing.device.remoteId == r.device.remoteId,
        )) {
          scannedDevices.add(r);
          print("Nama dari advertisement: ${r.advertisementData.localName}");
        }
      }
      updateDisplayDevices();
    });

    FlutterBluePlus.isScanning.listen((scanning) {
      if (!scanning) {
        setState(() => isDiscovering = false);
      }
    });
  }

  void searchDevices() {
    final identity = identityController.text.toLowerCase();
    final mac = macAddressController.text.toLowerCase();
    final uuid = uuidController.text.toLowerCase();

    final filtered =
        displayDevices.where((deviceInfo) {
          BluetoothDevice device;
          String name;

          if (deviceInfo is ScanResult) {
            device = deviceInfo.device;
            name = deviceInfo.advertisementData.localName.toLowerCase();
          } else if (deviceInfo is BluetoothDevice) {
            device = deviceInfo;
            name = device.platformName.toLowerCase();
          } else {
            return false;
          }

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
        const SnackBar(content: Text("Gagal menghubungkan ke perangkat")),
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
            const Center(
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
            const SizedBox(height: 40),
            TextField(
              controller: identityController,
              decoration: const InputDecoration(
                labelText: "Masukkan Identitas Perangkat",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: macAddressController,
              decoration: const InputDecoration(
                labelText: "Masukkan MAC Address",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: uuidController,
              decoration: const InputDecoration(
                labelText: "Masukkan UUID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
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
                          icon: const Icon(
                            Icons.search,
                            color: Color(0xFFEFCB13),
                          ),
                          label: const Text(
                            "CARI",
                            style: TextStyle(color: Color(0xFFCEE6F2)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF770606),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Atau",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton(
                          onPressed: scanDevices,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF770606),
                          ),
                          child: const Text(
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
                  final item = displayDevices[index];
                  BluetoothDevice? device;
                  String name = "";

                  if (item is ScanResult) {
                    device = item.device;
                    name = item.advertisementData.localName;
                  } else if (item is BluetoothDevice) {
                    device = item;
                    name = device.platformName;
                  } else {
                    return const SizedBox();
                  }
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(name.isNotEmpty ? name : "(Tanpa Nama)"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("MAC Address: ${device.remoteId.str}"),
                          Text("UUID: ${device.remoteId.str}"),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => connectToDevice(device!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF770606),
                          foregroundColor: const Color(0xFFCEE6F2),
                        ),
                        child: const Text("Connect"),
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
