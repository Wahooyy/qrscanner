import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner Cok',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.epilogueTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QRScannerPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'QR Scanner Cok',
          style: GoogleFonts.epilogue(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ini QR Scanner ya',
              style: GoogleFonts.epilogue(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Klik tombol scan dibawah buat scan qr ya jing.',
              style: GoogleFonts.epilogue(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),
            FaIcon(
              FontAwesomeIcons.qrcode,
              size: 100,
              color: Colors.blue.shade800,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Stack(
          children: [
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blue.shade800,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.house, size: 20),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20),
                  label: 'Cari',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.scanner),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.clockRotateLeft, size: 20),
                  label: 'Riwayat',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.user, size: 20),
                  label: 'Profil',
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => _onItemTapped(2),
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.qrcode,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _hasPermission = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Scan QR Code',
          style: GoogleFonts.epilogue(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                return FaIcon(
                  state == TorchState.off 
                    ? FontAwesomeIcons.bolt 
                    : FontAwesomeIcons.bolt,
                  color: Colors.black,
                );
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                return FaIcon(
                  state == CameraFacing.front
                    ? FontAwesomeIcons.cameraRotate
                    : FontAwesomeIcons.camera,
                  color: Colors.black,
                );
              },
            ),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: _hasPermission
          ? MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  _showResultDialog(barcode.rawValue ?? 'Invalid QR Code');
                }
              },
            )
          : Center(
              child: Text(
                'Camera permission is required',
                style: GoogleFonts.epilogue(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
    );
  }

  void _showResultDialog(String code) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'QR Code Result',
            style: GoogleFonts.epilogue(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              code,
              style: GoogleFonts.epilogue(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: GoogleFonts.epilogue(),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}