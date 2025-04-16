import 'package:catfisher/layers/presentation/screens/liked/liked_cat_cubit.dart';
import 'package:get_it/get_it.dart';

import 'screens/detail/detail_cubit.dart';
import 'screens/home/cat_cubit.dart';
import 'package:catfisher/layers/domain/service/i_api_service.dart';
import 'package:catfisher/layers/data/service/api_service.dart';
import 'package:catfisher/layers/data/repository/cat_repository.dart';
import 'package:catfisher/layers/data/repository/in_mem_cat_repository.dart';
import 'like_counter_cubit.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerFactory<DetailCubit>(() => DetailCubit());

  getIt.registerLazySingleton<IApiService>(() => ApiService());
  getIt.registerLazySingleton<CatRepository>(() => InMemoryCatRepository());

  getIt.registerSingleton<LikeCounterCubit>(LikeCounterCubit());

  getIt.registerFactory<LikedCatsCubit>(
    () => LikedCatsCubit(getIt<CatRepository>()),
  );
  getIt.registerFactory<CatCubit>(
    () => CatCubit(
      getIt<IApiService>(),
      getIt<CatRepository>(),
      getIt<LikeCounterCubit>(),
    ),
  );
}
