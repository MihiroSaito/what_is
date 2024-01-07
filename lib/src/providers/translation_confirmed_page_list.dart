import 'package:hooks_riverpod/hooks_riverpod.dart';


/// 翻訳を有効にしたサイトのURLを管理する。
/// * ページをリロードしたらそのページのURLがリストから削除される。
// 自動翻訳の場合、別ページにリダイレクトされる仕様のため、
// ブラウザバックした際に再度翻訳→リダイレクトと永遠に元のページに戻れない問題を回避するため。
final translationConfirmedPageListProvider = NotifierProvider.autoDispose<
    TranslationConfirmedPageListNotifier, List<String>>(() {
  return TranslationConfirmedPageListNotifier();
});

class TranslationConfirmedPageListNotifier extends AutoDisposeNotifier<List<String>> {

  @override
  List<String> build() => [];


  void add(String url) => state = [...state, url];


  void remove(String url) {
    state = List.of(state)..removeWhere((e) => e == url);
  }
}

