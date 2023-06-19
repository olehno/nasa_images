import 'package:nasa_images/nasa_image_info.dart';

abstract class ImagesRepository {
  Future<List<NasaImageInfo>> getImages();
  Future<void> addToFavorite(NasaImageInfo info);
  Future<List<NasaImageInfo>> getFavorites();
  Future<List<NasaImageInfo>> search(String query);
}