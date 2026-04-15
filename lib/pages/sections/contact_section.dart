import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:palee_web_portfolio/utils/contact_helper.dart';
import 'package:palee_web_portfolio/utils/responsive_helper.dart';
import 'package:palee_web_portfolio/widgets/animated_section.dart';
import 'package:palee_web_portfolio/widgets/modern_contact_card.dart';

/// Contact section widget with contact cards and map
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: screenHeight),
      child: SingleChildScrollView(
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Column(
          children: [
            // Header
            _buildHeader(context, isMobile, isTablet),
            SizedBox(
              height: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 20,
                tablet: 30,
                desktop: 40,
              ),
            ),
            // Contact Cards
            _buildContactCards(context, isMobile),
            SizedBox(
              height: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 20,
                tablet: 30,
                desktop: 40,
              ),
            ),
            // Map Section
            _buildMapSection(context, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, bool isTablet) {
    return AnimatedSection(
      child: Column(
        children: [
          Text(
            'ຕິດຕໍ່ພວກເຮົາ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 26,
                tablet: 30,
                desktop: 40,
              ),
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'ພ້ອມທີ່ຈະໃຫ້ຄຳປຶກສາ ແລະ ຊ່ວຍເຫຼືອທ່ານທຸກເວລາ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 16,
                  tablet: 17,
                  desktop: 18,
                ),
                color: const Color(0xFF64748b),
                height: 1.7,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCards(BuildContext context, bool isMobile) {
    final contactCards = [
      {
        'icon': FontAwesomeIcons.whatsapp,
        'title': 'WhatsApp',
        'info': '+856 20 55061124',
        'color': Colors.greenAccent.shade400,
        'accentColor': Colors.greenAccent.shade400,
        'action': ContactHelper.openWhatsApp,
      },
      {
        'icon': FontAwesomeIcons.facebook,
        'title': 'Facebook',
        'info': 'PALEE ELITE Training Center',
        'color': Colors.blue.shade900,
        'accentColor': Colors.blue.shade900,
        'action': ContactHelper.openFacebook,
      },
      {
        'icon': Icons.email_rounded,
        'title': 'E-mail',
        'info': 'juyapaly@gmail.com',
        'color': Colors.purple.shade200,
        'accentColor': Colors.purple.shade200,
        'action': ContactHelper.sendEmail,
      },
    ];

    return AnimatedSection(
      delay: const Duration(milliseconds: 150),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (isMobile) {
            return Column(
              children: [
                for (var card in contactCards) ...[
                  ModernContactCard(
                    icon: card['icon'] as IconData,
                    title: card['title'] as String,
                    info: card['info'] as String,
                    color: card['color'] as Color,
                    accentColor: card['accentColor'] as Color,
                    onTap: card['action'] as VoidCallback,
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            );
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var card in contactCards) ...[
                  Expanded(
                    child: ModernContactCard(
                      icon: card['icon'] as IconData,
                      title: card['title'] as String,
                      info: card['info'] as String,
                      color: card['color'] as Color,
                      accentColor: card['accentColor'] as Color,
                      onTap: card['action'] as VoidCallback,
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildMapSection(BuildContext context, bool isMobile) {
    return AnimatedSection(
      delay: const Duration(milliseconds: 300),
      child: Container(
        //constraints: const BoxConstraints(maxWidth: 1000),
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 24,
            tablet: 28,
            desktop: 32,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.06), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.08),
              blurRadius: 60,
              offset: const Offset(0, 20),
              spreadRadius: -10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'ສະຖານທີ່ຕັ້ງຂອງພວກເຮົາ',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1a1a2e),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Map Container
            Container(
              height: ResponsiveHelper.getResponsiveSpacing(
                context,
                mobile: 300,
                tablet: 350,
                desktop: 400,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black.withOpacity(0.06),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667eea).withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter: const LatLng(18.049194, 102.646194),
                        initialZoom: 17.0,
                        minZoom: 5.0,
                        maxZoom: 19.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                          userAgentPackageName: 'com.example.app',
                          maxZoom: 19,
                        ),
                        TileLayer(
                          urlTemplate:
                              'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}',
                          userAgentPackageName: 'com.example.app',
                          maxZoom: 19,
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: const LatLng(18.049194, 102.646194),
                              width: 220,
                              height: 120,
                              alignment: Alignment.topCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'ສູນປາລີບຳລຸງນັກຮຽນເກັ່ງ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Open in Google Maps button
                    Positioned(
                      top: 16,
                      right: 16,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            final url = Uri.parse(
                              'https://maps.app.goo.gl/Jp7KoGinLauhTdBo7',
                            );
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.map_rounded,
                                  size: 20,
                                  color: Colors.blue.shade400,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Google Maps',
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.getResponsiveFontSize(
                                          context,
                                          mobile: 12,
                                          tablet: 12.5,
                                          desktop: 13,
                                        ),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue.shade400,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'ບ້ານ ໜອງວຽງຄຳ, ເມືອງໄຊທານີ, ນະຄອນຫຼວງວຽງຈັນ',
              style: TextStyle(
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 15,
                  tablet: 16,
                  desktop: 17,
                ),
                color: const Color(0xFF1a1a2e),
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
