// ignore_for_file: lines_longer_than_80_chars

/// This is a custom Exception class, used to indicate a failed repository operation.
class RepositoryException implements Exception {

  //Simple constructor for creating an exception by passing the cause message.
  RepositoryException(this.cause);
  // The cause of the exception or the message it brings.
  String cause;
}
