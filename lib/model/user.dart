class User {
  String? userName;
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNo;
  String? profilePic;

  User(
      {this.userName,
      this.userId,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNo,
      this.profilePic});

  factory User.fromResponse(dynamic response) {
    //
    int code = response.statusCode;
    dynamic body = response.data ?? null; // Would mostly be a Map
    String username = "";
    String userId = "";
    String firstName = "";
    String lastName = "";
    String email = "";
    String phoneNo = "";
    String profilePic = "";
    //List errors = [];
    //String message = "";

    switch (code) {
      case 200:
        try {
          //message = body["message"];
          username = body["username"];
          userId = body["id"];
          firstName = body["firstname"];
          lastName = body["lastname"];
          email = body["email"];
          phoneNo = body["phoneno"];
          profilePic = body["profilepic"];
        } catch (error) {
          print("Message reading error ==> $error");
        }

        break;
      default:
        //message = "Whoops! Something went wrong, please contact support.";
        //errors.add(message);
        break;
    }

    return User(
        //message: message,
        userName: username,
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNo: phoneNo,
        profilePic: profilePic
        //errors: errors,
        );
  }
}
