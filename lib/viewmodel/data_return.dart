import 'package:itunes/models/itunes_model.dart';
import 'package:itunes/service/itunes_api.dart';

import 'package:riverpod/riverpod.dart';

final itunesDataProvider =
    FutureProvider.family<Map<String, List<ItunesItem>>, String>(
        (ref, query) async {
  final itunesData = await ref.watch(itunesApiProvider).getItunesData(query);

  Map<String, List<ItunesItem>> mediaMap = {};

  for (var element in itunesData.results) {
    if (element.kind != null) {
      if (!mediaMap.containsKey(element.kind)) {
        mediaMap[element.kind.toString()] = [];
      }
      mediaMap[element.kind]!.add(element);
    }
  }

  return mediaMap;
});
