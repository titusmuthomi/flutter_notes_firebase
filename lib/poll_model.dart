class Poll {
  final String contestant1;
  final String contestant2;

  Poll({
    required this.contestant1,
    required this.contestant2,
  });

  Map<String, dynamic> toJson() => {
        'contestant1': contestant1,
        'contestant2': contestant2,
      };

  static Poll fromJson(Map<String, dynamic> json) => Poll(
        contestant1: json['contestant1'],
        contestant2: json['contestant2'],
      );
}
