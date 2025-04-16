import 'package:bloc/bloc.dart';
import 'package:catfisher/layers/domain/service/i_api_service.dart';
import 'package:catfisher/layers/domain/entity/cat.dart';
import 'package:catfisher/layers/data/model/cat_dto.dart';
import 'package:catfisher/layers/data/repository/cat_repository.dart';
import 'package:catfisher/layers/presentation/like_counter_cubit.dart';

abstract class CatState {}

class CatLoading extends CatState {}

class CatLoaded extends CatState {
  final List<Cat> cats;
  CatLoaded(this.cats);
}

class CatError extends CatState {
  final String message;
  CatError(this.message);
}

class CatCubit extends Cubit<CatState> {
  final IApiService apiService;
  final CatRepository catRepository;
  final LikeCounterCubit likeCounterCubit;

  List<Cat> _cats = [];

  CatCubit(this.apiService, this.catRepository, this.likeCounterCubit)
    : super(CatLoading());

  Future<void> loadCats() async {
    emit(CatLoading());
    try {
      _cats = await apiService.fetchRandomCats();
      emit(CatLoaded(_cats));
    } catch (e) {
      emit(CatError(e.toString()));
    }
  }

  Future<void> loadMoreCats() async {
    try {
      List<Cat> newCats = await apiService.fetchRandomCats();
      _cats.addAll(newCats);
      emit(CatLoaded(_cats));
    } catch (e) {
      emit(CatError(e.toString()));
    }
  }

  void likeCat(Cat cat) async {
    CatDTO catDTO = CatDTO.fromCat(cat);
    await catRepository.addLikedCat(catDTO);
    likeCounterCubit.increment();
  }

  void dislikeCat() {}
}
