# 🧾 Factus App

Aplicación móvil desarrollada con **Flutter** que integra los servicios de **Factus API** para la gestión de facturación electrónica.

El proyecto se desarrolla aplicando principios de **Clean Architecture**, manejo de estado con **Riverpod**, consumo de APIs REST y buenas prácticas de desarrollo.

---

## 🚀 Tecnologías

* Flutter
* Dart
* Riverpod
* Dio
* Clean Architecture
* REST API
* OAuth 2.0
* Factus API

---

## 🎯 Objetivo

El objetivo del proyecto es construir una aplicación Flutter capaz de consumir de manera profesional los servicios ofrecidos por **Factus API**.

Entre las funcionalidades previstas se encuentran:

* 🔐 Autenticación
* 🧾 Listado de facturas
* 🔎 Consulta de facturas
* ➕ Creación de facturas
* 📄 Visualización de información
* 📥 Descarga de documentos
* 👤 Gestión de adquirientes/clientes
* ⚠️ Manejo de errores
* 🔄 Manejo de estados
* 🔑 Gestión segura de tokens

---

# 🏗️ Arquitectura

El proyecto utiliza **Clean Architecture**, separando las responsabilidades de la aplicación en diferentes capas.

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   └── network/
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── invoices/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart
```

### Flujo de datos

```text
UI
 ↓
Riverpod
 ↓
Use Case
 ↓
Repository
 ↓
Data Source
 ↓
Dio
 ↓
Factus API
```

## Captura UX

> 📷 Agregar captura del avance de la app

```text
assets/
└── images/
```

![image alt](https://github.com/EndoRodrigo/factus_app/blob/da7ccfde0fe4a8bff1b90f7c2d8857d27dfe1380/assets/images/1.png)

---

# 📱 Funcionalidades

| Funcionalidad           | Estado |
| ----------------------- | ------ |
| Configuración inicial   | ✅      |
| Conexión con Factus     | ✅      |
| Autenticación           | 🚧     |
| Almacenamiento de token | ⏳      |
| Refresh Token           | ⏳      |
| Listado de facturas     | ⏳      |
| Detalle de factura      | ⏳      |
| Crear factura           | ⏳      |
| Clientes / adquirientes | ⏳      |
| Descarga de documentos  | ⏳      |
| Manejo de errores       | ⏳      |
| Tests                   | ⏳      |

**Leyenda:**

* ✅ Completado
* 🚧 En desarrollo
* ⏳ Pendiente
* ❌ No implementado

---

# 🔒 Seguridad

Las credenciales utilizadas para acceder a Factus API **no se incluyen directamente en el repositorio de código fuente**.

Se utiliza un archivo `.env` fuera del control de versiones (basado en el archivo de plantilla `.env.example`):

1. Copia `.env.example` a `.env`:
   ```bash
   cp .env.example .env
   ```
2. Completa tus credenciales de Factus en `.env`.
3. Ejecuta la aplicación cargando el archivo de variables:
   ```bash
   flutter run --dart-define-from-file=.env
   ```

Los tokens de acceso y las credenciales se almacenan de forma encriptada localmente mediante `FlutterSecureStorage`.

---

# 🧪 Testing

Los tests serán agregados progresivamente durante el desarrollo.

Se contemplan:

* Unit tests
* Tests de repositories
* Tests de providers/notifiers
* Tests de widgets
* Tests de integración

Esto permite visualizar la evolución del proyecto de forma cronológica.

---

# 🛠️ Instalación

Clonar el repositorio:

```bash
git clone <URL_DEL_REPOSITORIO>
```

Entrar al proyecto:

```bash
cd factus_app
```

Instalar dependencias:

```bash
flutter pub get
```

Configurar variables de entorno:

```bash
cp .env.example .env
```

Ejecutar cargando el archivo `.env`:

```bash
flutter run --dart-define-from-file=.env
```

---

# 📌 Estado actual

**Fase:** Integración inicial con Factus API

**Progreso:**

```text
████░░░░░░░░░░░░░░░░ 20%
```

Actualmente el proyecto cuenta con:

* Proyecto Flutter
* Riverpod
* Dio
* Clean Architecture inicial
* Configuración de Factus Sandbox
* Cliente HTTP
* Capa de autenticación
* AuthRepository
* AuthNotifier

El siguiente objetivo es completar el flujo de autenticación y posteriormente comenzar con la gestión de facturas.

