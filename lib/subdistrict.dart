import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Create a model class for Subdistrict
class Subdistrict {
  final String id;
  final String name;

  Subdistrict({required this.id, required this.name});

  factory Subdistrict.fromJson(Map<String, dynamic> json) {
    return Subdistrict(
      id: json['id'],
      name: json['name'],
    );
  }
}

//Fetch Subdistricts from API
Future<List<Subdistrict>> fetchSubdistricts(String regencyId) async {
  final response = await http.get(Uri.parse(
      'https://emsifa.github.io/api-wilayah-indonesia/api/districts/$regencyId.json'));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Subdistrict.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Subdistricts: ${response.statusCode}');
  }
}

//Untuk menampilkan SubdistrictListPage kita butuh id dan nama kabupaten yang telah dipilih sebelumnya
class SubdistrictListPage extends StatefulWidget {
  final String regencyId;
  final String regencyName;

  const SubdistrictListPage(
      {super.key, required this.regencyId, required this.regencyName});

  @override
  SubdistrictListPageState createState() => SubdistrictListPageState();
}

class SubdistrictListPageState extends State<SubdistrictListPage> {
  late Future<List<Subdistrict>> _subdistrictsFuture;

  @override
  void initState() {
    super.initState();
    _subdistrictsFuture = fetchSubdistricts(
        widget.regencyId); //Memanggil fetchSubdistricts dengan regencyId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.regencyName} Subdistricts'),
      ),
      body: FutureBuilder<List<Subdistrict>>(
        future: _subdistrictsFuture,
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
