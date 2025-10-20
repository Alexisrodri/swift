# 🎬 MoviesApp

Una aplicación de películas desarrollada en SwiftUI que utiliza la API de TheMovieDB.

## ✨ Características

- **AppBar personalizado** con el título "MoviesApp"
- **Carrusel de cards** con imágenes y títulos de películas
- **Navegación al detalle** de cada película
- **3 Categorías de películas**: En Cartelera, Próximamente, Mejor Valoradas
- **Paginado automático** para cargar más películas
- **Componente Card independiente** reutilizable

## 🚀 Instalación Rápida

### Opción 1: Clonar el repositorio
```bash
git clone https://github.com/tu-usuario/MoviesApp.git
cd MoviesApp
```

### Opción 2: Descargar ZIP
1. Haz clic en "Code" → "Download ZIP"
2. Extrae el archivo
3. Abre `MoviesApp.xcodeproj` en Xcode

## ⚙️ Configuración

### 1. Obtener API Key de TheMovieDB

1. Ve a [TheMovieDB](https://www.themoviedb.org/)
2. Crea una cuenta gratuita
3. Ve a "Settings" > "API"
4. Solicita una API Key
5. Copia tu API Key

### 2. Configurar la API Key

1. Abre el archivo `Services/MovieAPIService.swift`
2. Reemplaza `"YOUR_API_KEY"` con tu API Key real:

```swift
private let apiKey = "tu_api_key_aqui"
```

## 📁 Estructura del Proyecto

```
MoviesApp/
├── Models/
│   └── Movie.swift              # Modelos de datos
├── Services/
│   └── MovieAPIService.swift   # Servicio de API
├── Components/
│   ├── MovieCard.swift         # Componente Card
│   └── MoviesAppBar.swift      # AppBar personalizado
├── Views/
│   ├── MoviesView.swift        # Vista principal
│   └── MovieDetailView.swift   # Vista de detalle
├── MoviesApp.swift             # Archivo principal
└── README.md                   # Este archivo
```

## 🎯 Funcionalidades Implementadas

### ✅ AppBar
- Título "MoviesApp" con estilo personalizado
- Sombra sutil para profundidad

### ✅ Carrusel de Cards
- Scroll horizontal con indicadores ocultos
- Cards con imagen de póster y título
- Placeholder para imágenes que no cargan
- Tap para navegar al detalle

### ✅ Navegación
- Sheet modal para mostrar detalles de película
- Botón de cerrar en la vista de detalle

### ✅ Categorías (Solo 3)
- Segmented Control para cambiar entre categorías
- **En Cartelera** (now_playing)
- **Próximamente** (upcoming)
- **Mejor Valoradas** (top_rated)

### ✅ Paginado
- Carga automática al llegar al final del carrusel
- Indicador de carga para páginas adicionales
- Manejo de estado de carga y errores

## 📱 Uso

1. Ejecuta la aplicación
2. Selecciona una categoría usando el segmented control
3. Desliza horizontalmente para ver más películas
4. Toca una película para ver sus detalles
5. La aplicación cargará automáticamente más películas cuando llegues al final

## 📋 Requisitos

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+
- API Key de TheMovieDB

## 🔧 Notas Técnicas

- Utiliza `AsyncImage` para cargar imágenes de forma asíncrona
- Implementa `Combine` para manejo de datos reactivo
- Arquitectura MVVM con `ObservableObject`
- Manejo de errores con estados de carga
- Soporte para múltiples idiomas (configurado para español)

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Si encuentras algún bug o tienes una mejora:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 👨‍💻 Autor

Creado con ❤️ para aprender SwiftUI y TheMovieDB API

---

⭐ **¡No olvides darle una estrella al repositorio si te gusta!** ⭐
