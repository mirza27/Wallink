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
  Category(categoryName: "Education", subCategories: [
    SubCategory(subCategoryName: "ASD", links: [
      Link(
          name: "materi stack",
          link: "arna.lecturer.pens",
          is_favorite: true,
          createdAt: DateTime.now()),
          
      Link(
          name: "materi queue",
          link: "arna.lecturer.pens",
          is_favorite: true,
          createdAt: DateTime.now())
    ]),
    SubCategory(
      subCategoryName: "Basis data",
      links: [
        Link(
            name: "materi query",
            link: "www.data.com",
            is_favorite: true,
            createdAt: DateTime.now()),
        Link(
            name: "materi subquery",
            link: "www.data.com",
            is_favorite: false,
            createdAt: DateTime.now())
      ],
    )
  ]),
  Category(categoryName: "Entertaiment", subCategories: [
    SubCategory(subCategoryName: "Hehe", links: [
      Link(name: "hehe", link: "hehe.com", is_favorite: true, createdAt: DateTime.now()),
    ]),
    SubCategory(
      subCategoryName: "Movie",
      links: [
        Link(name: "movie 1", link: "lk21.com", is_favorite: true, createdAt: DateTime.now()),
        Link(name: "movie 2", link: "rebahin.com", is_favorite: false, createdAt: DateTime.now())
      ],
    )
  ]),
  
];
