import 'package:flutter/material.dart';
import 'package:projek_akhir_tpm/api_data_source.dart';
import 'package:projek_akhir_tpm/model/celeb_model.dart';
import 'package:projek_akhir_tpm/ticket.dart';

class CelebListPage extends StatefulWidget {
  const CelebListPage({super.key});

  @override
  State<CelebListPage> createState() => _CelebListPageState();
}

class _CelebListPageState extends State<CelebListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet & Greet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.pinkAccent.shade100,
        centerTitle: true,
        elevation: 0,
      ),
      body:_buildListCelebBody(),
    );
  }

  Widget _buildListCelebBody() {
    return FutureBuilder(
      future: ApiDataSource.instance.loadCeleb(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          // Jika data ada error maka akan ditampilkan hasil error
          return _buildErrorSection();
        }
        if (snapshot.hasData) {
          // Jika data ada dan berhasil maka akan ditampilkan hasil datanya
          CelebModel celebModel =
          CelebModel.fromJson(snapshot.data);
          return _buildSuccessSection(celebModel);
        }
        return _buildLoadingSection();
      },
    );
  }

  Widget _buildErrorSection() {
    return const Text("Error builderrorsection");
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(CelebModel dataModel) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
              color: Colors.pinkAccent.shade100,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(100))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListTile(
                title: Text("Jadwal Meet & Greet Selebriti", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                trailing: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.account_box, color: Colors.pinkAccent, size: 40,),
                ),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
        Container(
          color: Colors.pinkAccent.shade100,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 40,
                crossAxisSpacing: 15,
              ),
              itemCount: dataModel.data!.length,
              itemBuilder: (context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(3, 5),
                          color: Colors.pinkAccent,
                          spreadRadius: 1,
                          blurRadius: 3,
                        )
                      ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(dataModel.data![index].foto!, width: 50, height: 70, fit: BoxFit.cover,),
                      Text(dataModel.data![index].nama!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center,),
                      ElevatedButton(
                        onPressed: () {
                          // Navigasi ke halaman detail beli tiket
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TicketPurchasePage(celeb: dataModel, i: index)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          fixedSize: Size(100, 10),
                        ),
                        child: Text('Details', style: TextStyle(color: Colors.white, fontSize: 15),),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
