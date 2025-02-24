import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/auth_service.dart';
import 'sign_in.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = AuthService.userData;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Profile Picture, Username & Email (Centered)
          Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/User.svg', // Custom SVG Icon
                    width: 50,
                    height: 50,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                userData?['username'] ?? 'Username',
                style: GoogleFonts.epilogue(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                userData?['email'] ?? 'Email',
                style: GoogleFonts.epilogue(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Section Title
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Profile Settings',
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // White Card with List Items
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildProfileOption(
                  svgIcon: 'assets/icons/User.svg',
                  text: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {},
                ),
                _buildSeparator(),
                _buildProfileOption(
                  svgIcon: 'assets/icons/Lock.svg',
                  text: 'Change Password',
                  subtitle: 'Secure your account with a new password',
                  onTap: () {},
                ),
                _buildSeparator(),
                _buildProfileOption(
                  svgIcon: 'assets/icons/Filter.svg',
                  text: 'Settings',
                  subtitle: 'Manage app preferences',
                  onTap: () {},
                ),
              ],
            ),
          ),

          const Spacer(),

          // Logout Button (No Shadow)
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
                backgroundColor: const Color.fromARGB(255, 255, 238, 238),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0, // No shadow
              ),
              child: Text(
                'Keluar',
                style: GoogleFonts.epilogue(
                  color: Colors.red,
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

  // Profile Option Widget with Custom SVG Icon Inside Grey Circle
  Widget _buildProfileOption({
    required String svgIcon,
    required String text,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            // Grey Circle with SVG Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  svgIcon,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Text & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.epilogue(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.epilogue(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Right Arrow Icon
            SvgPicture.asset(
              'assets/icons/Right.svg', // Custom SVG for Arrow
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }

  // Separator Widget
  Widget _buildSeparator() {
    return Divider(
      color: Colors.grey.shade300,
      height: 1,
      thickness: 1,
      indent: 20,
      endIndent: 20,
    );
  }
}
