import 'package:flutter/material.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';
import 'package:palee_web_portfolio/widgets/animated_section.dart';
import 'package:palee_web_portfolio/widgets/info_row.dart';

/// About Us section widget
class AboutUsSection extends StatelessWidget {
  const AboutUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),

      child: Column(
        children: [
          // Header Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey.shade400, width: 1),
            ),
            child: Text(
              'ກ່ຽວກັບພວກເຮົາ',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 14,
                  tablet: 15,
                  desktop: 16,
                ),
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade800,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Main Title
          AnimatedSection(
            child: Text(
              'ສູນປາລີບຳລຸງນັກຮຽນເກັ່ງ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 26,
                  tablet: 30,
                  desktop: 40,
                ),
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Decorative Line
          AnimatedSection(
            delay: const Duration(milliseconds: 200),
            child: Container(
              width: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 60,
                tablet: 80,
                desktop: 100,
              ),
              height: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade300,
                    Colors.blue.shade500,
                    Colors.blue.shade700,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 30,
              tablet: 40,
              desktop: 50,
            ),
          ),
          // Main Content
          AnimatedSection(
            delay: const Duration(milliseconds: 400),
            child: isMobile
                ? _buildMobileLayout(context)
                : _buildDesktopLayout(context, isTablet),
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 20,
              tablet: 20,
              desktop: 20,
            ),
          ),
          // statistics moved to AchievementsSection for better separation of concerns
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Image Card
        Container(
          margin: const EdgeInsets.only(bottom: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, 15),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/ppp.jpg",
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                ),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoRow(
                          icon: Icons.location_on,
                          text: 'ບ້ານ ໜອງວຽງຄຳ, ເມືອງໄຊທານີ',
                        ),
                        const SizedBox(height: 8),
                        InfoRow(
                          icon: Icons.calendar_today,
                          text: 'ສ້າງຕັ້ງເມື່ອ 10 ພຶດສະພາ 2015',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildContentColumn(context, true),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: isTablet ? 4 : 5,
          child: Container(
            height: isTablet ? 400 : 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.25),
                  blurRadius: 35,
                  offset: const Offset(0, 20),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      "assets/images/ppp.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.9),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoRow(
                            icon: Icons.location_on,
                            text: 'ບ້ານ ໜອງວຽງຄຳ, ເມືອງໄຊທານີ, ນະຄອນຫຼວງວຽງຈັນ',
                          ),
                          const SizedBox(height: 12),
                          InfoRow(
                            icon: Icons.calendar_today,
                            text: 'ສ້າງຕັ້ງເມື່ອ 10 ພຶດສະພາ ປີ 2015',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 20,
            tablet: 30,
            desktop: 50,
          ),
        ),
        Expanded(
          flex: isTablet ? 5 : 6,
          child: _buildContentColumn(context, false),
        ),
      ],
    );
  }

  Widget _buildContentColumn(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ສູນປາລີບຳລຸງນັກຮຽນເກັ່ງສ້າງຕັ້ງຂື້ນເມື່ອ ວັນທີ 10 ພຶດສະພາ ປີ 2015 ຕັ້ງຢູ່ບ້ານໜອງວຽງຄຳ, ເມືອງໄຊທານີ, ນະຄອນຫຼວງວຽງຈັນ. ສູນຂອງພວກເຮົາແມ່ນສູນຝຶກອົບຮົມທີ່ສຸມໃສ່ການບຳລຸງ ແລະ ພັດທະນານັກຮຽນເກັ່ງໃນວິຊາ ຄະນິດສາດ, ຟີຊິກ, ເຄມີ ແລະ ທັກສະດ້ານພາສາຕ່າງປະເທດ ໂດຍສະເພາະພາສາອັງກິດ ແລະ ພາສາຈີນ.',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 15,
              tablet: 16,
              desktop: 17,
            ),
            color: Colors.grey.shade700,
            height: 1.8,
          ),
        ),
        SizedBox(
          height: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 10,
            tablet: 15,
            desktop: 20,
          ),
        ),
        Text(
          'ດ້ວຍທີມງານຄູອາຈານທີ່ມີປະສົບການ, ວິທີການສອນທີ່ທັນສະໄໝ, ສື່ການສອນທີ່ຫຼາກຫຼາຍ ແລະ ຄູອາຈານສ່ວນຫຼາຍແມ່ນອະດີດນັກຮຽນເກັ່ງລະດັບຊາດຈົບຈາກພາຍໃນ-ຕ່າງປະເທດ.',
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 15,
              tablet: 16,
              desktop: 17,
            ),
            color: Colors.grey.shade700,
            height: 1.8,
          ),
        ),
        SizedBox(
          height: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 25,
            tablet: 30,
            desktop: 35,
          ),
        ),
        _buildPolicySection(context, isMobile),
        SizedBox(
          height: ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 30,
            tablet: 40,
            desktop: 50,
          ),
        ),
      ],
    );
  }

  Widget _buildPolicySection(BuildContext context, bool isMobile) {
    final policies = [
      'ສູນປາລີມີທຶນຮຽນຫຼາຍກວ່າ 10 ທຶນ ສຳລັບນັກຮຽນທຸກຍາກໃນທຸກໆປີ ແລະ ຍັງມີອາຫານຟຼີສຳລັບນັກຮຽນທີ່ມາພັກເຊົາທີ່ຫໍພັກໃນຂອງສູນ',
      'ສູນປາລີຊ່ວຍຊອກທຶນການສຶກສາໄປຮຽນຕໍ່ຕ່າງປະເທດເຊັ່ນ: ຈີນ ແລະ ໄຕ້ຫວັນ',
      'ສູນປາລີມີລາງວັນສຳລັບນັກຮຽນດີເດັ່ນທີ່ສາມາດສອບເສັງໄດ້ອັນທີ1,2,3 ແລະ ຊົມເຊີຍ',
      'ສອນທັກສະການສະແຫວງຫາຄວາມຮູ້, ການແກ້ໂຈດທີ່ວ່ອງໄວ ແລະ ສັ້ນທີ່ສດ, ສ້າງໃຫ້ນັກຮຽນມີ່ຄວາມຮູ້ຮອບຕົວ ແລະ ຄວາມສາມາດພິເສດ',
    ];

    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsiveSpacing(
          context,
          mobile: 20,
          tablet: 22,
          desktop: 24,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: Colors.blue.shade700,
                size: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 22,
                  tablet: 23,
                  desktop: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'ນະໂຍບາຍ',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 18,
                    tablet: 19,
                    desktop: 20,
                  ),
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...policies.map((policy) => _buildPolicyItem(context, policy)),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(BuildContext context, String text) {
    final isMobile = ResponsiveHelper.isMobile(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✓',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 16,
                tablet: 17,
                desktop: 18,
              ),
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 14,
                  tablet: 15,
                  desktop: 16,
                ),
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
