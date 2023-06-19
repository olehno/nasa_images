import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_images/images_repository.dart';
import 'package:nasa_images/nasa_image_info.dart';

class SpaceImagePage extends StatefulWidget {
  final NasaImageInfo info;

  const SpaceImagePage({
    super.key,
    required this.info,
  });

  @override
  State<SpaceImagePage> createState() => _SpaceImagePageState();
}

class _SpaceImagePageState extends State<SpaceImagePage> {
  late final ImagesRepository imagesRepository;

  @override
  void initState() {
    super.initState();
    imagesRepository = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Space Image"),
      ),
      body: Image.network(widget.info.url),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          imagesRepository.addToFavorite(widget.info);
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}
