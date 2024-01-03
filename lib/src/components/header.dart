import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what_is/src/components/animation.dart';
import 'package:what_is/src/components/squishy_button.dart';
import 'package:what_is/src/providers/device_size_provider.dart';

import '../config/const.dart';
import '../config/theme.dart';

class AppHeader extends HookConsumerWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            child: Row(
              children: [
                SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: Image.asset('assets/images/icon_transparent_mini.png')
                ),
                const Spacer(),
                SquishyButton(
                  onTap: () {
                    _showMenu(context, ref.watch(safeAreaPaddingProvider).top);
                  },
                  disableWidget: const SizedBox.shrink(),
                  child: const Icon(
                    CupertinoIcons.ellipsis_circle,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1.0,
          width: double.infinity,
          color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.15),
        ),
      ],
    );
  }


  void _showMenu(BuildContext context, double safeAreaPaddingTop) {
    showDialog(useSafeArea: false, context: context, builder: (_) {
      return AppAnimation.scale(
        alignment: Alignment.topRight,
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: () => Navigator.pop(context),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 208,
              margin: EdgeInsets.only(top: safeAreaPaddingTop + 48, right: 8.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(4.0),
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8.0,
                    offset: const Offset(0.0, 4.0)
                  )
                ],
                color: AppTheme.isDarkMode()? const Color(0xFF222222) : Colors.white
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 2.0,),
                  _item(context,
                      label: '検索履歴',
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14.0),
                        topRight: Radius.circular(2.0),
                      ),
                      onTap: () {
                        //TODO: 検索履歴を表示する。
                      }
                  ),
                  _line(context, bold: true),
                  _item(context, label: 'お問い合わせ',
                      onTap: () {
                        //TODO: お問い合わせフォームへ
                      }),
                  _line(context),
                  _item(context, label: 'アプリを評価する',
                      onTap: () {
                        //TODO: Storeへ遷移
                      }),
                  _line(context),
                  _item(context, label: '利用規約',
                      onTap: () {
                        launchUrl(Uri.parse(AppConst.termUrl), mode: LaunchMode.externalApplication);
                        Navigator.pop(context);
                      }),
                  _line(context),
                  _item(context, label: 'プライバシーポリシー',
                      onTap: () {
                        launchUrl(Uri.parse(AppConst.privacyPolicy), mode: LaunchMode.externalApplication);
                        Navigator.pop(context);
                      }),
                  _line(context),
                  _item(context,
                      label: 'ライセンス情報',
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(14.0),
                        bottomLeft: Radius.circular(14.0),
                      ),
                      onTap: () async {
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
                      }
                  ),
                  const SizedBox(height: 2.0,),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _item(BuildContext context, {
    required String label,
    BorderRadius borderRadius = BorderRadius.zero,
    required VoidCallback onTap
  }) {
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14.0),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  fontSize: 15.0,
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8)
                ),
                strutStyle: const StrutStyle(
                  height: 1.2
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _line(BuildContext context, {bool bold = false}) {
    return SizedBox(
      width: double.infinity,
      height: bold? 4.0 : 1.0,
      child: ColoredBox(
        color: AppTheme.isDarkMode()
            ? Colors.white.withOpacity(bold? 0.08 : 0.05)
            : Colors.black.withOpacity(bold? 0.08 : 0.05),
      ),
    );
  }
}
