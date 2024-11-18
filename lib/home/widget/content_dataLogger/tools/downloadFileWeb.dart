import 'dart:html';

void downloadFile(String url, String fileName){
  // var url = Url.createObjectUrlFromBlob(Blob([data]));
  AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
}