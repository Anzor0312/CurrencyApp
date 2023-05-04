import 'package:animeapp/model/currency_model.dart';
import 'package:animeapp/repository/repository.dart';
import 'package:flutter/material.dart';
 

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
      ),
      body: FutureBuilder(
        future: CurrencyRepositoy().chekDatabase(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error is String) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            List<CurrencyModel> data = snapshot.data as List<CurrencyModel>;
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index].title.toString()),
                );
              },itemCount: data.length,
            );
          }
        },
      ),
    );
  }
}
