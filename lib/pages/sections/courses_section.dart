import 'package:flutter/material.dart';
import 'package:palee_web_portfolio/data/course_data.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';
import 'package:palee_web_portfolio/widgets/animated_section.dart';
import 'package:palee_web_portfolio/widgets/course_card.dart';
import 'package:palee_web_portfolio/widgets/section_header.dart';

/// Courses section widget displaying available courses
class CoursesSection extends StatelessWidget {
  const CoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(minHeight: screenHeight * 0.9),
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        children: [
          // Header Section
          SectionHeader(
            title: 'ຫຼັກສູດຂອງພວກເຮົາ',
            subtitle: 'ເປັນຫຼັກສູດໄລຍະສັ້ນຊ່ວງພັກແລ້ງ (3 ເດືອນ)',
          ),
          SizedBox(
            height: ResponsiveHelper.getResponsiveSpacing(
              context,
              mobile: 20,
              tablet: 30,
              desktop: 40,
            ),
          ),
          // Courses Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = ResponsiveHelper.isMobile(context);
              final isTablet = ResponsiveHelper.isTablet(context);

              return Wrap(
                spacing: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 16,
                  tablet: 20,
                  desktop: 24,
                ),
                runSpacing: ResponsiveHelper.getResponsiveSpacing(
                  context,
                  mobile: 16,
                  tablet: 20,
                  desktop: 24,
                ),
                alignment: WrapAlignment.center,
                children: List.generate(courses.length, (index) {
                  final course = courses[index];
                  final cardWidth = isMobile
                      ? constraints.maxWidth
                      : (isTablet ? (constraints.maxWidth - 20) / 2 : 280.0);

                  return AnimatedSection(
                    delay: Duration(milliseconds: 200 + (index * 100)),
                    child: CourseCard(course: course, width: cardWidth),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
