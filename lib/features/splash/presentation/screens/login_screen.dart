import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../app/widgets/resqnet_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  // Background image URL matching the disaster rescue aesthetic
  static const String _bgImageUrl =
      'https://images.unsplash.com/photo-1547683905-f686c993aae5?q=80&w=1200&auto=format&fit=crop';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withValues(alpha: 0.25),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Fullscreen Background Image
          Image.network(
            _bgImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1E293B),
                      Color(0xFF0F172A),
                      Color(0xFF334155),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: const Color(0xFF0F172A),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            },
          ),

          // 2. Dark Gradient Overlay for Contrast
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.60),
                  Colors.black.withValues(alpha: 0.40),
                  Colors.black.withValues(alpha: 0.75),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 3. Foreground Content with Glassmorphic Card
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Shield Logo & Title
                            const Center(
                              child: Column(
                                children: [
                                  ResQNetLogo(
                                    size: 44,
                                    showText: false,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Welcome Back!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Login to stay informed and help your community.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white70,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Email Label & Field
                            const Text(
                              'Email Address',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.white),
                              decoration: _buildGlassInputDecoration(
                                hintText: 'Enter your email',
                                prefixIcon: Icons.email_outlined,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                    .hasMatch(value.trim())) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Password Label & Field
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: _buildGlassInputDecoration(
                                hintText: 'Enter your password',
                                prefixIcon: Icons.lock_outline,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 28),

                            // Glassmorphic Red Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryRed.withValues(alpha: 0.90),
                                      const Color(0xFFB91C1C).withValues(alpha: 0.90),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.45),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryRed.withValues(alpha: 0.4),
                                      blurRadius: 14,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: () {

                                      Get.offAllNamed(Routes.mainNavigation);

                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Register Redirection
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Get.toNamed(Routes.register);
                                },
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 14),
                                    children: [
                                      const TextSpan(
                                        text: "Don't have an account? ",
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      TextSpan(
                                        text: 'Register',
                                        style: TextStyle(
                                          color: AppTheme.primaryRed,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable Input Decoration for Glassmorphic Text Fields
  InputDecoration _buildGlassInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
      prefixIcon: Icon(prefixIcon, color: Colors.white70, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.30),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.white,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppTheme.primaryRed.withValues(alpha: 0.8),
          width: 1.2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppTheme.primaryRed,
          width: 1.5,
        ),
      ),
      errorStyle: const TextStyle(
        color: Color(0xFFFCA5A5),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
