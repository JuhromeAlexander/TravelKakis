class Categories {
  final String categoryName;
  final String categoryType;
  String? categoryValue;
  String? categoryID;

  Categories({
    required this.categoryName,
    required this.categoryType,
    this.categoryID,
    this.categoryValue
  });

  String getCategoryName() {
    return categoryName;
  }

  String getCategoryType() {
    return categoryType;
  }

  String? getCategoryID() {
    return categoryID;
  }

  String? getCategoryValue() {
    return categoryValue;
  }
}