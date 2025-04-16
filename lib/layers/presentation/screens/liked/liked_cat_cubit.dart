import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catfisher/layers/data/model/cat_dto.dart';
import 'package:catfisher/layers/data/repository/cat_repository.dart';

abstract class LikedCatsState {
  final String? selectedBreed;
  const LikedCatsState({this.selectedBreed});
}

class LikedCatsLoading extends LikedCatsState {}

class LikedCatsLoaded extends LikedCatsState {
  final List<CatDTO> cats;
  // ignore: use_super_parameters
  LikedCatsLoaded(this.cats, {String? selectedBreed})
    : super(selectedBreed: selectedBreed);
}

class LikedCatsCubit extends Cubit<LikedCatsState> {
  final CatRepository repository;
  List<CatDTO> allCats = [];

  LikedCatsCubit(this.repository) : super(LikedCatsLoading());

  Future<void> loadLikedCats() async {
    emit(LikedCatsLoading());
    allCats = await repository.getLikedCats();
    emit(LikedCatsLoaded(allCats));
  }

  void filterByBreed(String breed) {
    final filtered =
        breed.isEmpty
            ? allCats
            : allCats.where((cat) => cat.breedName == breed).toList();
    emit(LikedCatsLoaded(filtered, selectedBreed: breed));
  }

  Future<void> removeCat(CatDTO cat) async {
    await repository.removeLikedCat(cat);
    await loadLikedCats();
    filterByBreed(state.selectedBreed ?? '');
  }

  void resetFilter() {
    emit(LikedCatsLoaded(allCats));
  }
}
