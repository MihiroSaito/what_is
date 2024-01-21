import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/components/search_textfield.dart';
import 'package:what_is/src/routing/navigator.dart';


class ManualSearchController {

  static Future<void> show(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        enableDrag: true,
        useRootNavigator: true,
        isDismissible: true,
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        builder: (_) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
              },
              child: Consumer(
                  builder: (_, ref, __) {
                    return SearchTextField(
                      onSubmit: (text) {
                        Navigator.pop(context);
                        if (text.isNotEmpty) {
                          AppNavigator.toSearchView(ref, searchText: text);
                        }
                      },
                    );
                  }
              ),
            ),
          );
        }
    );
  }
}
