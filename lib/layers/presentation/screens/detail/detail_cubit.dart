import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catfisher/layers/domain/entity/cat.dart';

class DetailState {
  final bool isLoading;
  final String? errorMessage;

  DetailState({this.isLoading = false, this.errorMessage});
}

class DetailCubit extends Cubit<DetailState> {
  DetailCubit() : super(DetailState());

  void loadCatDetails(Cat cat) async {
    emit(DetailState(isLoading: true));
    try {
      // Логика загрузки данных, если требуется
      emit(DetailState());
    } catch (e) {
      emit(DetailState(errorMessage: e.toString()));
    }
  }
}
