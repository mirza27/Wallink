const String tableLinks = "links";

class LinkFields {
  static final List<String> values = [];

  static const String id = "_id";
  static const String linkName = "linkName";
  static const String link = "link";
  static const String time = "time";
  static const String subCategoryId = "_subCategoryId";
}

class Link {
  final int? id;
  final String linkName;
  final String link;
  final DateTime createdTime;
  final int? subCategoryId;

  Link({
    this.id,
    required this.linkName,
    required this.link,
    required this.createdTime,
    required this.subCategoryId,
  });

  Link copy({int? id, String? linkName, String? link, DateTime? createdTime, int? subCategoryId}) {
    return Link(
        id: id ?? this.id,
        linkName: linkName ?? this.linkName,
        link: link ?? this.link,
        createdTime: createdTime ?? this.createdTime,
        subCategoryId: subCategoryId ?? this.subCategoryId);
  }

  static Link fromJson(Map<String, Object?> json) {
    return Link(
        id: json[LinkFields.id] as int?,
        linkName: json[LinkFields.linkName] as String,
        link: json[LinkFields.link] as String,
        createdTime: DateTime.parse(json[LinkFields.time] as String),
        subCategoryId: json[LinkFields.subCategoryId] as int?);
  }

  Map<String, Object?> toJson() => {
        LinkFields.id: id,
        LinkFields.linkName: linkName,
        LinkFields.link: link,
        LinkFields.time: createdTime.toString(),
        LinkFields.subCategoryId: subCategoryId
      };
}
