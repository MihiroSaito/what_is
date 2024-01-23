import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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


class HistoryScreen extends HookConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final searchText = useState("");
    final SwipeActionController swipeActionController = SwipeActionController();

    final isEditing = useState(false);
    final selectingItem = useState([]);

    final sampleHistory = useState([ //TODO: ちゃんとする。
      (title: 'マイクロサービスアーキテクチャ', subText: '今日 - 23:20'),
      (title: 'PDCA', subText: '昨日 - 23:20'),
      (title: 'クロスプラットフォーム', subText: '1月19日 - 23:20'),
      (title: 'アジェンダ', subText: '1月19日 - 23:10'),
      (title: 'マインドフルネス', subText: '2023年12月31日 - 10:20'),
    ]);

    final safeAreaPadding = MediaQuery.of(context).padding;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
          titleSpacing: 0.0,
          title: Container(
            height: 40.0,
            width: double.infinity,
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: isDarkMode
                  ? AppTheme.darkColor2 : const Color(0xFFEFF2F8),
            ),
            padding: const EdgeInsets.only(left: 8.0),
            child: Center(
              child: Stack(
                children: [
                  if (searchText.value.isEmpty)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.search,
                            size: 18.0,
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.3)
                                : const Color(0xFFB5B9C0),
                          ),
                          const SizedBox(width: 4.0,),
                          Text(
                            '検索',
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.3)
                                  : const Color(0xFFB5B9C0),
                              fontSize: 15.0
                            ),
                          )
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardAppearance: AppTheme.isDarkMode()
                          ? Brightness.dark : Brightness.light,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color
                      ),
                      cursorHeight: 20.0,
                      cursorColor: accentColor,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onChanged: (value) => searchText.value = value,
                      onSubmitted: (value) {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                isEditing.value = !isEditing.value;
                selectingItem.value = [];
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  isEditing.value
                      ? '完了' : '編集',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: isEditing.value? FontWeight.bold : null,
                      color: isEditing.value && !isDarkMode? accentColor : Theme.of(context).textTheme.bodyMedium!.color
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0,)
          ],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: Border(
            bottom: BorderSide(
              color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.15),
              width: 1,
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: sampleHistory.value.length,
              padding: const EdgeInsets.only(top: 8.0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (_, index) {

                final item = sampleHistory.value[index];
                final isSelecting = selectingItem.value.contains(item);

                return GestureDetector(
                  onTap: () {
                    if (isSelecting) {
                      selectingItem.value = List.of(selectingItem.value)..remove(item);
                    } else {
                      selectingItem.value = [...selectingItem.value, item];
                    }
                  },
                  child: ColoredBox(
                    color: isEditing.value && isSelecting
                        ? accentColor.withOpacity(0.1)
                        : Colors.transparent,
                    child: Row(
                      children: [
                        AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          child: SizedBox(
                              width: isEditing.value? 32.0 : 0,
                            child: isEditing.value? AppAnimation.fadeIn(
                              duration: const Duration(milliseconds: 300),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: isSelecting
                                    ? Icon(CupertinoIcons.checkmark_circle_fill, size: 22, color: accentColor,)
                                    : Container(
                                        width: 20.0,
                                        height: 20.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 2.0,
                                            color: Theme.of(context).iconTheme.color!.withOpacity(0.5),
                                          )
                                        ),
                                      ),
                              ),
                            ) : null,
                          ),
                        ),
                        Expanded(
                          child: HistoryListItem(
                              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                              controller: swipeActionController,
                              title: item.title,
                              subText: item.subText,
                              onTap: isEditing.value? null : () {
                                //TODO: 画面遷移する
                              },
                              onDismissed: () {
                                sampleHistory.value = List.of(sampleHistory.value)..removeAt(index);
                              },
                              isDraggable: !isEditing.value,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 56.0 + safeAreaPadding.bottom,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppTheme.darkColor2 : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16.0,
                      offset: const Offset(0.0, -4.0)
                    )
                  ]
                ),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom,
                    left: 8.0,
                    right: 16.0
                ),
                child: Row(
                  children: [
                    AppTextButton(
                      'すべての履歴を削除',
                      style: const TextStyle(
                        color: AppTheme.red
                      ),
                      onTap: () async {

                        final result = await showDialog(
                            context: App.navigatorKey.currentContext!,
                            useRootNavigator: true,
                            builder: (_) {
                              return const ConfirmDeleteDialogWidget(
                                title: 'すべて削除してもよろしいですか？',
                                text: 'この操作は元に戻せません。',
                              );
                            });
                        if (result == true) {
                          //TODO: 削除する。
                        }

                      },
                    ),
                    const Spacer(),
                    if (isEditing.value && selectingItem.value.isNotEmpty)
                      Material(
                        borderRadius: BorderRadius.circular(8.0),
                        clipBehavior: Clip.antiAlias,
                        color: AppTheme.red,
                        child: InkWell(
                          onTap: () {
                            //TODO: 選択したアイテムを削除する。
                            isEditing.value = false;
                            selectingItem.value = [];
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Text(
                              '${selectingItem.value.length}件を削除',
                              style: const TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

