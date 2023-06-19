import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_images/faves_page.dart';
import 'package:nasa_images/images_repository.dart';
import 'package:nasa_images/nasa_image_info.dart';
import 'package:nasa_images/space_image_page.dart';

class SpaceImagesPage extends StatefulWidget {
  const SpaceImagesPage({super.key});

  @override
  State<SpaceImagesPage> createState() => _SpaceImagesPageState();
}

class _SpaceImagesPageState extends State<SpaceImagesPage> {
  late final ImagesRepository imagesRepository;
  Future<List<NasaImageInfo>>? imagesFuture;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debouncer;

  void _debounceSearch() {
    if (_debouncer != null) {
      _debouncer?.cancel();
    }
    _debouncer = Timer(const Duration(seconds: 1), () {
      final query = _searchController.text;
      setState(() {
        imagesFuture = imagesRepository.search(query);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    imagesRepository = context.read();
    imagesFuture = imagesRepository.getImages();
    _searchController.addListener(() {
      _debounceSearch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Space Images"),
        actions: [
          IconButton(
            onPressed: () => _showFavesPage(context),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder<List<NasaImageInfo>>(
        future: imagesFuture,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final images = snapShot.data ?? [];
          return Column(
            children: [
              TextFormField(
                controller: _searchController,
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final item = images[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SpaceImagePage(
                              info: item,
                            ),
                          ),
                        );
                      },
                      child: Image.network(item.url),
                    );
                  },
                  itemCount: images.length,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _showFavesPage(BuildContext context) {
    final favesPage = FavesPage(imagesRepository: imagesRepository);
    final route = MaterialPageRoute(builder: (context) {
      return favesPage;
    });
    Navigator.of(context).push(route);
  }
}
