import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/logic/common_logic.dart';
import 'package:what_is/logic/word_history.dart';
import 'package:what_is/theme.dart';

import '../logic/notifier.dart';

class NoData extends HookConsumerWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen(appLifecycleProvider, (previous, next) {
      if (next != AppLifecycleState.resumed) return;
      Future(() async {
        final text = await getClipboardText();
        if (text == null) return;
        ref.read(newWordFromOutsideProvider.notifier).state = text;
        ref.read(wordHistoryProvider.notifier).add(WordHistory(word: text, url: createUrl(text).toString()));
      });
    });

    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                '使い方',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6),
                ),
              ),
            ),
            ...section1(context),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Center(
                child: Icon(
                  CupertinoIcons.arrow_down,
                  size: MediaQuery.of(context).size.width * 0.15,
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.2),
                ),
              ),
            ),
            ...section2(context),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 24.0,)
          ],
        ),
      ),
    );
  }


  List<Widget> section1(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          '1. 別アプリで検索したいワードをコピー。',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              backgroundColor: Colors.yellow,
              fontStyle: FontStyle.italic,
              color: AppTheme.isDarkMode()? const Color(0xFF333333) : null
          ),
        ),
      ),
      Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          child: AppTheme.isDarkMode()
              ? Image.asset('assets/images/explain_copy_dark.png')
              : Image.asset('assets/images/explain_copy.png'),
        ),
      ),
    ];
  }


  List<Widget> section2(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 0, top: 24.0),
        child: Text(
          '2. アプリを開く。',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              backgroundColor: Colors.yellow,
              fontStyle: FontStyle.italic,
              color: AppTheme.isDarkMode()? const Color(0xFF333333) : null,
          ),
        ),
      ),
      Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: AppTheme.isDarkMode()
              ? Image.asset('assets/images/explain_tap_icon_dark.png')
              : Image.asset('assets/images/explain_tap_icon.png'),
        ),
      ),
    ];
  }
}
