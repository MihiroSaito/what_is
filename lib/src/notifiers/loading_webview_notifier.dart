import 'package:hooks_riverpod/hooks_riverpod.dart';


final isLoadingWebViewProvider = StateProvider.autoDispose<bool>((ref) => false);
