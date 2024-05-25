import 'package:projek_akhir_tpm/base_network.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();
  //untuk list celeb
  Future<Map<String, dynamic>> loadCeleb() {
    return BaseNetwork.get("api/selebgram-indo");
  }
}
