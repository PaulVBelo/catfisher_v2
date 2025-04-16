import 'package:catfisher/layers/data/repository/cat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:catfisher/layers/domain/service/i_api_service.dart';
import 'package:catfisher/layers/domain/entity/cat.dart';
import '../home/cat_cubit.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../detail/detail_screen.dart';
import '../liked/liked_cat_screen.dart';
import 'package:catfisher/layers/presentation/like_counter_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = GetIt.I<IApiService>();
    final catRepository = GetIt.I<CatRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<LikeCounterCubit>(
          create: (_) => GetIt.I<LikeCounterCubit>(),
        ),
        BlocProvider<CatCubit>(
          create:
              (_) => CatCubit(
                apiService,
                catRepository,
                GetIt.I<LikeCounterCubit>(),
              )..loadCats(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text('CATFISHER')),
        body: BlocBuilder<CatCubit, CatState>(
          builder: (context, state) {
            if (state is CatLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CatError) {
              return Center(child: Text(state.message));
            } else if (state is CatLoaded) {
              return buildCatSwiper(context, state.cats);
            } else {
              return Center(child: Text('Неизвестная ошибка'));
            }
          },
        ),
      ),
    );
  }

  Widget buildCatSwiper(BuildContext context, List<Cat> cats) {
    final CardSwiperController swiperController = CardSwiperController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CardSwiper(
            numberOfCardsDisplayed: 5,
            controller: swiperController,
            cardsCount: cats.length,
            cardBuilder: (
              context,
              index,
              percentThresholdX,
              percentThresholdY,
            ) {
              return GestureDetector(
                onTap: () => openDetailScreen(context, cats[index]),
                child: buildCatCard(context, cats[index]),
              );
            },
            onSwipe: (index, cur, direction) {
              final catCubit = context.read<CatCubit>();
              if (direction == CardSwiperDirection.left) {
                catCubit.dislikeCat();
              } else if (direction == CardSwiperDirection.right) {
                catCubit.likeCat(cats[index]);
              }

              catCubit.loadMoreCats();

              return true;
            },
          ),
        ),
        buildBottomBar(context, swiperController),
      ],
    );
  }

  Widget buildCatCard(BuildContext context, Cat cat) {
    final double cardWidth =
        MediaQuery.of(context).size.width * 0.9 > 480
            ? 480
            : MediaQuery.of(context).size.width * 0.9;

    return SizedBox(
      width: cardWidth,
      child: Card(
        color: const Color.fromARGB(255, 2, 150, 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  cat.url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(cat.breedName, style: TextTheme.of(context).titleMedium),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void openDetailScreen(BuildContext context, Cat cat) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(cat: cat)),
    );
  }

  // Press F to pay respects to KNOPKI (removed)

  Widget buildBottomBar(BuildContext context, CardSwiperController controller) {
    final likeCount = context.watch<LikeCounterCubit>().state;

    return Container(
      color: Colors.transparent,
      height: 80.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Likes: $likeCount', style: TextTheme.of(context).bodyLarge),
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.white),
              iconSize: 24.0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LikedCatsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
