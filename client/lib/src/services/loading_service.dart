class LoadingService {
  bool loading = false;

  void setLoading() {
    loading = true;
  }

  void setLoaded() {
    loading = false;
  }

  bool isLoading() {
    return loading;
  }
}
