import 'package:intl/intl.dart';

final String tableName = 'myTable';

class NoteFields {
  static final List<String> values = [
    columnId,
    columnIndex,
    columnsany,
    produtId,
    pricePro,
    name,
    nameru,
    img,
    brandname,
    brandnameru,
    stok,
  ];
  static final String columnIndex = "sn";
  static final String columnId = "ID";
  static final String pricePro = "Price";
  static final String produtId = "ProductId";
  static final String columnsany = "SANY";
  static final String img = "Surat";
  static final String name = "Ady";
  static final String nameru = "NameRu";
  static final String brandname = "Brand";
  static final String brandnameru = "BrandRu";
  static final String stok = "Stok";
}

class Note {
  final int? id;
  final int? index;
  final int? indexpro;
  final String? idPro;
  final double? price;
  final String? img;
  final String? name;
  final String? nameRu;
  final String? brandName;
  final String? brandNameRu;
  final int? stok;

  const Note(
      {this.img,
      this.name,
      this.brandName,
        this.nameRu,
        this.brandNameRu,
      this.stok,
      this.idPro,
      this.id,
      this.index,
      this.indexpro,
      this.price});

  Note copy({
    int? id,
    int? index,
    int? indexpro,
    String? idPro,
    double? price,
    String? img,
    String? name,
    String? brandName,
    String? nameRu,
    String? brandNameRu,
    int? stok,
  }) =>
      Note(
          id: id ?? this.id,
          index: index ?? this.index,
          indexpro: indexpro ?? this.indexpro,
          idPro: idPro ?? this.idPro,
          price: price ?? this.price,
          img: img ?? this.img,
          name: name ?? this.name,
          brandName: brandName ?? this.brandName,
          nameRu: nameRu ?? this.nameRu,
          brandNameRu: brandNameRu ?? this.brandNameRu,
          stok: stok ?? this.stok);

  static Note fromJson(Map<String, Object?> json) => Note(
      id: json[NoteFields.columnId] as int?,
      index: json[NoteFields.columnIndex] as int?,
      indexpro: json[NoteFields.columnsany] as int?,
      idPro: json[NoteFields.produtId] as String?,
      price: json[NoteFields.pricePro] as double?,
      img: json[NoteFields.img] as String?,
      name: json[NoteFields.name] as String?,
      brandName: json[NoteFields.brandname] as String?,
      nameRu: json[NoteFields.nameru] as String?,
      brandNameRu: json[NoteFields.brandnameru] as String?,
      stok: json[NoteFields.stok] as int?);

  Map<String, Object?> toJson() => {
        NoteFields.columnId: index,
        NoteFields.produtId: idPro,
        NoteFields.columnsany: indexpro,
        NoteFields.pricePro: price,
        NoteFields.name: name,
        NoteFields.brandname: brandName,
    NoteFields.nameru: nameRu,
    NoteFields.brandnameru: brandNameRu,
        NoteFields.stok: stok,
        NoteFields.img: img
      };
}
