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
docs/
└── screenshots/
    └── 03_autenticacion.png
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

Las credenciales utilizadas para acceder a Factus API **no deben incluirse directamente en el repositorio**.

Para desarrollo se utilizan variables:

```bash
--dart-define=FACTUS_CLIENT_ID=...
--dart-define=FACTUS_CLIENT_SECRET=...
--dart-define=FACTUS_USERNAME=...
--dart-define=FACTUS_PASSWORD=...
```

Los tokens de autenticación serán almacenados posteriormente utilizando almacenamiento seguro.

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

Ejecutar:

```bash
flutter run
```

Para ejecutar utilizando las credenciales del ambiente Sandbox:

```bash
flutter run \
  --dart-define=FACTUS_CLIENT_ID=TU_CLIENT_ID \
  --dart-define=FACTUS_CLIENT_SECRET=TU_CLIENT_SECRET \
  --dart-define=FACTUS_USERNAME=TU_USUARIO \
  --dart-define=FACTUS_PASSWORD=TU_PASSWORD
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

