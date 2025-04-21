void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  searchRadius -= e * 3;
}
