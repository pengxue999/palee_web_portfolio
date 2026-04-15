import 'package:flutter/material.dart';
import 'package:palee_web_portfolio/auth/login_page.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';

/// Navigation bar widget for the home page
class AppNavigationBar extends StatelessWidget {
  final bool isScrolled;
  final VoidCallback onHomePressed;
  final VoidCallback onCoursesPressed;
  final VoidCallback onAchievementsPressed;
  final VoidCallback onAboutPressed;
  final VoidCallback onContactPressed;
  final VoidCallback onLoginPressed;
  final VoidCallback onMenuPressed;

  const AppNavigationBar({
    super.key,
    required this.isScrolled,
    required this.onHomePressed,
    required this.onCoursesPressed,
    required this.onAchievementsPressed,
    required this.onAboutPressed,
    required this.onContactPressed,
    required this.onLoginPressed,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.school, color: Colors.white, size: 40),
          onPressed: onHomePressed,
        ),
        Expanded(
          child: Text(
            'ສູນປາລີບຳລຸງນັກຮຽນເກັ່ງ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 14,
                tablet: 16,
                desktop: 18,
              ),
            ),
          ),
        ),
        if (isMobile)
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: onMenuPressed,
          )
        else ...[
          _buildNavButton(context, 'ໜ້າຫຼັກ', onHomePressed),
          _buildNavButton(context, 'ຫຼັກສູດ', onCoursesPressed),
          _buildNavButton(context, 'ຜົນງານ', onAchievementsPressed),
          _buildNavButton(context, 'ກ່ຽວກັບພວກເຮົາ', onAboutPressed),
          _buildNavButton(context, 'ຕິດຕໍ່', onContactPressed),
          const SizedBox(width: 16),
          _buildLoginButton(context),
          const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const LoginPage()),
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      child: Text(
        'ເຂົ້າສູ່ລະບົບ',
        style: TextStyle(
          color: Colors.black,
          fontSize: ResponsiveHelper.getResponsiveFontSize(
            context,
            mobile: 14,
            tablet: 15,
            desktop: 16,
          ),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Show mobile menu bottom sheet
  /// Show modern mobile menu bottom sheet
  static void showMobileMenu(
    BuildContext context, {
    required VoidCallback onHomePressed,
    required VoidCallback onCoursesPressed,
    required VoidCallback onAchievementsPressed,
    required VoidCallback onAboutPressed,
    required VoidCallback onContactPressed,
    required VoidCallback onLoginPressed,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Menu title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ເມນູ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: Colors.grey.shade200),

              // Menu items
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      _buildModernNavItem(
                        context,
                        icon: Icons.home_rounded,
                        text: 'ໜ້າຫຼັກ',
                        onPressed: onHomePressed,
                      ),
                      _buildModernNavItem(
                        context,
                        icon: Icons.school_rounded,
                        text: 'ຫຼັກສູດ',
                        onPressed: onCoursesPressed,
                      ),
                      _buildModernNavItem(
                        context,
                        icon: Icons.emoji_events_rounded,
                        text: 'ຜົນງານ',
                        onPressed: onAchievementsPressed,
                      ),
                      _buildModernNavItem(
                        context,
                        icon: Icons.info_rounded,
                        text: 'ກ່ຽວກັບພວກເຮົາ',
                        onPressed: onAboutPressed,
                      ),
                      _buildModernNavItem(
                        context,
                        icon: Icons.contact_mail_rounded,
                        text: 'ຕິດຕໍ່',
                        onPressed: onContactPressed,
                      ),
                    ],
                  ),
                ),
              ),

              // Login button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onLoginPressed();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login_rounded, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'ເຂົ້າສູ່ລະບົບ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
    );
  }

  static Widget _buildModernNavItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          onPressed();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.blue.shade700, size: 22),
              ),
              const SizedBox(width: 16),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
