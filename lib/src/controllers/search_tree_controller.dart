import 'package:flutter/material.dart';

import '../models/search_tree.dart';
import '../views/search_tree_screen.dart';


class SearchTreeController {

  Widget createSearchTreeWidget(SearchTree? node) {
    if (node == null) return const SizedBox.shrink();

    return SearchTreeWidget(
      key: GlobalKey(),
      title: node.searchWebPage.searchWord,
      searchTreeId: node.id,
      isHomeCard: node.id == 0,
      siteLogo: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqTcH9zNA5--jcBmb3fBuZ8RMpZSgX-EuUdKAm37L9EfpljQ1C_bQ8j3Xdf0tqOohP5Cw&usqp=CAU'),
      pageThumbnail: null, //TODO: 画像指定する。
      children: node.children.map((child) {
        return createSearchTreeWidget(child);
      }).toList(),
    );
  }

}
