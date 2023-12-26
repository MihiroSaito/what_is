import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/logic/common_logic.dart';

import '../logic/notifier.dart';

class NoData extends HookConsumerWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen(appLifecycleProvider, (previous, next) {
      if (next != AppLifecycleState.resumed) return;
      Future(() async {
        final text = await getClipboardText();
        ref.read(newWordFromOutsideProvider.notifier).state = text;
      });
    });

    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: MediaQuery.of(context).size.width * 0.3,
              color: Colors.blueGrey,
            ),
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                '別のアプリで検索したいワードを\nコピーしてください',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom,)
          ],
        ),
      ),
    );
  }
}
