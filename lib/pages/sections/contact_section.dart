import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
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

  static const LatLng _centerLocation = LatLng(18.049194, 102.646194);
  static const String _googleMapsUrl =
      'https://maps.app.goo.gl/Jp7KoGinLauhTdBo7';

  TileProvider? _buildTileProvider() {
    if (!kIsWeb) {
      return null;
    }

    return CancellableNetworkTileProvider();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = ResponsiveHelper.isMobile(context);
    final contentWidth = ResponsiveHelper.getMaxContentWidth(context);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: screenHeight),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7FAFF), Color(0xFFEEF4FF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -80,
            child: _buildGlowOrb(
              size: 280,
              colors: const [Color(0xFF93C5FD), Color(0x0093C5FD)],
            ),
          ),
          Positioned(
            right: -120,
            top: 140,
            child: _buildGlowOrb(
              size: 340,
              colors: const [Color(0xFFF9A8D4), Color(0x00F9A8D4)],
            ),
          ),
          Positioned(
            bottom: -140,
            left: 120,
            child: _buildGlowOrb(
              size: 320,
              colors: const [Color(0xFF86EFAC), Color(0x0086EFAC)],
            ),
          ),
          SingleChildScrollView(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Column(
                  children: [
                    _buildHeader(context, isMobile),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        mobile: 28,
                        tablet: 36,
                        desktop: 44,
                      ),
                    ),
                    _buildContactCards(context, isMobile),
                    SizedBox(
                      height: ResponsiveHelper.getResponsiveSpacing(
                        context,
                        mobile: 24,
                        tablet: 30,
                        desktop: 36,
                      ),
                    ),
                    _buildMapSection(context, isMobile),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowOrb({required double size, required List<Color> colors}) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return AnimatedSection(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsiveSpacing(
            context,
            mobile: 24,
            tablet: 30,
            desktop: 36,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFBFDBFE).withValues(alpha: 0.7),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withValues(alpha: 0.08),
              blurRadius: 50,
              offset: const Offset(0, 24),
              spreadRadius: -18,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFDBEAFE), Color(0xFFE0F2FE)],
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'ຕິດຕໍ່ພວກເຮົາ',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 16,
                    tablet: 22,
                    desktop: 28,
                  ),
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1D4ED8),
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 18),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Text(
                'ພ້ອມຮັບຄຳຖາມ, ປຶກສາແຜນການຮຽນ ແລະ ຊ່ວຍເລືອກຊ່ອງທາງຕິດຕໍ່ທີ່ໄວທີ່ສຸດໃຫ້ທ່ານ. ເລືອກຊ່ອງທາງທີ່ສະດວກແລ້ວພວກເຮົາຈະຕອບກັບໂດຍໄວ.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(
                    context,
                    mobile: 15.5,
                    tablet: 17,
                    desktop: 18.5,
                  ),
                  color: const Color(0xFF475569),
                  height: 1.75,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 22),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: const [
                _ContactHighlightChip(
                  icon: Icons.schedule_rounded,
                  text: 'ຕອບກັບໄວ',
                ),
                _ContactHighlightChip(
                  icon: Icons.support_agent_rounded,
                  text: 'ໃຫ້ຄຳປຶກສາໄດ້',
                ),
                _ContactHighlightChip(
                  icon: Icons.location_city_rounded,
                  text: 'ມີແຜນທີ່ຊັດເຈນ',
                ),
              ],
            ),
            if (!isMobile) const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCards(BuildContext context, bool isMobile) {
    final contactCards = [
      {
        'icon': FontAwesomeIcons.whatsapp,
        'title': 'WhatsApp',
        'subtitle': 'ແຊັດໄດ້ທັນທີ',
        'info': '+856 20 55061124',
        'actionLabel': 'ເປີດແຊັດ WhatsApp',
        'color': const Color(0xFF22C55E),
        'accentColor': const Color(0xFF16A34A),
        'action': ContactHelper.openWhatsApp,
      },
      {
        'icon': FontAwesomeIcons.facebook,
        'title': 'Facebook',
        'subtitle': 'ຂ່າວສານ ແລະ ຂໍ້ມູນອັບເດດ',
        'info': 'PALEE ELITE Training Center',
        'actionLabel': 'ເຂົ້າເບິ່ງ Facebook Page',
        'color': const Color(0xFF2563EB),
        'accentColor': const Color(0xFF1D4ED8),
        'action': ContactHelper.openFacebook,
      },
      {
        'icon': Icons.email_rounded,
        'title': 'E-mail',
        'subtitle': 'ສົ່ງຂໍ້ຄວາມ',
        'info': 'juyapaly@gmail.com',
        'actionLabel': 'ຂຽນອີເມວຫາພວກເຮົາ',
        'color': const Color(0xFFF97316),
        'accentColor': const Color(0xFFEA580C),
        'action': ContactHelper.sendEmail,
      },
    ];

    return AnimatedSection(
      delay: const Duration(milliseconds: 150),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final cardWidth = isMobile
              ? availableWidth
              : (availableWidth - 24 * 2) / 3;

          return Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              for (final card in contactCards)
                SizedBox(
                  width: cardWidth,
                  child: ModernContactCard(
                    icon: card['icon'] as IconData,
                    title: card['title'] as String,
                    subtitle: card['subtitle'] as String,
                    info: card['info'] as String,
                    actionLabel: card['actionLabel'] as String,
                    color: card['color'] as Color,
                    accentColor: card['accentColor'] as Color,
                    onTap: card['action'] as VoidCallback,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMapSection(BuildContext context, bool isMobile) {
    return AnimatedSection(
      delay: const Duration(milliseconds: 300),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = isMobile || constraints.maxWidth < 980;

          if (stacked) {
            return _buildMapCanvas(context);
          }

          return _buildMapCanvas(context);
        },
      ),
    );
  }

  Widget _buildMapCanvas(BuildContext context) {
    return Container(
      height: ResponsiveHelper.getResponsiveSpacing(
        context,
        mobile: 320,
        tablet: 380,
        desktop: 430,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 40,
            offset: const Offset(0, 18),
            spreadRadius: -14,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: _centerLocation,
                initialZoom: 17.0,
                minZoom: 5.0,
                maxZoom: 19.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                  userAgentPackageName: 'com.example.app',
                  tileProvider: _buildTileProvider(),
                  maxZoom: 19,
                ),
                TileLayer(
                  urlTemplate:
                      'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}',
                  userAgentPackageName: 'com.example.app',
                  tileProvider: _buildTileProvider(),
                  maxZoom: 19,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _centerLocation,
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
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Text(
                              'ສູນປາລີບຳລຸງນັກຮຽນເກັ່ງ',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFFEF4444),
                            size: 50,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PALEE ELITE Training Center',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Vientiane Capital, Laos',
                      style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _openMaps,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.map_rounded,
                          size: 20,
                          color: Color(0xFF2563EB),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ເປີດນຳທາງໃນ Google Maps',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveFontSize(
                              context,
                              mobile: 12,
                              tablet: 12.5,
                              desktop: 13,
                            ),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2563EB),
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
    );
  }

  Future<void> _openMaps() async {
    final url = Uri.parse(_googleMapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

class _ContactHighlightChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactHighlightChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2563EB)),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
