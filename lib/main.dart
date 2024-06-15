import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hasan Semih Temer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Yemek Sitesi'),
    );
  }
}

class Yemekler {
  int yemek_id;
  String yemek_adi;
  String yemek_resim_adi;
  int yemek_fiyat;
  List<String> icindekiler;

  Yemekler(this.yemek_id, this.yemek_adi, this.yemek_resim_adi, this.yemek_fiyat, this.icindekiler);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Yemekler>> yemekleriGetir() async {
    var yemekListesi = <Yemekler>[];

    var y1 = Yemekler(1, "köfte", "r1.jpeg", 16, ["Kıyma", "Baharatlar", "Ekmek"]);
    var y2 = Yemekler(2, "ayran", "r2.png", 2, ["Yoğurt", "Su", "Tuz"]);
    var y3 = Yemekler(3, "tulumba", "r3.jpeg", 5, ["Un", "Şeker", "Yağ", "Su"]);

    yemekListesi.addAll([y1, y2, y3]);

    return yemekListesi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Yemekler>>(
        future: yemekleriGetir(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var yemekListesi = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: yemekListesi.length,
              itemBuilder: (context, index) {
                var yemek = yemekListesi[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetaySayfa(
                          yemek: yemek,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Image.asset("img/${yemek.yemek_resim_adi}", fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("${yemek.yemek_adi}", style: TextStyle(fontSize: 20)),
                              Text("${yemek.yemek_fiyat.toStringAsFixed(2)} TL", style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class DetaySayfa extends StatelessWidget {
  final Yemekler yemek;

  const DetaySayfa({Key? key, required this.yemek}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Ürün Detayı"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("img/${yemek.yemek_resim_adi}", width: 200, height: 200),
            SizedBox(height: 20),
            Text(yemek.yemek_adi, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("${yemek.yemek_fiyat.toStringAsFixed(2)} TL", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("Sipariş verildi: ${yemek.yemek_adi}");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SepetPage(
                      yemek: yemek,
                    ),
                  ),
                );
              },
              child: Text("Sipariş Ver"),
            ),
          ],
        ),
      ),
    );
  }
}

class SepetPage extends StatelessWidget {
  final Yemekler yemek;

  const SepetPage({Key? key, required this.yemek}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Ürün Detayı"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("img/${yemek.yemek_resim_adi}", width: 200, height: 200),
            SizedBox(height: 20),
            Text(yemek.yemek_adi, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 50),
            Text("İçindekiler:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            for (var icindekiler in yemek.icindekiler)
              Text(icindekiler, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            PopupMenuButton<int>(
              onSelected: (value) {
                int tutar = yemek.yemek_fiyat * value;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tutar: ${tutar.toStringAsFixed(0)} TL')));
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("1"),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("2"),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text("3"),
                ),
                PopupMenuItem(
                  value: 4,
                  child: Text("4"),
                ),
              ],
              child: Icon(Icons.macro_off_sharp),
            ),
            ElevatedButton(
              onPressed: () {
                print("Sipariş verildi: ${yemek.yemek_adi}");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Siparişiniz Alındı')));
              },
              child: Text("Sipariş Ver"),
            ),
          ],
        ),
      ),
    );
  }
}