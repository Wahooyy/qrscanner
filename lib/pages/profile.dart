import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_service.dart';
import 'sign_in.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: FaIcon(
              FontAwesomeIcons.user,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Profile Name',
            style: GoogleFonts.epilogue(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'user@example.com',
            style: GoogleFonts.epilogue(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          // const SizedBox(height: 32),
          // ListTile(
          //   leading: const FaIcon(FontAwesomeIcons.gear),
          //   title: Text(
          //     'Settings',
          //     style: GoogleFonts.epilogue(),
          //   ),
          //   onTap: () {
          //     // Handle settings tap
          //   },
          // ),
          // ListTile(
          //   leading: const FaIcon(FontAwesomeIcons.circleInfo),
          //   title: Text(
          //     'About',
          //     style: GoogleFonts.epilogue(),
          //   ),
          //   onTap: () {
          //     // Handle about tap
          //   },
          // ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                await AuthService.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Keluar',
                style: GoogleFonts.epilogue(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}