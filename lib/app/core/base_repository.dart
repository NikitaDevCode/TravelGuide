abstract class BaseRepository<T> {
  // Сохрание данных
  Future<void> save(T data);
  // Получение данных
  Future<T?> get();
  // Очистка данных
  Future<void> clear();
}