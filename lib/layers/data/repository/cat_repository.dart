import 'package:catfisher/layers/data/model/cat_dto.dart';

abstract class CatRepository {
  Future<List<CatDTO>> getLikedCats();
  Future<void> addLikedCat(CatDTO cat);
  Future<void> removeLikedCat(CatDTO cat);
  Future<List<CatDTO>> filterLikedCats(String breedName);
}
