class CategoryEntity {
  final int id;
  final String title;
  final String pictureUrl;
  final List<SubCategoryEntity> subcategories;
  final int recieptsCount;

  CategoryEntity(
      {this.id,
      this.title,
      this.pictureUrl,
      this.subcategories,
      this.recieptsCount});

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    var subcategories = (json['subcategories'] as List)
        .map((e) => SubCategoryEntity.fromJson(e))
        .toList();

    var recieptsCount = subcategories
        .map((e) => e.recipesCount)
        .map((e) => int.tryParse(e))
        .reduce((value, element) => value + element);

    return CategoryEntity(
      id: json['id'],
      title: json['title'],
      pictureUrl: json['picture'],
      subcategories: subcategories,
      recieptsCount: recieptsCount,
    );
  }
}

class SubCategoryEntity {
  final int id;
  final String title;
  final int categoryId;
  final String recipesCount;

  SubCategoryEntity({this.id, this.title, this.categoryId, this.recipesCount});

  factory SubCategoryEntity.fromJson(Map<String, dynamic> json) {
    return SubCategoryEntity(
      id: json['id'],
      title: json['title'],
      categoryId: json['category_id'],
      recipesCount: json['recipes_count'],
    );
  }
}
