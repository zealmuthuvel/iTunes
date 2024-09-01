import 'package:flutter/material.dart';
import 'package:itunes/models/itunes_model.dart';
import 'package:itunes/util/utils.dart';
import 'package:itunes/widgets/grid_view_widget.dart';
import 'package:itunes/widgets/list_view_widget.dart';

// ignore: must_be_immutable
class AllCategoriesPage extends StatefulWidget {
  Map<String, List<ItunesItem>> mediaMap = {};

  AllCategoriesPage({super.key, required this.mediaMap});

  @override
  State<AllCategoriesPage> createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
        ),
        title: const Text(
          'iTunes',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LayoutToggleButton(
                label: 'Grid Layout',
                isSelected: isGrid,
                onPressed: () {
                  setState(() {
                    isGrid = true;
                  });
                },
              ),
              LayoutToggleButton(
                label: 'List Layout',
                isSelected: !isGrid,
                onPressed: () {
                  setState(() {
                    isGrid = false;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.mediaMap.keys.length,
              itemBuilder: (context, i) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    CategoryHeader(
                      title: toCapitalCase(widget.mediaMap.keys.elementAt(i)),
                    ),
                    if (isGrid)
                      MediaGrid(
                        mediaList: widget.mediaMap.values.elementAt(i),
                      )
                    else
                      MediaList(
                        mediaList: widget.mediaMap.values.elementAt(i),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Toggle Button Widget for Grid/List Layout
class LayoutToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const LayoutToggleButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.grey : Colors.grey.shade800,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: isSelected
                ? const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

// Category Header Widget
class CategoryHeader extends StatelessWidget {
  final String title;

  const CategoryHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: Colors.grey.shade800,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
