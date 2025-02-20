import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../pages/scanner.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
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
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue.shade800,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: selectedIndex,
            onTap: onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: FaIcon(FontAwesomeIcons.house, size: 20),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Icon(Icons.scanner),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: FaIcon(FontAwesomeIcons.clockRotateLeft, size: 20),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: FaIcon(FontAwesomeIcons.user, size: 20),
                ),
                label: '',
              ),
            ],
          ),
        ),
        // White curved background for the center button
        Positioned(
          bottom: 39,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Center button
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRScannerPage()),
              );
            },
            child: Center(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  shape: BoxShape.circle,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.2),
                  //     spreadRadius: 3,
                  //     blurRadius: 10,
                  //   ),
                  // ],
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.qrcode,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}