import '../model/cat_dto.dart';
import 'cat_repository.dart';

class InMemoryCatRepository implements CatRepository {
  final List<CatDTO> _likedCats = [];

  @override
  Future<List<CatDTO>> getLikedCats() async {
    return _likedCats;
  }

  @override
  Future<void> addLikedCat(CatDTO cat) async {
    _likedCats.add(cat);
  }

  @override
  Future<void> removeLikedCat(CatDTO cat) async {
    _likedCats.remove(cat);
  }

  @override
  Future<List<CatDTO>> filterLikedCats(String breedName) async {
    return _likedCats.where((cat) => cat.breedName == breedName).toList();
  }
}
