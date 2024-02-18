import 'package:algolia/algolia.dart';


class SearchResultsModel {
  final String name;
  final int endDate;

  const SearchResultsModel({
    required this.name,
    required this.endDate,
  });


  //TODO - We don't need to retrieve tags BUT we want them to be queried with names, but nothing else
  //Maps data from Algolia JSON data to UserDataModel
  factory SearchResultsModel.fromAlgolia(AlgoliaObjectSnapshot snapshot) { //SnapshotOptions? options <-Another argument you can add
    print("Converting search results to data model");
    print(snapshot);
    return SearchResultsModel(
        name: snapshot.data['Name'],
        endDate: snapshot.data['EndDate']
    );
  }

  @override
  String toString() {
    return 'SearchResultsModel: $name and date $endDate';
  }

}


