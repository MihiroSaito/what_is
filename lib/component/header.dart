import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/component/squishy_button.dart';
import 'package:what_is/component/word_history.dart';

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
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: SquishyButton(
                      disableWidget: const SizedBox.shrink(),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const WordHistoryScreen(),
                            transitionDuration: const Duration(milliseconds: 150),
                            transitionsBuilder:
                                (context, animation, secondaryAnimation, child) {
                              return FadeTransition(child: child, opacity: animation);
                            },
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Icon(
                            CupertinoIcons.flowchart,
                            size: 24,
                            shadows: [
                              BoxShadow(
                                  color: Colors.white.withOpacity(0.25),
                                  blurRadius: 40,
                                  offset: const Offset(0.0, 0.0)
                              )
                            ],
                          ),
                          Transform.translate(
                            offset: const Offset(13, -10),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight,
                                  colors: [Color(0xFF00dbde), Color(0xFFfc00ff)],
                                  stops: [0.0, 1.0],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(width: 2.5, color: Theme.of(context).scaffoldBackgroundColor)
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
                    ),
                  ),
                const SizedBox(width: 16.0,),
                SquishyButton(
                  onTap: () {
                    //TODO: メニュー開く。（ライセンス表記、利用規約、プライバシーポリシー、課金？、履歴）
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
}
