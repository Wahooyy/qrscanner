import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'homepage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      await AuthService.initializeAuth();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error initializing connection',
              style: GoogleFonts.epilogue(),
            ),
            backgroundColor: const Color(0xFFE21C3D),
          ),
        );
      }
    }
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['message'] ?? 'Login failed',
              style: GoogleFonts.epilogue(),
            ),
            backgroundColor: const Color(0xFFE21C3D),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Connection error. Please try again.',
            style: GoogleFonts.epilogue(),
          ),
          backgroundColor: const Color(0xFFE21C3D),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _getInputDecoration({
    required String hintText,
    required Widget prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.epilogue(
        color: const Color(0xFF868686),
      ),
      filled: true,
      fillColor: const Color(0xFFEEF1F5),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      errorStyle: GoogleFonts.epilogue(
        color: const Color(0xFFE21C3D),
      ),
    );
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
          'Sign In',
          style: GoogleFonts.epilogue(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo ges',
                    style: GoogleFonts.epilogue(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masuk pake akun.',
                    style: GoogleFonts.epilogue(
                      fontSize: 16,
                      color: const Color(0xFF868686),
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _usernameController,
                    decoration: _getInputDecoration(
                      hintText: 'Username',
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF868686),
                      ),
                    ),
                    style: GoogleFonts.epilogue(
                      color: const Color(0xFF868686),
                      fontWeight: FontWeight.w500,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username harus diisi.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: _getInputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF868686),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0xFF868686),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    style: GoogleFonts.epilogue(
                      color: const Color(0xFF868686),
                      fontWeight: FontWeight.w500,
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password harus diisi.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue.shade800,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Sign In',
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
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}