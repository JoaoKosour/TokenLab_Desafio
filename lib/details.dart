import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'dart:convert';

//FUNCAO AUXILIAR PARA USAR O METODO GET EM UM FILME EXPECIFICO
Future<Movie> fetchDetails(int id) async {
  String detailsAPI;
  detailsAPI = apiLink + '/' + id.toString(); //CONCATENA A API AO ID DO FILME
  final response = await http.get(detailsAPI);
  if (response.statusCode == 200) {
    return Movie.fromJson(json.decode(response.body));
  } else //TRATA OS ERROS AO USAR O GET
    throw Exception('Error loading details.');
}

class Details extends StatelessWidget {
  final Future<Movie> movieDetails;

  const Details(
      {Key key,
      @required this.movieDetails}); //REQUER AS INFORMAÇOES DE UM FILME

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokenLab',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        body: Container(
          color: Color.fromARGB(255, 25, 25, 25),
          child: FutureBuilder(
              future: movieDetails,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data ==
                    null) // MOSTRA PARA O USUARIO CASO ESTEJAMOS CARREGANDO DADOS
                  return Container(
                      child: Center(child: CircularProgressIndicator()));
                else
                  return Scaffold(
                    backgroundColor: Color.fromARGB(255, 25, 25, 25),
                    appBar: AppBar(
                      title: Text(
                        snapshot.data.title,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    body: Center(
                      // LISTA DE INFORMAÇOES DISPONIBILIZADAS AO USUARIO
                      child: Column(
                        children: <Widget>[
                          Image.network(
                            snapshot.data.url,
                          ),
                          for (var i = 0; i < snapshot.data.genres.length; i++)
                            Text(
                              snapshot.data.genres[i],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          Text(
                            'Duration: ' +
                                snapshot.data.duration.toString() +
                                'minutes.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Rating: ' + snapshot.data.voteAverage.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Votes: ' + snapshot.data.voteCount.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                '\n' + snapshot.data.description,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
              }),
        ),
      ),
    );
  }
}
