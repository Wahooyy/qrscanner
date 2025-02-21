import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_svg/flutter_svg.dart';


class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> with SingleTickerProviderStateMixin {
  MobileScannerController cameraController = MobileScannerController();
  bool _hasPermission = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  final TextEditingController _salesOrderController = TextEditingController();
  final TextEditingController _debugProductController = TextEditingController(); // New controller for debug input
  final Set<String> _scannedProducts = {};
  String? _currentSalesOrder;
  bool _showDebugInput = false; // Toggle for debug input visibility
  
  // Dummy sales order data
  final List<String> _dummySalesOrders = [
    'SO-001',
    'SO-002',
    'SO-003',
  ];

  // Dummy product data for testing
  final List<String> _dummyProducts = [
    'PROD-001',
    'PROD-002',
    'PROD-003',
    'PROD-004',
    'PROD-005',
    'PROD-006',
    'PROD-007',
    'PROD-008',
    'PROD-009',
    'PROD-010',
  ];

  @override
  void initState() {
    super.initState();
    _checkPermission();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 200.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    cameraController.dispose();
    _salesOrderController.dispose();
    _debugProductController.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;

      if (!status.isGranted) {
        final newStatus = await Permission.camera.request();
        setState(() {
          _hasPermission = newStatus.isGranted;
        });
      } else {
        setState(() {
          _hasPermission = true;
        });
      }
      if (status.isPermanentlyDenied) {
      openAppSettings();
      }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf1f2f4),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/Left.svg',  // Path to your SVG file
            width: 36,   // Adjust size as needed
            height: 36,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '',
          style: GoogleFonts.epilogue(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          // Debug mode toggle
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/Filter.svg',  // Path to your SVG file
              width: 24,   // Adjust size as needed
              height: 24,
            ),
            onPressed: () {
              setState(() {
                _showDebugInput = !_showDebugInput;
              });
            },
          ),
          IconButton(
            icon: ValueListenableBuilder<TorchState>(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                return SvgPicture.asset(
                  state == TorchState.off 
                    ? 'assets/icons/Lightning.svg' 
                    : 'assets/icons/Lightning.svg',
                  width: 24, // Adjust as needed
                  height: 24,
                  colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn), // Change icon color if needed
                );
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Sales Order Input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _salesOrderController,
                  decoration: InputDecoration(
                    hintText: 'Cari Kode',
                    filled: true,
                    fillColor: Colors.white, // White background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/Search.svg',  // Path to your SVG file
                        width: 24,   // Adjust size as needed
                        height: 24,
                      ),
                      onPressed: () {
                        if (_salesOrderController.text.isNotEmpty) {
                          _validateAndSetSalesOrder(_salesOrderController.text);
                        }
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _validateAndSetSalesOrder(value);
                    }
                  },
                ),
                
                // Debug Input Section
                if (_showDebugInput && _currentSalesOrder != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.bug_report, color: Colors.amber),
                              const SizedBox(width: 8),
                              const Text('Debug Mode: Tambah Manual'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _debugProductController,
                                decoration: InputDecoration(
                                  hintText: 'Kode Roll',
                                  filled: true,
                                  fillColor: Colors.white, // White background
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (_debugProductController.text.isNotEmpty) {
                                  // Simulate QR scan with manual input
                                  _addScannedProduct(_debugProductController.text);
                                  _debugProductController.clear();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Current Sales Order Display
          if (_currentSalesOrder != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Scan untuk Sales Order: $_currentSalesOrder',
                      style: GoogleFonts.epilogue(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Camera Container (only show if debug mode is off)
          if (_hasPermission && _currentSalesOrder != null && !_showDebugInput)
            Container(
              margin: const EdgeInsets.all(16),
              height: 250,
              width: double.infinity, // Adjust width automatically to parent
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: cameraController,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          final code = barcode.rawValue ?? 'QR Code tidak ditemukan';
                          _addScannedProduct(code);
                        }
                      },
                    ),
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Positioned(
                          top: _animation.value,
                          left: 100,
                          right: 100, 
                          child: Container(
                            width: 200,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          // Scanned Products List
          if (_currentSalesOrder != null)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                    child: Text(
                      'List Item',
                      style: GoogleFonts.epilogue(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 100),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _scannedProducts.length,
                      itemBuilder: (context, index) {
                        final code = _scannedProducts.elementAt(index);

                        return Dismissible(
                          key: Key(code),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.only(bottom: 16), // Match item spacing
                            decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12), // Rounded corners
                            ),
                            child: Container(
                              width: 40, // Circle size
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.white, // White background for delete icon
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              _scannedProducts.remove(code);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$code dihapus')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                code,
                                style: GoogleFonts.epilogue(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )


          else
            Expanded(
              child: Center(
                child: Text(
                  'Masukkan kode sales order terlebih dahulu',
                  style: GoogleFonts.epilogue(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

          // Submit Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB), 
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: (_currentSalesOrder != null && _scannedProducts.isNotEmpty) 
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Berhasil!')),
                    );
                  }
                : null,
              child: Text(
                'Simpan',
                style: GoogleFonts.epilogue(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndSetSalesOrder(String code) {
    if (_dummySalesOrders.contains(code)) {
      setState(() {
        _currentSalesOrder = code;
        _scannedProducts.clear(); // Clear previous scans when changing sales order
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sales Order $code dipilih')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode tidak ditemukan')),
      );
    }
  }

  void _addScannedProduct(String code) {
    // Validate against dummy products for testing
    if (!_dummyProducts.contains(code)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode produk tidak ditemukan')),
      );
      return;
    }

    if (!_scannedProducts.contains(code)) {
      setState(() {
        _scannedProducts.add(code);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode ini sudah di scan')),
      );
    }
  }
}