class Userrs {
  final String email;

  final String username;
  final String bio;
  final List followers;
  final List following;

  Userrs(this.username, this.bio, this.followers, this.following,
      {required this.email});

  Map<String, dynamic> tojson() => {
        'username': username,
        'email': email,
        'bio': bio,
        'followers': followers,
        'following': following
      };
}
