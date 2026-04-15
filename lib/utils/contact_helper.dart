import 'package:url_launcher/url_launcher.dart';

class ContactHelper {
  static Future<void> openWhatsApp() async {
    final Uri url = Uri.parse(
      'https://api.whatsapp.com/send?phone=8562055061124',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> openFacebook() async {
    final Uri url = Uri.parse(
      'https://www.facebook.com/profile.php?id=100063468703990', // change to your real page URL
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> sendEmail() async {
    final Uri url = Uri(
      scheme: 'mailto',
      path: 'juyapaly@gmail.com',
      query: 'subject=Contact PALEE ELITE',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
