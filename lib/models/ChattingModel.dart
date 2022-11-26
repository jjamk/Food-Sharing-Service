class ChattingModel{
  ChattingModel(this.pk, this.name, this.text, this.uploadTime);
  final String pk;
  final String name;
  final String text;
  final int uploadTime;

  factory ChattingModel.fromJson(Map<String, dynamic> json){
    return ChattingModel(json['pk'], json['name'], json['text'], json['uploadTime']);
  }

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      'pk':pk,
      'name':name,
      'text':text,
      'uploadTime':uploadTime,
    };
  }
}