class Cat {
  final String url;
  final String breedName;
  final String description;

  Cat({required this.url, required this.breedName, required this.description});

  factory Cat.fromJson(Map<String, dynamic> json) {
    final breedData = !json['breeds'].isEmpty ? json['breeds'][0] : {};

    String name = breedData['name'] ?? 'Unknown';
    String desc = breedData['description'] ?? 'No description available';

    return Cat(url: json['url'], breedName: name, description: desc);
  }
}
