import 'package:flutter/material.dart';
import 'package:basic_api/provinces.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          alignment: Alignment.center,
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 86, 162, 153)
              ],
            ),
          ),
        ),
        Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                    onPressed: () {
                      //Navigasi dari homepage ke provinceListPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProvinceListPage()),
                      );
                    },
                    icon: const Icon(
                      Icons.location_on_outlined,
                      color: Color.fromARGB(255, 93, 93, 93),
                    ),
                    label: const Text(
                      'Choose Location',
                      style: TextStyle(color: Color.fromARGB(255, 93, 93, 93)),
                    )),
                Image.asset('assets/id.png', color: Colors.black),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
