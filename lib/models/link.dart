// PENAMAAN QUERY INISIASI SQLITE
const String tableLinks = "links_tables";

class LinkFields {
  static final List<String> values = [];

  static const String columnLinkId = "id";
  static const String columnLinkName = "link_name";
  static const String columnLink = "link";
  static const String columnSubCategoryId = "sub_category_id";
  static const String columnCreatedAt = "createdAt";
  static const String columnUpdatedAt = "updatedAt";
}

// READ OBJECT FROM DB DYNAMIC
class Link {
  int? id;
  String? link;
  String? nameLink;
  int? subCategoryId;
  DateTime? createdAt; // created mbe updated sek gaiso embo lapo aneh
  DateTime? updatedAt;

  Link({this.id, this.nameLink, this.link, this.subCategoryId, this.createdAt, this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      LinkFields.columnLinkId: id,
      LinkFields.columnLinkName: nameLink,
      LinkFields.columnLink: link,
      LinkFields.columnSubCategoryId: subCategoryId, 
      LinkFields.columnCreatedAt : createdAt, 
      LinkFields.columnUpdatedAt : updatedAt,
    };
  }

  factory Link.fromMap(Map<String, dynamic> map) {
    return Link(
        id: map[LinkFields.columnLinkId],
        nameLink: map[LinkFields.columnLinkName],
        link: map[LinkFields.columnLink],
        subCategoryId: map[LinkFields.columnSubCategoryId], 
        createdAt : DateTime.parse(map[LinkFields.columnCreatedAt] as String),
        updatedAt: DateTime.parse(map[LinkFields.columnUpdatedAt] as String),);
  }
}

// STATIC VERSION
// class Link {
//   final int? id;
//   final String linkName;
//   final String link;
//   final DateTime createdTime;
//   final int? subCategoryId;

//   Link({
//     this.id,
//     required this.linkName,
//     required this.link,
//     required this.createdTime,
//     required this.subCategoryId,
//   });

//   Link copy({int? id, String? linkName, String? link, DateTime? createdTime, int? subCategoryId}) {
//     return Link(
//         id: id ?? this.id,
//         linkName: linkName ?? this.linkName,
//         link: link ?? this.link,
//         createdTime: createdTime ?? this.createdTime,
//         subCategoryId: subCategoryId ?? this.subCategoryId);
//   }

//   static Link fromJson(Map<String, Object?> json) {
//     return Link(
//         id: json[LinkFields.id] as int?,
//         linkName: json[LinkFields.linkName] as String,
//         link: json[LinkFields.link] as String,
//         createdTime: DateTime.parse(json[LinkFields.time] as String),
//         subCategoryId: json[LinkFields.subCategoryId] as int?);
//   }

//   Map<String, Object?> toJson() => {
//         LinkFields.id: id,
//         LinkFields.linkName: linkName,
//         LinkFields.link: link,
//         LinkFields.time: createdTime.toString(),
//         LinkFields.subCategoryId: subCategoryId
//       };
// }
