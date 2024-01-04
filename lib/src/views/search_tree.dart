import 'package:flutter/material.dart';
import 'package:what_is/main.dart';

import '../components/text_button.dart';


class SearchTreePage extends StatelessWidget {
  const SearchTreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: InteractiveViewer(
                constrained: false,
                child: const _TreeWidget(
                  labelType: _LabelType.home,
                  children: [
                    //TODO: あれば
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



class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerRight,
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





enum _LabelType {
  home,
  currentPage
}


class _TreeWidget extends StatelessWidget {
  const _TreeWidget({this.labelType, this.children});
  final _LabelType? labelType;
  final List<_TreeWidget>? children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 170,
      margin: const EdgeInsets.only(top: 24.0, right: 16.0, left: 16.0),
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

  Widget labelIfNeed() {
    if (labelType == _LabelType.home) {
      return const _Label.home();
    } else if (labelType == _LabelType.currentPage) {
      return const _Label.currentPage();
    } else {
      return const SizedBox.shrink();
    }
  }
}


class _Label extends StatelessWidget {
  const _Label.home({super.key})
      : text = 'ホーム',
        textColor = Colors.white;

  const _Label.currentPage({super.key})
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

