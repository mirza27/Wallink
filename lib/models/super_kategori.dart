const String tabelSuperKategori = "notes";

class SuperKategoriFields {
  static final List<String> value = [];
  static const String id = "_id";
  static const String namaKategori = "_namaKategori";
  static const String time = "time";
}

class SuperKategori {
  final int? id;
  final String namaKategori;
  final DateTime createdTime;

  SuperKategori(
      {this.id, required this.namaKategori, required this.createdTime});

  SuperKategori copy({int? id, String? namaKategori, DateTime? createdTime}) {
    return SuperKategori(
        id: id ?? this.id,
        namaKategori: namaKategori ?? this.namaKategori,
        createdTime: createdTime ?? this.createdTime);
  }

  static SuperKategori fromJson(Map<String, Object?> json) {
    return SuperKategori(
        id: json[SuperKategoriFields.id] as int?,
        namaKategori: json[SuperKategoriFields.namaKategori] as String,
        createdTime: DateTime.parse(json[SuperKategoriFields.time] as String));
  }

  Map<String, Object?> toJson() => {
        SuperKategoriFields.id: id,
        SuperKategoriFields.namaKategori: namaKategori,
        SuperKategoriFields.time: createdTime.toString()
      };
}
