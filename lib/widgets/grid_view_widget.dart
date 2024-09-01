import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:itunes/models/itunes_model.dart';
import 'package:itunes/view/description_page.dart';

class MediaGrid extends StatelessWidget {
  final List<ItunesItem> mediaList;

  const MediaGrid({super.key, required this.mediaList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: .6,
      ),
      itemCount: mediaList.length,
      itemBuilder: (context, index) {
        return gridListView(context, index);
      },
    );
  }

  GestureDetector gridListView(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DescriptionPage(
              mediaResult: mediaList[index],
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: SizedBox(
              height: 120,
              child: CachedNetworkImage(
                imageUrl: mediaList[index].artworkUrl100.toString(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                scale: .6,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                mediaList[index].trackName.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
