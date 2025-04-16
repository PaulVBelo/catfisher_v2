import 'package:flutter_bloc/flutter_bloc.dart';

class LikeCounterCubit extends Cubit<int> {
  LikeCounterCubit() : super(0);

  void setCount(int count) => emit(count);
  void increment() => emit(state + 1);
  void decrement() {
    if (state > 0) emit(state - 1);
  }
}
