import 'package:url_launcher/url_launcher.dart';

Future<void> openExternalUrl(String urlString) async {
  final url = Uri.tryParse(urlString);
  if (url == null) return;
  
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
