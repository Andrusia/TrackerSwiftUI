## Этап разработки

- [x] Залита чистая структура проекта
- [x] Настроен `.gitignore`
- [x] Добавлен `README.md`
- [ ] Обновить Firebase токены
  - разобраться, как устроена авторизация и передача токенов
  - проверить `GoogleService-Info.plist` и `FirebaseApp.configure()`
  - посмотреть, что именно устарело, как обновить
- [ ] Определиться с архитектурой проекта
  - возможно MVVM или модульная организация
  - решить, выносить ли бизнес-логику в `ViewModel` или оставить в `Service`
- [ ] Настроить авторизацию

## 

- SwiftUI
- Firebase (Auth, Firestore, Realtime DB, Storage)
- Cocoapods
- Xcode 15+
- iOS 16+

/TrackerSwiftUI — исходный код
/Services — Firebase-интеграции
/ViewModel — логика отображения
/UI — SwiftUI-интерфейсы

Podfile — зависимости


    
