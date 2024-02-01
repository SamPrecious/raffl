// Models the user
//TODO https://www.youtube.com/watch?v=LlQimtjqZ9A&list=PL5jb9EteFAODvqwaicjK4ZhzIKS6gtcd5&index=2 Reference video
class UserDataModel {
  final String uid;
  final int credits;

  const UserDataModel({
    required this.uid,
    required this.credits,
  });

  //JSON format for FireStore
  toJson(){
    return{
      "UID": uid,
      "Credits": credits,
    };
  }
}