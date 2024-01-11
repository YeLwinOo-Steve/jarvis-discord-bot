// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);


class Chat {
  String? status;
  String? output;

  Chat({
    this.status,
    this.output,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    status: json["status"],
    output: json["output"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "output": output,
  };
}
