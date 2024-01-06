import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

class InfoFromWebSiteController {

  Future<({Widget? title, Widget? image, Widget? description})> getInfo() async {
    const String url = 'https://flutterlabo.tech/';
    Widget title;
    Widget? image;
    Widget? description;

    // URLにアクセスして情報をすべて取得
    Response response = await get(Uri.parse(url));

    // HTMLパッケージでHTMLタグとして認識
    var document = parse(response.body);

    // ヘッダー内のtitleタグの中身を取得
    title = Text(document.head!.getElementsByTagName('title')[0].innerHtml, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 13),);

    // ヘッダー内のmetaタグをすべて取得
    var metas = document.head!.getElementsByTagName('meta');
    for(var meta in metas) {
      // metaタグの中からname属性がdescriptionであるものを探す
      if(meta.attributes['name'] == 'description') {
        description = Text(meta.attributes['content'] ?? '', overflow: TextOverflow.ellipsis, maxLines: 3, style: const TextStyle(fontSize: 12),);

        // metaタグの中からproperty属性がog:imageであるものを探す
      } else if(meta.attributes['property'] == 'og:image') {
        image = Image.network(
          meta.attributes['content']!,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        );
      }
    }

    return (title: title, image: image, description: description);
  }

}
