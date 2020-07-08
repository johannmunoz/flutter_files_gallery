bool checkIfIsImage(String ext) {
  switch (ext.toLowerCase()) {
    case '.png':
    case '.jpeg':
    case '.jpg':
      return true;
    default:
      return false;
  }
}
