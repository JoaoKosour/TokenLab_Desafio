import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details.dart';

String apiLink = 'https://desafio-mobile.nyc3.digitaloceanspaces.com/movies';

Future<List<Movie>> fetchMovie() async {
  final response = await http.get(apiLink);
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    List<Movie> movieList = new List();
    for (var mov in data) {
      Movie newMovie = Movie.fromJson(mov);
      movieList.add(newMovie);
    }
    return movieList;
  } else // TRATA ERROS NO GET
    throw Exception('Error loading.');
}

class Movie {
  final int id;
  final double voteAverage;
  final String title;
  final String url;
  final List<String> genres;
  final date;
  // ESSAS INFORMAÇOES NAO SAO FINAL POIS SAO ATUALIZADAS NA CHAMADA MAIS ESPECIFICA, USANDO O ID DO FILME.
  String description;
  String tagline;
  int voteCount;
  int revenue;
  int duration;

  Movie(
      {this.id,
      this.url,
      this.title,
      this.voteAverage,
      this.genres,
      this.date,
      this.description,
      this.revenue,
      this.tagline,
      this.voteCount,
      this.duration});

  factory Movie.fromJson(Map<String, dynamic> json) {
    var genresJson = json['genres'];
    List<String> genresList = genresJson.cast<String>();
    var jsonDate = json['release_date'];
    var dateParse = DateTime.parse(jsonDate);

    return new Movie(
        id: json['id'],
        voteAverage: json['vote_average'],
        title: json['title'],
        url: json['poster_url'],
        genres: genresList,
        date: dateParse,
        description: json['overview'],
        tagline: json['tagline'],
        voteCount: json['vote_count'],
        revenue: json['revenue'],
        duration: json['runtime']);
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Movie>> futureMovie;

  @override
  void initState() {
    super.initState();
    futureMovie = fetchMovie();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokenLab',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
            title: Center(
                child:
                    Text('TokenLab Movie App', textAlign: TextAlign.center))),
        body: Container(
          color: Color.fromARGB(255, 25, 25, 25),
          child: FutureBuilder(
            future: futureMovie,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null)
                return Container(
                    child: Center(child: CircularProgressIndicator()));
              else
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data[index].url)),
                        title: Text(
                          snapshot.data[index].title,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Details(
                                      movieDetails: fetchDetails(
                                          snapshot.data[index].id))));
                        },
                      );
                    });
            },
          ),
        ),
      ),
    );
  }
}
