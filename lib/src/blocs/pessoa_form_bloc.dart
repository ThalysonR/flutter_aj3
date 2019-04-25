import 'package:rxdart/rxdart.dart';
import 'dart:io';

class PessoaFormBloc {
  final _photoFetcher = BehaviorSubject<File>();

  Observable<File> get photo => _photoFetcher.stream;

  savePhoto(File file) {
    _photoFetcher.sink.add(file);
  }

  dispose() {
    _photoFetcher.close();
  }
}