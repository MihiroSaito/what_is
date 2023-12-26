import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/component/squishy_button.dart';

import '../logic/common_logic.dart';
import '../logic/notifier.dart';
import '../logic/word_history.dart';

class AppHeader extends HookConsumerWidget {
  const AppHeader({super.key, required this.initText});
  final String? initText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final history = ref.watch(wordHistoryProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_){
        if (initText != null) {
          ref.watch(wordHistoryProvider.notifier).add(
              WordHistory(
                  word: initText!,
                  url: createUrl(initText!).toString()));
        }
      });
      return;
    }, const []);

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
                if (history.length > 1)
                  SquishyButton(
                    disableWidget: const SizedBox.shrink(),
                    onTap: () {

                    },
                    child: Stack(
                      children: [
                        Icon(
                          CupertinoIcons.flowchart,
                          size: 28,
                          shadows: [
                            BoxShadow(
                                color: Colors.white.withOpacity(0.25),
                                blurRadius: 40,
                                offset: const Offset(0.0, 0.0)
                            )
                          ],
                        ),
                        Transform.translate(
                          offset: const Offset(16, -8),
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF17B71E),
                                border: Border.all(width: 1.5, color: Colors.white)
                            ),
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              '${history.length - 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
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
}
