
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/widgets/resqnet_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  static const String _bgImageUrl =
      'https://images.unsplash.com/photo-1547683905-f686c993aae5?q=80&w=1200&auto=format&fit=crop';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withValues(alpha: 0.25),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
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
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;

              return Container(
                color: const Color(0xFF0F172A),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),

          // Dark overlay
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

          // Glassmorphism registration form
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 16,
                      sigmaY: 16,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 28,
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
                            // Logo and heading
                            const Center(
                              child: Column(
                                children: [
                                  ResQNetLogo(
                                    size: 44,
                                    showText: false,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Create Account',
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
                                    'Join ResQNet and help keep your '
                                        'community safe.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white70,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Full name
                            _buildLabel('Full Name'),
                            const SizedBox(height: 8),

                            TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              textCapitalization:
                              TextCapitalization.words,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: _buildGlassInputDecoration(
                                hintText: 'Enter your full name',
                                prefixIcon: Icons.person_outline,
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            // Email
                            _buildLabel('Email Address'),
                            const SizedBox(height: 8),

                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: _buildGlassInputDecoration(
                                hintText: 'Enter your email',
                                prefixIcon: Icons.email_outlined,
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty) {
                                  return 'Please enter your email';
                                }

                                if (!RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                ).hasMatch(value.trim())) {
                                  return 'Enter a valid email address';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            // Password
                            _buildLabel('Password'),
                            const SizedBox(height: 8),

                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: _buildGlassInputDecoration(
                                hintText: 'Create a password',
                                prefixIcon: Icons.lock_outline,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword =
                                      !_obscurePassword;
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
                                  return 'Please create a password';
                                }

                                if (value.length < 6) {
                                  return 'Use at least 6 characters';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            // Confirm password
                            _buildLabel('Confirm Password'),
                            const SizedBox(height: 8),

                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: _buildGlassInputDecoration(
                                hintText: 'Re-enter your password',
                                prefixIcon: Icons.lock_reset_rounded,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }

                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 26),

                            // Red gradient register button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryRed.withValues(
                                        alpha: 0.90,
                                      ),
                                      const Color(0xFFB91C1C).withValues(
                                        alpha: 0.90,
                                      ),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withValues(
                                      alpha: 0.45,
                                    ),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryRed.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 14,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Registration UI ready. '
                                                'Authentication is not '
                                                'connected yet.',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Back to login
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(fontSize: 14),
                                    children: [
                                      TextSpan(
                                        text: 'Already have an account? ',
                                        style: TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Login',
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.2,
      ),
    );
  }

  InputDecoration _buildGlassInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.white54,
        fontSize: 14,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: Colors.white70,
        size: 20,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.15),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
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
        borderSide: const BorderSide(
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
