class Link {
  String name;
  String link;
  bool is_favorite;
  DateTime createdAt;

  Link({
    this.name = "link - index",
    required this.link,
    required this.is_favorite,
    required this.createdAt,
  });
}

class SubCategory {
  String subCategoryName;
  List<Link> links;

  SubCategory({
    required this.subCategoryName,
    required this.links,
  });
}

class Category {
  String categoryName;
  List<SubCategory> subCategories;

  Category({
    required this.categoryName,
    required this.subCategories,
  });
}

List<Category> listData = [
  Category(categoryName: "Hold this to actions", subCategories: [
    SubCategory(subCategoryName: "Hold this to actions", links: [
      Link(
          name: "Tap this to launch",
          link: "www.google.com",
          is_favorite: true,
          createdAt: DateTime.now()),
      Link(
          name: "Swipe left to actions",
          link: "blank.com",
          is_favorite: false,
          createdAt: DateTime.now()),
      Link(
          name: "Hold this to copy",
          link: "https://www.bbc.com/news",
          is_favorite: true,
          createdAt: DateTime.now())
    ]),
  ]),
];
