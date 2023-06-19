import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_images/images_repository.dart';
import 'package:nasa_images/nasa_image_info.dart';

class FavesPage extends StatefulWidget {
  final ImagesRepository imagesRepository;

  const FavesPage({super.key, required this.imagesRepository});

  @override
  State<FavesPage> createState() => _FavesPageState();
}

class _FavesPageState extends State<FavesPage> {
  Future<List<NasaImageInfo>>? imagesFuture;
  late final ImagesRepository imagesRepository;
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
    imagesFuture = widget.imagesRepository.getFavorites();
    _searchController.addListener(() {
      _debounceSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<NasaImageInfo>>(
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
                      return Image.network(item.url);
                    },
                    itemCount: images.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
