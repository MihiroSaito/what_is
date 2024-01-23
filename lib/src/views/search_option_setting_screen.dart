import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/components/animation.dart';
import 'package:what_is/src/components/history_list_item.dart';
import 'package:what_is/src/components/text_button.dart';
import 'package:what_is/src/utils/util.dart';

import '../../main.dart';
import '../components/confirm_delete_dialog_widget.dart';
import '../components/squishy_button.dart';
import '../config/theme.dart';
import '../routing/navigator.dart';


class SearchOptionSettingScreen extends HookConsumerWidget {
  const SearchOptionSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final sampleList = useState(['わかりやすく', '使い方']);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
      body: ReorderableListView.builder(
        proxyDecorator: proxyDecorator,
        padding: const EdgeInsets.only(top: 16.0),
        footer: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(40.0),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  print('vdsv');
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Theme.of(context).iconTheme.color!.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48.0),
                  child: const Text(
                    '追加',
                    style: TextStyle(
                      height: 1.0
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        itemBuilder: (_, index) {

          final item = sampleList.value[index];

          return ColoredBox(
            key: ValueKey('$index'),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 8.0, bottom: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.drag_indicator,
                    color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
                    size: 32.0,
                  ),
                  const SizedBox(width: 8.0,),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16.0
                      ),
                    ),
                  ),
                  SquishyButton(
                    disableWidget: const SizedBox.shrink(),
                    onTap: () {
                      sampleList.value = List.of(sampleList.value)..removeAt(index);
                      //TODO: DBのデータも消す
                    },
                    child: const Icon(
                      CupertinoIcons.minus_circle,
                      color: AppTheme.red,
                    ),
                  ),
                  const SizedBox(width: 8.0,),
                ],
              ),
            ),
          );
        },
        itemCount: sampleList.value.length,
        onReorder: (int oldIndex, int newIndex) {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          sampleList.value.insert(newIndex, sampleList.value.removeAt(oldIndex));
        },

        onReorderStart: (index) {
          HapticFeedback.heavyImpact();
        },
      ),
    );
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          elevation: 0,
          color: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }
}

