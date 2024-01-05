import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/main.dart';
import 'package:what_is/src/controllers/search_tree_controller.dart';
import 'package:what_is/src/enums/search_tree_card_type.dart';
import 'package:what_is/src/providers/search_tree_provider.dart';

import '../components/text_button.dart';


class SearchTreePage extends HookConsumerWidget {
  const SearchTreePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final searchTree = ref.watch(searchTreeProvider);
    print(searchTree);
    final searchTreeWidget = SearchTreeController().generateTreeWidgets();

    return Scaffold(
      body: Stack(
        children: [
          InteractiveViewer(
            constrained: false,
            clipBehavior: Clip.none,
            boundaryMargin: EdgeInsets.only(
                top: 24.0,
                right: 24.0,
                left: 24.0,
                bottom: 24.0 + MediaQuery.paddingOf(context).bottom
            ),
            child: searchTreeWidget,
          ),
          const Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: _Header(),
          )
        ],
      ),
    );
  }
}



class _Header extends StatelessWidget {
  const _Header();

  static const height = 56.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SizedBox(
            width: double.infinity,
            height: height + MediaQuery.of(context).padding.top,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppTextButton(
                  '完了',
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 1.0,
          width: double.infinity,
          child: ColoredBox(
            color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.15),
          ),
        )
      ],
    );
  }
}







class SearchTreeWidget extends StatelessWidget {
  const SearchTreeWidget({
    this.cardType,
    this.children,
    super.key,
    required this.title,
    required this.siteLogo,
    required this.searchTreeId,
    required this.ageThumbnail
  });
  final SearchTreeCardType? cardType;
  final List<SearchTreeWidget>? children;

  final String title;
  final ImageProvider siteLogo;
  final int searchTreeId;
  final ImageProvider ageThumbnail;

  static const areaColor = Color(0xFF30435E);

  @override
  Widget build(BuildContext context) {

    final isHomeCard = cardType == SearchTreeCardType.home;
    final hasChildren = children != null;

    return Container(
      margin: EdgeInsets.only(
          top: isHomeCard
              ? _Header.height + 24.0 + MediaQuery.paddingOf(context).top
              : 0.0,
          left: isHomeCard? 24.0 : 0.0
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _card(),

          if (hasChildren)
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Container(
                height: 16.0,
                width: 6.0,
                color: areaColor.withOpacity(0.3),
              ),
            ),

          if (hasChildren)
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(width: 6.0, color: areaColor.withOpacity(0.2)),
                  color: areaColor.withOpacity(0.2)
              ),
              child: Column(
                children: children ?? [],
              ),
            ),
        ],
      ),
    );
  }

  Widget labelIfNeed() {
    if (cardType == SearchTreeCardType.home) {
      return const _Label.home();
    } else if (cardType == SearchTreeCardType.currentPage) {
      return const _Label.currentPage();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _card() {
    return Container(
      width: 340,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0.0, 4.0),
              blurRadius: 24.0
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  labelIfNeed(),

                  const SizedBox(height: 8.0,),

                  const Expanded(
                    child: Text(
                      'マイクロサービスサービスアーキテクチャについて', //TODO: ちゃんとする
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.5
                      ),
                    ),
                  ),

                  const SizedBox(height: 8.0,),

                  Row(
                    children: [
                      Container(
                        height: 24.0,
                        width: 24.0,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              //TODO: ちゃんとした画像使う
                                image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqTcH9zNA5--jcBmb3fBuZ8RMpZSgX-EuUdKAm37L9EfpljQ1C_bQ8j3Xdf0tqOohP5Cw&usqp=CAU'),
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.medium
                            )
                        ),
                      ),
                      const SizedBox(width: 4.0,),
                      const Text(
                        'Google', //TODO: ちゃんとしたサイト名使う
                        style: TextStyle(
                            fontSize: 12
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0)
                ),
                color: Colors.red, //TODO: ちゃんとする
              ),
            ),
          )
        ],
      ),
    );
  }
}






class _Label extends StatelessWidget {
  const _Label.home()
      : text = 'ホーム',
        textColor = Colors.white;

  const _Label.currentPage()
      : text = '現在のページ',
        textColor = Colors.black; //TODO: ちゃんとした色にする
  final String text;
  final Color textColor;
  // final Color backgroundColor; //TODO:実装する

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.yellow, //TODO: ちゃんとした色にする
        borderRadius: BorderRadius.circular(40.0)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            height: 1.0
          ),
        ),
      ),
    );
  }
}

