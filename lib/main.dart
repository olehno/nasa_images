import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_images/images_repository.dart';
import 'package:nasa_images/in_memory_images_repository.dart';
import 'package:nasa_images/space_images_page.dart';

void main() {
  final imagesRepository = InMemoryImagesRepository();
  final imagesRepositoryProvider = RepositoryProvider<ImagesRepository>(
    create: (context) => imagesRepository,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        imagesRepositoryProvider,
      ],
      child: const MaterialApp(
        home: SpaceImagesPage(),
      ),
    ),
  );
}
