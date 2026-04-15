import 'package:flutter/material.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';
import 'package:palee_web_portfolio/widgets/animated_section.dart';
import 'package:palee_web_portfolio/widgets/stat_item.dart';

/// Achievements section widget displaying statistics
class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Achievements section uses white background for better contrast with stats
      padding: ResponsiveHelper.getResponsivePadding(context),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSection(
            child: Text(
              'ຜົນງານຂອງພວກເຮົາ',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 26,
                  tablet: 30,
                  desktop: 40,
                ),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedSection(
            delay: const Duration(milliseconds: 200),
            child: Container(
              width: 80,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.08),
                borderRadius: BorderRadius.circular(2),
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
          _buildStatistics(context),
        ],
      ),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final years = DateTime.now().year - 2015;
    final stats = [
      {'number': '$years ປີ', 'label': 'ປະສົບການ'},
      {'number': '10+', 'label': 'ມີທຶນຮຽນຟຣີແຕ່ລະປີ'},
      {
        'number': '80+',
        'label': 'ນັກຮຽນເກັ່ງຂອງສູນທີ່ຜ່ານຂັ້ນເມືອງ, ແຂວງ, ແລະ ລະດັບຊາດ',
      },
      {'number': '20+', 'label': 'ນັກຮຽນໄປຮຽນຕໍ່ຕ່າງປະເທດ'},
    ];

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(context),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade400, Colors.blue.shade700],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              children: [
                for (int i = 0; i < stats.length; i++) ...[
                  StatItem(
                    number: stats[i]['number']!,
                    label: stats[i]['label']!,
                    textColor: Colors.white,
                  ),
                  if (i < stats.length - 1)
                    const Divider(color: Colors.white24, height: 20),
                ],
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < stats.length; i++) ...[
                  StatItem(
                    number: stats[i]['number']!,
                    label: stats[i]['label']!,
                    textColor: Colors.white,
                  ),
                  if (i < stats.length - 1)
                    Container(height: 80, width: 1, color: Colors.white24),
                ],
              ],
            ),
    );
  }
}
