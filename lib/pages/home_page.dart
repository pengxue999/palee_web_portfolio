import 'package:flutter/material.dart';
import 'package:palee_web_portfolio/pages/sections/about_us_section.dart';
import 'package:palee_web_portfolio/pages/sections/achievements_section.dart';
import 'package:palee_web_portfolio/pages/sections/contact_section.dart';
import 'package:palee_web_portfolio/pages/sections/courses_section.dart';
import 'package:palee_web_portfolio/pages/sections/footer_section.dart';
import 'package:palee_web_portfolio/pages/sections/hero_section.dart';
import 'package:palee_web_portfolio/widgets/navigation_bar.dart'
    show AppNavigationBar;

/// Main home page widget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _coursesKey = GlobalKey();
  final GlobalKey _achievementsKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _isScrolled = _scrollController.offset > 50;
    });
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Navigation Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: _isScrolled ? Colors.white : Colors.transparent,
            elevation: _isScrolled ? 4 : 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                ),
              ),
              child: SafeArea(
                child: AppNavigationBar(
                  isScrolled: _isScrolled,
                  onHomePressed: () => _scrollToSection(_homeKey),
                  onCoursesPressed: () => _scrollToSection(_coursesKey),
                  onAchievementsPressed: () =>
                      _scrollToSection(_achievementsKey),
                  onAboutPressed: () => _scrollToSection(_aboutKey),
                  onContactPressed: () => _scrollToSection(_contactKey),
                  onMenuPressed: () => AppNavigationBar.showMobileMenu(
                    context,
                    onHomePressed: () => _scrollToSection(_homeKey),
                    onCoursesPressed: () => _scrollToSection(_coursesKey),
                    onAchievementsPressed: () =>
                        _scrollToSection(_achievementsKey),
                    onAboutPressed: () => _scrollToSection(_aboutKey),
                    onContactPressed: () => _scrollToSection(_contactKey),
                  ),
                ),
              ),
            ),
          ),

          // Hero Section
          SliverToBoxAdapter(key: _homeKey, child: const HeroSection()),

          // Courses Section
          SliverToBoxAdapter(key: _coursesKey, child: const CoursesSection()),

          // Achievements Section
          SliverToBoxAdapter(
            key: _achievementsKey,
            child: const AchievementsSection(),
          ),

          // About Section
          SliverToBoxAdapter(key: _aboutKey, child: const AboutUsSection()),

          // Contact Section
          SliverToBoxAdapter(key: _contactKey, child: const ContactSection()),

          // Footer
          const SliverToBoxAdapter(child: FooterSection()),
        ],
      ),
    );
  }
}
