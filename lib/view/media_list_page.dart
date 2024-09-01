import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes/util/string_resource.dart';
import 'package:itunes/util/utils.dart';
import 'package:itunes/view/categories_page.dart';
import 'package:itunes/viewmodel/data_return.dart';

class MediaListPage extends ConsumerWidget {
  final String searchTerm;

  const MediaListPage({super.key, required this.searchTerm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaMap = ref.watch(itunesDataProvider(searchTerm));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.white,
          ),
          title: const Text(
            StringResource.media,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: mediaMap.when(
          data: (mediaMap) {
            return Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: mediaMap.keys.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AllCategoriesPage(mediaMap: mediaMap),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              toCapitalCase(mediaMap.keys.elementAt(index)),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => Text(
            error.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
