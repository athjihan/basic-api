import 'package:basic_api/subdistrict.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Create a model class for Regency
class Regency {
  final String id;
  final String name;

  Regency({required this.id, required this.name});

  factory Regency.fromJson(Map<String, dynamic> json) {
    return Regency(
      id: json['id'],
      name: json['name'],
    );
  }
}

//Fetch Regencies from API
Future<List<Regency>> fetchRegencies(String provinceId) async {
  final response = await http.get(Uri.parse(
      'https://emsifa.github.io/api-wilayah-indonesia/api/regencies/$provinceId.json'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Regency.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Regencies: ${response.statusCode}');
  }
}

//Untuk menampilkan RegencyListPage kita butuh id dan nama provinsi yang telah dipilih sebelumnya
class RegencyListPage extends StatefulWidget {
  final String provinceId;
  final String provinceName;

  const RegencyListPage(
      {super.key, required this.provinceId, required this.provinceName});

  @override
  RegencyListPageState createState() => RegencyListPageState();
}

class RegencyListPageState extends State<RegencyListPage> {
  late Future<List<Regency>> _regenciesFuture;

  @override
  void initState() {
    super.initState();
    _regenciesFuture = fetchRegencies(
        widget.provinceId); //Memanggil fetchRegencies dengan provinceId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.provinceName} Regencies',
          style: TextStyle(),
        ),
      ),
      body: FutureBuilder<List<Regency>>(
        future: _regenciesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  subtitle: Text('ID: ${snapshot.data![index].id}'),
                  onTap: () {
                    //Navigasi ke SubdistrictListPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubdistrictListPage(
                          regencyId: snapshot.data![index].id,
                          regencyName: snapshot.data![index].name,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
