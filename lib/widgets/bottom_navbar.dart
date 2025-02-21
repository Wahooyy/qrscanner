import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory, // Removes the ripple animation
              highlightColor: Colors.transparent, // Removes highlight effect
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              currentIndex: selectedIndex,
              onTap: onItemTapped,
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: SvgPicture.asset(
                      'assets/icons/Home.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(selectedIndex == 0 ? Colors.blue : Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: SvgPicture.asset(
                      'assets/icons/Search.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(selectedIndex == 1 ? Colors.blue : Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
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
                    child: SvgPicture.asset(
                      'assets/icons/Vector.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(selectedIndex == 3 ? Colors.blue : Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: SvgPicture.asset(
                      'assets/icons/User.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(selectedIndex == 4 ? Colors.blue : Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  label: '',
                ),
              ],
            ),
          ),
        ),
        // White curved background for the center button
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        // Center button
        Positioned(
          bottom: 45,
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
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.2),
                  //     spreadRadius: 3,
                  //     blurRadius: 10,
                  //   ),
                  // ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/Scanner.svg',
                    width: 36,
                    height: 36,
                    color: Colors.white
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