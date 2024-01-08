import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what_is/main.dart';
import 'package:what_is/src/components/squishy_button.dart';
import 'package:what_is/src/config/theme.dart';
import 'package:what_is/src/routing/navigator.dart';

import '../config/const.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SquishyButton(
          disableWidget: const SizedBox.shrink(),
          onTap: () => AppNavigator().pop(),
          child: Icon(
            CupertinoIcons.chevron_back,
            color:  AppTheme.isDarkMode()
                ? Colors.white : accentColor,
            size: 28.0,
          ),
        ),
        title: Text(
          'アプリについて',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppTheme.isDarkMode()
                  ? Colors.white : accentColor
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _Item(label: 'お問い合わせ', onTap: () {
              //TODO: お問い合わせフォームへ
            }),
            _Item(label: 'アプリを評価する', onTap: () {
              //TODO: Storeへ遷移
            }),
            _Item(label: '利用規約', onTap: () {
              launchUrl(Uri.parse(AppConst.termUrl), mode: LaunchMode.externalApplication);
            }),
            _Item(label: 'プライバシーポリシー', onTap: () {
              launchUrl(Uri.parse(AppConst.privacyPolicy), mode: LaunchMode.externalApplication);
            }),
            _Item(label: 'ライセンス情報', onTap: () async {
              final info = await PackageInfo.fromPlatform();
              showLicensePage(
                context: context,
                applicationName: info.appName,
                applicationVersion: info.version,
                applicationIcon: SizedBox(
                    height: 72,
                    width: 72,
                    child: Image.asset('assets/images/icon_transparent_mini.png')),
              );
            }),
          ],
        ),
      ),
    );
  }
}



class _Item extends StatelessWidget {
  const _Item({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SquishyButton(
        disableWidget: const SizedBox.shrink(),
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
        onTap: () => onTap(),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Icon(
              CupertinoIcons.chevron_forward
            )
          ],
        ),
      ),
    );
  }
}

