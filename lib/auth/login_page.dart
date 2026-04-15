import 'package:flutter/material.dart';
import 'package:palee_web_portfolio/widgets/gradient_text.dart';
import 'package:palee_web_portfolio/widgets/app_text_field.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';
import 'package:palee_web_portfolio/pages/teacher_tracking_page.dart';
import 'package:palee_web_portfolio/auth/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'ກະລຸນາປ້ອນເບີໂທ';
    }
    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
    // Check if it's a valid phone number (at least 8 digits)
    if (cleaned.length < 8 || !RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'ເບີໂທບໍ່ຖືກຕ້ອງ';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'ກະລຸນາປ້ອນລະຫັດຜ່ານ';
    }
    if (value.length < 6) {
      return 'ລະຫັດຜ່ານຕ້ອງມີຢ່າງໜ້ອຍ 6 ຕົວອັກສອນ';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate to teacher tracking page after successful login
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const TeacherTrackingPage()));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ເຂົ້າສູ່ລະບົບສຳເລັດ'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use ResponsiveHelper for breakpoint checks
    final isMobile = ResponsiveHelper.isMobile(context);

    // Get responsive values
    final padding = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: 24.0,
      tablet: 32.0,
      desktop: 40.0,
    );

    final cardPadding = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: 10.0,
      tablet: 40.0,
      desktop: 48.0,
    );

    final titleFontSize = ResponsiveHelper.getResponsiveFontSize(
      context,
      mobile: 20,
      tablet: 28,
      desktop: 36,
    );

    final subtitleFontSize = ResponsiveHelper.getResponsiveFontSize(
      context,
      mobile: 13,
      tablet: 14,
      desktop: 15,
    );

    final iconSize = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: 40,
      tablet: 48,
      desktop: 48,
    );

    final buttonHeight = ResponsiveHelper.getResponsiveSpacing(
      context,
      mobile: 55,
      tablet: 58,
      desktop: 60,
    );

    final buttonFontSize = ResponsiveHelper.getResponsiveFontSize(
      context,
      mobile: 16,
      tablet: 18,
      desktop: 18,
    );

    return Scaffold(
      body: Container(
        decoration: isMobile
            ? BoxDecoration(color: Colors.white)
            : BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/palee_bg.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.1),
                    BlendMode.darken,
                  ),
                ),
              ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isMobile ? double.infinity : 450,
                    ),
                    child: Card(
                      elevation: isMobile ? 0 : 20,
                      shape: isMobile
                          ? null
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                      color: isMobile ? Colors.transparent : Colors.white,
                      child: Container(
                        padding: EdgeInsets.all(cardPadding),
                        decoration: isMobile
                            ? BoxDecoration(color: Colors.transparent)
                            : BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                              ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Logo/Icon
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade600,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.school,
                                  size: iconSize,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  mobile: 20,
                                  tablet: 24,
                                  desktop: 28,
                                ),
                              ),

                              // Title
                              Text(
                                'ເຂົ້າສູ່ລະບົບ',
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'ກະລຸນາປ້ອນຂໍ້ມູນເພື່ອເຂົ້າສູ່ລະບົບ',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: subtitleFontSize,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  mobile: 28,
                                  tablet: 32,
                                  desktop: 36,
                                ),
                              ),

                              // Phone Number Field
                              AppTextField(
                                controller: _phoneController,
                                labelText: 'ຊື່ຜູ້ໃຊ້',
                                hintText: 'ປ້ອນຊື່ຜູ້ໃຊ້',
                                prefixIcon: Icons.person,
                                keyboardType: TextInputType.text,
                                validator: _validatePhone,
                              ),
                              SizedBox(
                                height: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  mobile: 16,
                                  tablet: 20,
                                  desktop: 20,
                                ),
                              ),

                              // Password Field
                              AppTextField(
                                controller: _passwordController,
                                labelText: 'ລະຫັດຜ່ານ',
                                hintText: '••••••••',
                                prefixIcon: Icons.lock,
                                obscureText: _obscurePassword,
                                validator: _validatePassword,
                                onToggleObscure: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),

                              SizedBox(
                                height: ResponsiveHelper.getResponsiveSpacing(
                                  context,
                                  mobile: 20,
                                  tablet: 24,
                                  desktop: 28,
                                ),
                              ),

                              // Login Button
                              Container(
                                width: double.infinity,
                                height: buttonHeight,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade700,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.shade300.withOpacity(
                                        0.5,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : Text(
                                          'ເຂົ້າສູ່ລະບົບ',
                                          style: TextStyle(
                                            fontSize: buttonFontSize,
                                            fontWeight: FontWeight.bold,
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
