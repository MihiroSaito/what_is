import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/main.dart';
import 'package:what_is/src/components/squishy_button.dart';
import 'package:what_is/src/controllers/search_tree_controller.dart';
import 'package:what_is/src/enums/search_tree_card_type.dart';
import 'package:what_is/src/providers/display_web_page_provider.dart';
import 'package:what_is/src/providers/search_tree_provider.dart';
import 'package:what_is/src/routing/navigator.dart';

import '../components/text_button.dart';


class SearchTreePage extends HookConsumerWidget {
  const SearchTreePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final searchTree = ref.watch(searchTreeProvider);
    final searchTreeWidget = SearchTreeController().createSearchTreeWidget(searchTree);

    return Scaffold(
      body: Stack(
        children: [
          InteractiveViewer(
            constrained: false,
            clipBehavior: Clip.none,
            alignment: Alignment.topLeft,
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







class SearchTreeWidget extends HookConsumerWidget {
  const SearchTreeWidget({
    this.cardType,
    this.children = const [],
    super.key,
    required this.title,
    required this.siteLogo,
    required this.searchTreeId,
    required this.pageThumbnail
  });
  final SearchTreeCardType? cardType;
  final List<Widget> children;

  final String title;
  final ImageProvider siteLogo;
  final int searchTreeId;
  final ImageProvider? pageThumbnail;

  static const areaColor = Color(0xFF30435E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isHomeCard = cardType == SearchTreeCardType.home;
    final hasChildren = children.isNotEmpty;

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
          _card(ref, searchTreeId),

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
                children: children,
              ),
            ),
        ],
      ),
    );
  }

  Widget labelIfNeed() {
    if (cardType == SearchTreeCardType.home) {
      return const _CardLabelHome();
    } else if (cardType == SearchTreeCardType.currentPage) {
      return const _CardLabelCurrentPage();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _card(WidgetRef ref, int id) {
    return SquishyButton(
      onTap: () {
        AppNavigator().pop();
        ref.read(displayWebPageIndexProvider.notifier).change(index: id);
      },
      disableWidget: const SizedBox.shrink(),
      child: Container(
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

                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
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
                        const SizedBox(width: 6.0,),
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
              child: pageThumbnail == null? Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0)
                  ),
                  color: Color(0xFFEFF5FA), //TODO: ちゃんとする
                ),
                child: const Center(
                  child: Icon(Icons.public, color: Color(0xFF7D858B),),
                ),
              ) : Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0)
                  ),
                  image: DecorationImage( //TODO: ちゃんとする
                    image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuonttDVUIaT7bH-QRsQbT_jUHBjVPlOuOJUS8JMWvjp5D8qtljXIILivwyU7a_f-ot8Q&usqp=CAU'),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}






class _CardLabelHome extends StatelessWidget {
  const _CardLabelHome();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: [accentColor, Color(0xFF6a11cb)],
            stops: [0.0, 1.0],
          ),
          borderRadius: BorderRadius.circular(40.0)
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Text(
          'ホーム',
          style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              height: 1.0
          ),
        ),
      ),
    );
  }
}


class _CardLabelCurrentPage extends StatelessWidget {
  const _CardLabelCurrentPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5FA), //TODO: ちゃんとした色にする
        borderRadius: BorderRadius.circular(40.0)
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Text(
          '現在のページ',
          style: TextStyle(
            color: Color(0xFF7D858B),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            height: 1.0
          ),
        ),
      ),
    );
  }
}

