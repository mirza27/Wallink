const String tabelSubKategori = "notes";

class SubKategoriFields {
  static final List<String> value = [];
  static const String id = "_id";
  static const String namaSubKategori = "_namaSubKategori";
  static const String time = "time";
  static const String superKategoriId = "_superKategoriId"; // Foreign key
}

class SubKategori {
  final int? id;
  final String namaSubKategori;
  final DateTime createdTime;
  final int? superKategoriId; // Foreign key

  SubKategori({
    this.id,
    required this.namaSubKategori,
    required this.createdTime,
    this.superKategoriId, // Foreign key
  });

  SubKategori copy({int? id, String? namaSubKategori, DateTime? createdTime}) {
    return SubKategori(
        id: id ?? this.id,
        namaSubKategori: namaSubKategori ?? this.namaSubKategori,
        createdTime: createdTime ?? this.createdTime);
  }

  static SubKategori fromJson(Map<String, Object?> json) {
    return SubKategori(
        id: json[SubKategoriFields.id] as int?,
        namaSubKategori: json[SubKategoriFields.namaSubKategori] as String,
        createdTime: DateTime.parse(json[SubKategoriFields.time] as String));
  }

  Map<String, Object?> toJson() => {
        SubKategoriFields.id: id,
        SubKategoriFields.namaSubKategori: namaSubKategori,
        SubKategoriFields.time: createdTime.toString()
      };
}
