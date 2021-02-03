class ProductEntity {
  final int id;
  final String title;
  final bool fav_status;
  final int category_id;
  final int subcategory_id;
  final int status;
  final String color;
  final String image;
  final String description;
  final List<IngredientEntity> ingredients;
  final List<StepsEntity> steps;
  final String tags;
  final int total_calories;

  ProductEntity(
      {this.id,
      this.title,
      this.fav_status,
      this.category_id,
      this.subcategory_id,
      this.status,
      this.color,
      this.image,
      this.description,
      this.ingredients,
      this.steps,
      this.tags,
      this.total_calories});

  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    var ingredients = (json["ingredients"] as List).map((e) => IngredientEntity.fromJson(e)).toList();

    var steps = (json["steps"] as List).map((e) => StepsEntity.fromJson(e)).toList();

    return ProductEntity(
      id: json['id'],
      title: json['title'],
      fav_status: json['fav_status'],
      category_id: json['category_id'],
      subcategory_id: json['subcategory_id'],
      status: json['status'],
      color: json['color'],
      image: json['image'],
      description: json['description'],
      tags: json['tags'],
      total_calories: json['total_calories'],
      ingredients: ingredients,
      steps: steps,
    );
  }
}

class IngredientEntity {
  final int id;
  final String ingredient;
  final String amount;
  final double amount_count;
  final int amount_type; // TODO: Need understand types
  final bool status;

  IngredientEntity({this.id, this.ingredient, this.amount, this.amount_count, this.amount_type, this.status});

  factory IngredientEntity.fromJson(Map<String, dynamic> json) {
    return IngredientEntity(
      id: json['id'],
      ingredient: json['ingredient'],
      amount: json['amount'],
      amount_count: json['amount_count'].toDouble(),
      amount_type: json['amount_type'],
      status: json['status'],
    );
  }
}

class StepsEntity {
  final int id;
  final String description;
  final String image;

  StepsEntity({this.id, this.description, this.image});

  factory StepsEntity.fromJson(Map<String, dynamic> json) {
    return StepsEntity(
      id: json['id'],
      description: json['description'],
      image: json['image'],
    );
  }
}

class TagEntity {
  final int id;
  final String tag;

  TagEntity({this.id, this.tag});

  factory TagEntity.fromJson(Map<String, dynamic> json) {
    return TagEntity(
      id: json['id'],
      tag: json['tag'],
    );
  }
}
