import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/main.dart';
import 'package:what_is/src/components/search_textfield.dart';
import 'package:what_is/src/components/squishy_button.dart';
import 'package:what_is/src/config/theme.dart';
import 'package:what_is/src/controllers/manual_search_controller.dart';
import 'package:what_is/src/providers/app_lifecycle_provider.dart';
import 'package:what_is/src/routing/navigator.dart';
import 'package:what_is/src/utils/util.dart';

import '../components/app_header.dart';
import '../providers/web_pages_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static final viewKey = GlobalKey();

  static late BuildContext pageContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: viewKey,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: Navigator(onGenerateRoute: (_) => MaterialPageRoute(
                builder: (_pageContext) => GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    ManualSearchController.pop();
                  },
                  child: HookConsumer(
                    builder: (_, ref, __) {

                      pageContext = _pageContext;

                      final copyText = useState<String?>(null);

                      ref.listen(appLifecycleProvider, (previous, next) {
                        final pages = ref.read(webPagesProvider);
                        if (next == AppLifecycleState.resumed && pages.isEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) async {
                            final value = await getClipboardText();
                            if (value != null && copyText.value != value) {
                              copyText.value = value;
                              AppNavigator.toSearchView(ref, searchText: value);
                            }
                          });
                        }
                      });


                      return SizedBox();
                    }
                  ),
                )
              )),
            )
          ],
        ),
      ),
    );
  }
}
