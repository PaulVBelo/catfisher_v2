import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import 'package:catfisher/layers/presentation/screens/liked/liked_cat_cubit.dart';
import 'package:catfisher/layers/presentation/like_counter_cubit.dart';

// ignore: use_key_in_widget_constructors
class LikedCatsScreen extends StatefulWidget {
  @override
  State<LikedCatsScreen> createState() => _LikedCatsScreenState();
}

class _LikedCatsScreenState extends State<LikedCatsScreen> {
  late final LikedCatsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = GetIt.I<LikedCatsCubit>();
    _cubit.loadLikedCats();
  }

  @override
  void dispose() {
    _cubit.resetFilter();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Liked Cats"),
          actions: [
            IconButton(
              icon: Icon(Icons.clear),
              color: Colors.white60,
              onPressed: () => _cubit.resetFilter(),
            ),
          ],
        ),
        body: BlocBuilder<LikedCatsCubit, LikedCatsState>(
          builder: (context, state) {
            if (state is LikedCatsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is LikedCatsLoaded) {
              final cats = state.cats;
              final breeds =
                  _cubit.allCats.map((c) => c.breedName).toSet().toList();

              return Column(
                // При выбранной породе смещение фильтра на стоку вверх
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value:
                          state.selectedBreed?.isNotEmpty == true
                              ? state.selectedBreed
                              : null,
                      hint: Text("Filter by breed"),
                      dropdownColor: const Color.fromARGB(255, 2, 150, 2),
                      items: [
                        DropdownMenuItem(value: '', child: Text("All breeds")),
                        ...breeds.map((breed) {
                          return DropdownMenuItem(
                            value: breed,
                            child: Text(breed),
                          );
                        }),
                      ],
                      onChanged: (value) => _cubit.filterByBreed(value ?? ''),
                    ),
                  ),
                  Expanded(
                    child:
                        cats.isEmpty
                            ? Center(child: Text("No liked cats yet"))
                            : ListView.builder(
                              itemCount: cats.length,
                              itemBuilder: (context, index) {
                                final cat = cats[index];
                                return Card(
                                  margin: EdgeInsets.all(8),
                                  child: ListTile(
                                    leading: SizedBox(
                                      height: 56,
                                      width: 56,
                                      child: Image.network(
                                        cat.url,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (
                                          context,
                                          child,
                                          progress,
                                        ) {
                                          if (progress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      ),
                                    ),
                                    textColor: Colors.white,
                                    tileColor: const Color.fromARGB(
                                      255,
                                      2,
                                      150,
                                      2,
                                    ),
                                    title: Text(cat.breedName),
                                    subtitle: Text(
                                      "Liked at: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(cat.likedAt.toLocal())}",
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.white70,
                                      onPressed: () {
                                        _cubit.removeCat(cat);
                                        GetIt.I<LikeCounterCubit>().decrement();
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              );
            } else {
              return Center(child: Text("Something went wrong"));
            }
          },
        ),
      ),
    );
  }
}
