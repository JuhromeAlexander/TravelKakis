class Categories {
  final String categoryName;
  final String categoryType;

  Categories({
    required this.categoryName,
    required this.categoryType
  });

  String getCategoryName() {
    return categoryName;
  }

  String getCategoryType() {
    return categoryType;
  }
}