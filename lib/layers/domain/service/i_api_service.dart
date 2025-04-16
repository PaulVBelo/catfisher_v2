import "../entity/cat.dart";

abstract class IApiService {
  Future<List<Cat>> fetchRandomCats();
}
