import 'package:flutter/material.dart';

class CustomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final centerWidth = 60.0;
    final curveHeight = 20.0;
    
    // Start from the left bottom corner
    path.moveTo(0, 0);
    
    // Draw line to the start of the curve
    path.lineTo((size.width - centerWidth) / 2 - 20, 0);
    
    // Draw the left curve
    path.quadraticBezierTo(
      (size.width - centerWidth) / 2, 
      -curveHeight,
      size.width / 2, 
      -curveHeight
    );
    
    // Draw the right curve
    path.quadraticBezierTo(
      (size.width + centerWidth) / 2,
      -curveHeight,
      (size.width + centerWidth) / 2 + 20,
      0
    );
    
    // Complete the shape
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomNavBarClipper oldClipper) => false;
}