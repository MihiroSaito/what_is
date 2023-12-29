import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/component/header.dart';
import 'package:what_is/component/no_data.dart';
import 'package:what_is/logic/notifier.dart';
import 'package:what_is/theme.dart';
import 'package:what_is/component/webivew.dart';

import 'firebase_options.dart';
import 'logic/common_logic.dart';


Color accentColor = const Color(0xFF001AFF);


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final text = await getClipboardText();
  runApp(ProviderScope(child: App(text: text)));
}



class App extends StatelessWidget {
  const App({Key? key, required this.text}) : super(key: key);

  final String? text;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '〇〇とは？',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      supportedLocales: const [Locale('ja', 'JP')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      navigatorKey: navigatorKey,
      home: Home(initText: text,),
    );
  }
}


class Home extends HookConsumerWidget {
  const Home({super.key, required this.initText});

  /// アプリを起動した時に取得したテキスト
  final String? initText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final safeAreaPadding = MediaQuery.paddingOf(context);
    final newWord = ref.watch(newWordFromOutsideProvider);

    ref.listen(appLifecycleProvider, (previous, next) {
      if (previous == null) return; // previousに値がない = 初回起動 のため処理をスキップ
      final firstWord = ref.watch(wordHistoryProvider).firstOrNull; // 最初に検索したワードを取得
      if(next == AppLifecycleState.resumed){
        if (firstWord == null) return;
        Future(() async {
          final data = await Clipboard.getData(Clipboard.kTextPlain);
          final String? text = data?.text; // 現在のクリップボードにあるワードを取得
          ref.read(newWordFromOutsideProvider.notifier).state = text; // 取得した2つのワードが別のものだったらフラグを立てる
        });
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(initText: initText),
            if (initText != null || newWord != null) //
              Expanded(
                child: Navigator(
                    onGenerateRoute: (_) {
                      return MaterialPageRoute(
                          builder: (_) {
                            return AppWebViewPages(
                              firstPageWord: initText ?? newWord!,
                              safeAreaPadding: safeAreaPadding,
                            );
                          }
                      );
                    }
                ),
              )
            else
              const NoData(),
          ],
        ),
      ),
    );
  }
}
