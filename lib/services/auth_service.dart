import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String baseUrl = 'http://192.168.1.229/erp';
  static String? csrfToken;
  static String? sessionId;

  static Future<bool> initializeAuth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/get_csrf'));
      
      if (response.statusCode == 200) {
        String? cookies = response.headers['set-cookie'];
        if (cookies != null) {
          RegExp csrfRegex = RegExp(r'csrf_cookie_name=([^;]+)');
          var csrfMatch = csrfRegex.firstMatch(cookies);
          if (csrfMatch != null) {
            csrfToken = csrfMatch.group(1);
          }

          RegExp sessionRegex = RegExp(r'ci_session=([^;]+)');
          var sessionMatch = sessionRegex.firstMatch(cookies);
          if (sessionMatch != null) {
            sessionId = sessionMatch.group(1);
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Error initializing auth: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      if (csrfToken == null) {
        await initializeAuth();
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        String? cookies = response.headers['set-cookie'];
        if (cookies != null) {
          RegExp sessionRegex = RegExp(r'ci_session=([^;]+)');
          var sessionMatch = sessionRegex.firstMatch(cookies);
          if (sessionMatch != null) {
            sessionId = sessionMatch.group(1);
          }
        }

        return json.decode(response.body);
      } else {
        throw Exception('Server error');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<void> signOut() async {
    // Clear tokens and session
    csrfToken = null;
    sessionId = null;
  }
}