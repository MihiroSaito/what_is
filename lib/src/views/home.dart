import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/main.dart';

import '../../logic/notifier.dart';
import '../components/header.dart';
import '../providers/web_pages_provider.dart';
import 'webivew.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  static final viewKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen(appLifecycleProvider, (previous, next) {

    });

    return Scaffold(
      key: viewKey,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(),
            Expanded(
              child: Navigator(
                onGenerateRoute: (_) {
                  return MaterialPageRoute(
                    builder: (pageContext) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 80.0,
                                offset: const Offset(0.0, 4.0)
                              )
                            ]
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F8FB),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              autofocus: true,
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: '知りたい言葉や概念は何ですか？',
                                hintStyle: TextStyle(
                                  color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5)
                                )
                              ),
                              cursorColor: accentColor,
                              onSubmitted: (text) {

                                Navigator.push(pageContext, MaterialPageRoute(builder: (_) {
                                  return const SearchViewWidget();
                                }));

                                ref.watch(webPagesProvider.notifier).add(
                                    parentTreeId: null,
                                    searchWord: text);

                              },
                            ),
                          ),
                        ),
                      );
                    }
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
