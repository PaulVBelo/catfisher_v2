import 'package:flutter/material.dart';
import '../../data/service/api_service.dart';
import '../../domain/entity/cat.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'buttons/basic_button.dart';
import '../screens/detail/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<Cat> cats = [];
  int likeCount = 0;
  final CardSwiperController swiperController = CardSwiperController();

  @override
  void initState() {
    super.initState();
    loadCats();
  }

  Future<void> loadCats() async {
    List<Cat> newCats = await apiService.fetchRandomCats();
    setState(() {
      cats.addAll(newCats);
    });
  }

  void likeCat() {
    setState(() {
      likeCount++;
    });
  }

  void dislikeCat() {
    // Я не придумал зачем :D
  }

  void openDetailScreen(Cat cat) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(cat: cat)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CATFISHER')),
      body:
          cats.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
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
                          onTap: () => openDetailScreen(cats[index]),
                          child: SizedBox(
                            width:
                                MediaQuery.of(context).size.width * 0.9 > 480
                                    ? 480
                                    : MediaQuery.of(context).size.width * 0.9,

                            child: Card(
                              color: const Color.fromARGB(255, 236, 31, 76),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: Image.network(
                                        cats[index].url,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (
                                          BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress,
                                        ) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          (loadingProgress
                                                                  .expectedTotalBytes ??
                                                              1)
                                                      : null,
                                              color: Colors.white70,
                                              padding: EdgeInsets.all(4.0),
                                            ),
                                          );
                                        },
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Center(
                                            child: Text(
                                              'encountered error while loading picture',
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Text(
                                    cats[index].breedName,
                                    style: TextTheme.of(context).titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      onSwipe: (index, cur, direction) {
                        if (direction == CardSwiperDirection.left) {
                          dislikeCat();
                        } else if (direction == CardSwiperDirection.right) {
                          likeCat();
                        }
                        loadCats();
                        return true;
                      },
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 173, 2, 73),
                    height: 80.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BasicButton(
                            onPressed: () {
                              swiperController.swipe(CardSwiperDirection.left);
                            },
                            tooltip: "Dislike",
                            icon: Icon(
                              Icons.thumb_down,
                              color: Colors.white70,
                              size: 32,
                            ),
                          ),
                          Text(
                            'Likes: $likeCount',
                            style: TextTheme.of(context).bodyMedium,
                          ),
                          BasicButton(
                            onPressed: () {
                              swiperController.swipe(CardSwiperDirection.right);
                            },
                            tooltip: "Like",
                            icon: Icon(
                              Icons.thumb_up,
                              color: Colors.white70,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
