import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:figma_squircle/figma_squircle.dart';

import '../widgets/bottom_navbar.dart';
import 'profile.dart';
import 'scanner.dart';
import 'search.dart';
import 'history.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const SearchPage(),
    const QRScannerPage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index != 2) {  // Don't update index for scanner
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFD),
      // backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'QR Scanner',
          style: GoogleFonts.epilogue(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: _selectedIndex == 2 ? const HomeContent() : _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Cards (Today's Scan & Pending Orders)
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: "Today's Scan",
                  value: "247",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: "Pending Orders",
                  value: "10",
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Orders List
          Text(
            'Recent Orders',
            style: GoogleFonts.epilogue(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          _buildOrderCard(orderId: "SO-001", items: 10),
          _buildOrderCard(orderId: "SO-002", items: 12),
        ],
      ),
    );
  }

  // Statistic Card (White Background, Black Text, No Border, No Shadow)
  Widget _buildStatCard({
    required String title,
    required String value,
  }) {
    return ClipSmoothRect(
      radius: SmoothBorderRadius(
        cornerRadius: 20,
        cornerSmoothing: 1,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: SmoothBorderRadius(
            cornerRadius: 20,
            cornerSmoothing: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.epilogue(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.epilogue(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Order Card (White Background, No Border, No Shadow)
  Widget _buildOrderCard({required String orderId, required int items}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipSmoothRect(
        radius: SmoothBorderRadius(
          cornerRadius: 16,
          cornerSmoothing: 1,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: SmoothBorderRadius(
              cornerRadius: 16,
              cornerSmoothing: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderId,
                style: GoogleFonts.epilogue(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                '$items items',
                style: GoogleFonts.epilogue(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
