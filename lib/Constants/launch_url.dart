import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> webLaunch(String url) async{
  await launchUrlString(url);
}

Future<void> mailLaunch(String email) async{
  await launchUrl(Uri(scheme: 'mailto',path: email));
}

Future<void> callLaunch(String phone) async{
  await launchUrl(Uri(scheme: 'tel',path: phone));
}