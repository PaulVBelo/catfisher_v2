import 'package:catfisher/layers/domain/entity/cat.dart';

class CatDTO {
  final String url;
  final String breedName;
  final String description;
  final DateTime likedAt;

  CatDTO({
    required this.url,
    required this.breedName,
    required this.description,
    required this.likedAt,
  });

  factory CatDTO.fromCat(Cat cat) {
    return CatDTO(
      url: cat.url,
      breedName: cat.breedName,
      description: cat.description,
      likedAt: DateTime.now().toLocal(),
    );
  }
}
