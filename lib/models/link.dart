const String tabelLink = "notes";

class LinkFields {
  static final List<String> value = [];
  static const String id = "_id";
  static const String namaLink = "_namaLink";
  static const String link = "_link";
  static const String time = "time";
  static const String subKategoriId = "_subKategoriId";
}

class Link {
  final int? id;
  final String namaLink;
  final String link;
  final DateTime createdTime;
  final int? subKategoriId;

  Link({
    this.id,
    required this.namaLink,
    required this.link,
    required this.createdTime,
    this.subKategoriId,
  });

  Link copy({int? id, String? namaLink, String? link, DateTime? createdTime}) {
    return Link(
        id: id ?? this.id,
        namaLink: namaLink ?? this.namaLink,
        link: link ?? this.link,
        createdTime: createdTime ?? this.createdTime);
  }

    static Link fromJson(Map<String, Object?> json) {
    return Link(
        id: json[LinkFields.id] as int?,
        namaLink: json[LinkFields.id] as String,
        link: json[LinkFields.id] as String,
        createdTime: DateTime.parse(json[LinkFields.time] as String));
  }

      Map<String, Object?> toJson() => {
        LinkFields.id: id,
        LinkFields.namaLink: namaLink, 
        LinkFields.link: link,
        LinkFields.time: createdTime.toString()
      };
}
