import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scan History',
            style: GoogleFonts.epilogue(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 0,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const FaIcon(FontAwesomeIcons.qrcode),
                  title: Text(
                    'Scanned QR Code',
                    style: GoogleFonts.epilogue(),
                  ),
                  subtitle: Text(
                    'Date and time',
                    style: GoogleFonts.epilogue(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}