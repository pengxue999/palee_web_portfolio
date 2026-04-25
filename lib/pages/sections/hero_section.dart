import 'package:flutter/material.dart';
import 'package:palee_web_portfolio/pages/register_page.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';
import 'package:palee_web_portfolio/widgets/animated_section.dart';
import 'package:palee_web_portfolio/widgets/typing_text.dart';

/// Hero section widget - the main landing section
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight,
      width: screenWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/images/ppp.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.2),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Gradient overlay for better text visibility
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          // Animated background shapes
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.15), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.15), Colors.transparent],
                ),
              ),
            ),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getHorizontalPadding(context),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    AnimatedSection(
                      delay: const Duration(milliseconds: 400),
                      child: TypingText(
                        text: 'ສູນປາລີບຳລຸງນັກຮຽນເກັ່ງ',
                        gradient: const LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.blueAccent,
                            Colors.lightBlueAccent,
                          ],
                        ),
                        speed: const Duration(milliseconds: 65),
                        pause: const Duration(milliseconds: 1500),
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            mobile: 26,
                            tablet: 30,
                            desktop: 40,
                          ),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    AnimatedSection(
                      delay: const Duration(milliseconds: 600),
                      child: TypingText(
                        text:
                            'ສູນປາລີບຳລຸງນັກຮຽນເກັ່ງຂອງພວກເຮົາ ມຸ່ງໝັ້ນພັດທະນາ ແລະ ສົ່ງເສີມໃຫ້ທ່ານກາຍເປັນນັກຮຽນເກັ່ງ ເພື່ອອະນາຄົດທີ່ສົດໃສ.',
                        speed: const Duration(milliseconds: 18),
                        pause: const Duration(milliseconds: 1800),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            mobile: 16,
                            tablet: 19,
                            desktop: 22,
                          ),
                          color: Colors.white,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.7),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    AnimatedSection(
                      delay: const Duration(milliseconds: 800),
                      child: Container(
                        padding: EdgeInsets.all(
                          ResponsiveHelper.getResponsiveSpacing(
                            context,
                            mobile: 20,
                            tablet: 25,
                            desktop: 30,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'ວິໄສທັດ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      mobile: 22,
                                      tablet: 25,
                                      desktop: 28,
                                    ),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.7),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'ສູນປາລີ ສູນຫຼໍ່ສ້າງ      ຄັງຄ່າພູມປັນຍາ\n'
                              'ພັດທະນາແນວຄິດ       ສ່ອງໃສຂະຫຍາຍແຈ້ງ\n'
                              'ເປັນດັ່ງໄຟເຍືອງໃຫ້       ໄຂທາງໃຫ້ຖືກປ້ອງ\n'
                              'ສ້າງຄ່າຄົນຄ່ອງເຂັ້ມ       ເຄັມແທ້ຊື່ວິຊາ',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelper.getResponsiveFontSize(
                                      context,
                                      mobile: 15,
                                      tablet: 17,
                                      desktop: 20,
                                    ),
                                color: Colors.white,
                                height: 1.8,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.7),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    AnimatedSection(
                      delay: const Duration(milliseconds: 1000),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              mobile: 32,
                              tablet: 40,
                              desktop: 48,
                            ),
                            vertical: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              mobile: 16,
                              tablet: 18,
                              desktop: 20,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(0.4),
                        ),
                        child: Text(
                          'ລົງທະບຽນ',
                          style: TextStyle(
                            fontSize:
                                ResponsiveHelper.getResponsiveFontSize(
                                  context,
                                  mobile: 16,
                                  tablet: 18,
                                  desktop: 20,
                                ),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
