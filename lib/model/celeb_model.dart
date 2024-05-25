class CelebModel {
  final List<Data>? data;

  CelebModel({
    this.data,
  });

  CelebModel.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'data' : data?.map((e) => e.toJson()).toList()
  };
}

class Data {
  final String? nama;
  final String? asal;
  final String? instagram;
  final String? foto;

  Data({
    this.nama,
    this.asal,
    this.instagram,
    this.foto,
  });

  Data.fromJson(Map<String, dynamic> json)
      : nama = json['nama'] as String?,
        asal = json['asal'] as String?,
        instagram = json['instagram'] as String?,
        foto = json['foto'] as String?;

  Map<String, dynamic> toJson() => {
    'nama' : nama,
    'asal' : asal,
    'instagram' : instagram,
    'foto' : foto
  };
}