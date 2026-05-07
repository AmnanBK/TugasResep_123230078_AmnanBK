import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/services/api_service.dart';

class DetailPage extends StatefulWidget {
  final String recipeId;

  const DetailPage({super.key, required this.recipeId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<RecipeDetail> _detailFuture;
  bool _isFavorite = false; // placeholder, akan dihubungkan ke Hive nanti

  @override
  void initState() {
    super.initState();
    _detailFuture = ApiService.getRecipeDetail(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<RecipeDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _detailFuture = ApiService.getRecipeDetail(
                          widget.recipeId,
                        );
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Success
          final recipe = snapshot.data!;
          return CustomScrollView(
            slivers: [
              // AppBar dengan gambar sebagai background
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'recipe_${recipe.id}',
                    child: Image.network(
                      recipe.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                  ),
                ),
                actions: [
                  // Tombol favorit di AppBar
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                      // TODO: Simpan/hapus dari Hive (milestone berikutnya)
                    },
                  ),
                ],
              ),

              // Konten detail
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama resep
                      Text(
                        recipe.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Kategori dan asal negara
                      Row(
                        children: [
                          Chip(
                            label: Text(recipe.category),
                            backgroundColor: Colors.orange[100],
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(recipe.area),
                            backgroundColor: Colors.blue[100],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),

                      // Section Ingredients
                      const Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...recipe.ingredients.map(
                        (ingredient) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 6,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${ingredient.name} - ${ingredient.measure}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),

                      // Section Instructions
                      const Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        recipe.instructions,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
