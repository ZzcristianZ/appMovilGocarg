# Contexto del proyecto GoCarg — para Claude Code

Este documento resume todo lo acordado y construido hasta ahora en el apartado de diseño/UI de GoCarg, en una sesión de chat con Claude (no Claude Code). Repo: https://github.com/ZzcristianZ/appMovilGocarg — rama principal `main` (tiene todo lo descrito aquí); `rama_cris` no tiene cambios de fondo sobre `main`.

## 1. Qué es GoCarg

App móvil en Flutter para conectar usuarios que requieren servicios de transporte de carga con conductores de vehículos de carga, en el municipio de Ocaña (Norte de Santander, Colombia).

**Problema que resuelve:** en Ocaña el transporte de carga opera de forma informal (contacto directo o recomendación verbal), lo que genera tarifas opacas, tiempos de espera largos y desconfianza en la seguridad de la carga. Los conductores independientes tienen tiempos muertos entre viajes y dificultad para conseguir clientes por falta de un canal digital centralizado.

**ODS a los que apunta:** ODS 8 (trabajo decente), ODS 9 (industria e innovación), ODS 11 (ciudades sostenibles).

**Alcance actual confirmado:** solo conexión cliente-conductor, contacto directo, sin pago dentro de la app y sin backend real todavía — todo lo construido hasta ahora es la capa de diseño/UI, navegable con datos de muestra (mocks), sin lógica de negocio real.

**Decisiones que el proyecto AÚN NO ha tomado (no asumir nada sobre esto sin preguntar):**

- Si GoCarg solo conecta cliente-conductor o también administra contratación, pago y seguimiento del servicio.
- La categorización definitiva de tipo de camión / tipo de carga (hoy hay una versión provisional, ver sección 5).
- Riesgos operativos, legales y de seguridad — si los conductores estarán vinculados a una empresa o serán independientes.

## 2. Arquitectura general

- Flutter + Riverpod (v3, API `Notifier`, no `StateProvider` que quedó legacy) + go_router.
- Dos flujos de UI completamente separados por rol: Cliente y Conductor, cada uno con su propio `Shell` (AppBar + BottomNav) y su propio color de acento (ver sistema de diseño).
- Estructura de carpetas por rol dentro de `lib/presentation/screens/`: `auth/`, `cliente/`, `conductor/`. Cada subcarpeta de pantalla trae su propio shell/home/historial/perfil, etc.
- Archivos de barril: cada carpeta relevante tiene un archivo que reexporta todo lo de esa carpeta, para no acumular decenas de imports sueltos en archivos como `router.dart`:
  - `lib/config/theme/theme.dart`
  - `lib/config/router/routing.dart` (solo reexporta `app_routes.dart`, no el router completo)
  - `lib/presentation/widgets/widgets.dart`
  - `lib/presentation/providers/providers.dart`
  - `lib/presentation/screens/auth/auth.dart`
  - `lib/presentation/screens/cliente/cliente.dart` (reexporta también `solicitud/solicitud.dart`)
  - `lib/presentation/screens/conductor/conductor.dart`

**Regla acordada:** todo código nuevo debe importar a través de estos barriles cuando el import es de OTRA carpeta. Dentro de la misma carpeta (ej. dos archivos dentro de `cliente/solicitud/`) se importan directo entre sí para evitar ciclos de import con el propio barril.

**Pendiente:** `selector_ubicacion_screen.dart` y `cliente_home_view.dart` todavía importan archivos individuales en vez de los barriles — falta ese ajuste.

## 3. Sistema de diseño

- **Paleta** (`lib/config/theme/app_colors.dart`): construida desde el vocabulario del transporte de carga, no colores genéricos de plantilla.
  - `Ruta` `#1E4B72` (azul acero) — marca, confianza, formalidad.
  - `Carga` `#E8901F` (ámbar) — acento del rol Cliente.
  - `Ruta Verde` `#2F7D5C` — acento del rol Conductor.
  - Enum `GoCargRole { cliente, conductor }` con extensión que da `.acento`, `.acentoSuave`, `.acentoTexto`, `.onAcento` — así cada pantalla nueva no reinventa estos colores.
- **Tipografía** (`app_typography.dart`): IBM Plex Sans para toda la interfaz (vía `google_fonts`), IBM Plex Mono reservado para cifras (tarifas, distancias, ETA, placas) vía `AppTypography.dato(...)` — decisión funcional (cifras tabulares se comparan más rápido), no decorativa.
- **Componentes compartidos** (`lib/presentation/widgets/`):
  - `GoCargAppBar`, `GoCargBottomNav` — usados por ambos shells, parametrizados por color de acento. `GoCargBottomNav` tenía un bug donde el ripple del `InkWell` (sin recortar) y la píldora de color del ítem seleccionado (con margen propio) tenían tamaños distintos, y se veían como "dos sombras" superpuestas al presionar; se corrigió envolviendo ambos en el mismo `Material` con `clipBehavior: Clip.antiAlias` y el mismo `borderRadius`, para que compartan el mismo recorte.
  - `RouteTicketCard` — tarjeta "ticket de ruta" (origen→destino con línea punteada), pieza central del flujo de solicitud, en vez de una card genérica de foto+texto.
  - `ProximamenteView` — placeholder para pantallas de fases futuras (mantiene la app navegable sin romper rutas).
  - `GoCargMap` — mapa real reutilizable (ver sección 4).
  - `mock_map_background.dart` y `side.dart` — código huérfano, ya no se usan (el mapa mock fue reemplazado por el real). Quedan sin borrar, pendiente de limpieza.

## 4. Mapa real (implementado, sin API key)

Se reemplazó el mapa "mock" (dibujado) por un mapa real usando OpenStreetMap, sin necesidad de cuenta ni API key de Google:

- `flutter_map` + `latlong2` — tiles de OSM (`https://tile.openstreetmap.org/{z}/{x}/{y}.png`, `userAgentPackageName: com.example.gocarg` — actualizar si cambia el `applicationId` del proyecto).
- `geolocator` — ubicación actual del dispositivo (botón "usar mi ubicación").
- `geocoding` — usa el geocoder nativo del sistema (Android/iOS), sin API key: `locationFromAddress` (buscar dirección → coordenadas) y `placemarkFromCoordinates` (coordenadas → dirección legible).
- Permisos ya agregados: `ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION` / `INTERNET` en `AndroidManifest.xml`, `NSLocationWhenInUseUsageDescription` en `Info.plist`.
- Centro por defecto: Ocaña (`ocanaCentro`, lat 8.2394 / lng -73.3573, en `gocarg_map.dart`).

**Corregido:** el filtro de `Placemark` en `selector_ubicacion_screen.dart` (`_confirmar()`) usaba `.where((s) => s!.isNotEmpty)`, que podía reventar si `subLocality` venía null. Ahora usa `.whereType<String>().where((s) => s.isNotEmpty)`.

## 5. Flujo del Cliente — solicitar un flete (implementado)

Orden importante y ya decidido: primero se ve disponibilidad, y solo después de elegir conductor se llena el formulario de la solicitud (NO al revés):

1. **Home cliente** (`cliente_home_view.dart`) — accesos rápidos "Camión de carga" / "Moto carga" llevan a Disponibilidad pasando el `TipoVehiculo` elegido.
2. **Disponibilidad** (`disponibilidad_screen.dart`) — mapa real con pines de conductores + lista filtrada por `TipoVehiculo`. Datos de muestra en `conductor_disponible.dart`. **Sin precio visible** en los tiles — la tarifa no existe todavía en este punto del flujo.
3. **Detalle del conductor** (`detalle_conductor_screen.dart`) — perfil del conductor/vehículo, sin tarifa. Nota explícita: "El precio se acuerda con el conductor después de enviar la solicitud." Botón "Elegir este conductor y continuar".
4. **Nueva solicitud** (`nueva_solicitud_screen.dart`) — el conductor ya viene elegido (llega por `extra`); aquí se define origen/destino (con el mapa real vía `selector_ubicacion_screen.dart`), peso aproximado y fecha/hora. Se guarda todo en `solicitudEnProgresoProvider`. **Ya no pide "tipo de carga"** (se quitó por decisión del proyecto: la empresa no maneja categorías como "Refrigerada" por ahora).
5. **Confirmación** (`confirmacion_solicitud_screen.dart`) — resumen final (ticket de ruta + conductor), sin tarifa, con la misma nota de que el precio se negocia después. Al confirmar, pasa la `SolicitudFlete` completa (vía `extra`) a Seguimiento — antes se perdía porque se limpiaba el provider justo antes de navegar.
6. **Seguimiento** (`seguimiento_screen.dart`) — implementado (Fase 3): línea de tiempo de estados (confirmada → conductor en camino → carga recogida → en ruta → entregada) que avanza sola cada 4s para poder demostrar el flujo sin backend; mapa con el conductor; acceso al chat; nota de que la tarifa se acuerda por chat; al llegar a "entregada" aparece el CTA "Calificar viaje".
7. **Chat con el conductor** (`chat_conductor_screen.dart`, nuevo) — chat local (sin backend) donde se modela la negociación de tarifa; el conductor abre proponiendo un valor.
8. **Calificar servicio** (`calificar_servicio_screen.dart`, nuevo) — estrellas (1-5) + comentario opcional, solo local.

**Modelo extensible de tipo de vehículo** (`tipo_vehiculo.dart`): enum `TipoVehiculo` con `camion` y `moto` por ahora — está preparado para agregar más tipos (ej. camioneta, tractomula) sin tocar el resto del flujo, ya que Disponibilidad/Detalle/Formulario iteran sobre la lista completa del enum.

**Política de tarifa (decidida):** ningún precio se muestra antes de enviar la solicitud. La tarifa la propone/negocia el conductor con el cliente por el chat una vez que el conductor recibe la solicitud — no es un valor fijo por conductor. `ConductorDisponible` ya no tiene campo de tarifa. En cambio, un viaje ya **finalizado** (Historial) sí guarda `tarifaFinal`, porque para ese punto ya fue acordada.

## 6. Estado por fases del plan de diseño

- **Fase 0 — Arquitectura de roles y limpieza:** ✅ completa. Se separó el flujo Cliente/Conductor en el router, se resolvió la confusión entre el shell y la vista de home, se separó perfil cliente/conductor en archivos distintos.
- **Fase 1 — Onboarding y acceso compartido:** ✅ completa. Splash, selección de rol (`GoCargRole`), Login (sin backend real — el botón navega directo al dashboard del rol elegido, solo para poder probar el flujo visualmente).
- **Fase 2 — Cliente: solicitar un flete:** ✅ completa, con el mapa real y el flujo de disponibilidad-primero descritos arriba (esto fue una mejora pedida después de la primera versión de la fase, que hacía el formulario completo antes de buscar).
- **Fase 3 — Cliente: seguimiento y cierre:** ✅ completa (como diseño/UI, sin backend). Seguimiento real (estado simulado, mapa, chat), Chat con el conductor (`chat_conductor_screen.dart`), Calificar servicio (`calificar_servicio_screen.dart`), Historial de solicitudes/viajes con datos de muestra (`historial/viaje_historial.dart`) + Detalle de un viaje pasado (`historial/detalle_viaje_screen.dart`), Perfil cliente terminado: estadísticas derivadas del historial mock, botón "Cerrar sesión" funcional (vuelve a selección de rol), tile "Apariencia" ya conectado a `themeProvider` (switch de modo oscuro real), el resto de opciones (Editar perfil, Seguridad, Notificaciones, Idioma, Centro de ayuda, Acerca de) navegan a una pantalla "Próximamente" en vez de quedar muertas — su contenido real es Fase 6.
- **Fase 4 — Conductor: atender solicitudes:** ⏳ pendiente. Dashboard conductor con toggle disponible/no disponible (reemplazar el stub), Feed de solicitudes cercanas (reemplazar el stub), Detalle de solicitud (aceptar/rechazar), Viaje en curso. Reutiliza el mapa real y el `RouteTicketCard` ya construidos en la Fase 2.
- **Fase 5 — Conductor: cierre y gestión:** ⏳ pendiente. Chat con el cliente, Historial de servicios, Calificaciones/reputación, Perfil conductor (reemplazar el stub — necesita campos de vehículo y documentos que el cliente no tiene), Gestión de vehículo(s), Documentos/verificación.
- **Fase 6 — Transversal y soporte:** ⏳ pendiente. Notificaciones, Ajustes (modo oscuro — el toggle ya existe en `theme_provider.dart`, falta la pantalla que lo use; notificaciones; cerrar sesión), Estados vacíos, Pantalla de error/sin conexión, Ayuda/soporte, Términos y condiciones.

**Descartado por ahora** (no construir salvo que se pida explícitamente): onboarding tipo "intro a la app", registro de cliente/conductor, verificación por OTP, recuperar contraseña.

## 7. Convenciones a mantener en todo lo que sigue

- Arquitectura limpia por carpetas de rol (`cliente/`, `conductor/`, `auth/`), un archivo de barril por carpeta, imports entre carpetas siempre vía barril.
- Sin backend real todavía — todo con datos de muestra (`const ... Mock` o listas hardcodeadas), pero dejando comentarios de dónde se conecta el backend real después.
- `flutter_lints` con `curly_braces_in_flow_control_structures` activo: todo `if`/`else` de una sola línea debe llevar llaves, incluso los más triviales (`if (x) return;` también aplica).
- No usar Google Maps — el mapa real del proyecto es OpenStreetMap vía `GoCargMap` (`lib/presentation/widgets/gocarg_map.dart`, ya exportado en el barril `widgets.dart`); reutilizar ese widget para cualquier pantalla nueva que necesite mapa (Fase 3: seguimiento, ya hecho; Fase 4: feed de solicitudes conductor).
- Colores/tipografía: nunca hardcodear un color o fuente suelta — siempre `AppColors`, `AppTypography.dato(...)`, o `rol.acento` / `rol.acentoSuave` del enum `GoCargRole`.
- **Nunca usar `colors.outline` como color de texto o de un ícono que deba notarse.** `outline` es un gris muy claro pensado solo para bordes; para texto secundario/labels usar `colors.onSurfaceVariant`. Ya se corrigió esta confusión en Home, Perfil y el bottom nav del cliente (era la causa de "letras casi invisibles" reportada en pruebas en dispositivo).
- `AppTypography.dato(...)` tiene un color por defecto (`AppColors.textoPrimario`) que NO es theme-aware — es correcto en modo claro pero se volvería ilegible en modo oscuro si se le llama sin `color:`. Siempre pasar `color: colors.onSurface` (o el que corresponda) explícitamente al usarlo.
- No mostrar ningún precio antes de enviar la solicitud (ver sección 5, "Política de tarifa").

## 8. Limpieza pendiente (deuda técnica menor)

- Decidir qué hacer con `lib/presentation/widgets/side.dart` (clase `Side`, no se usa en ningún lado, parece resto de plantilla) y `mock_map_background.dart` (ya no se usa, reemplazado por `gocarg_map.dart`).
- Migrar `cliente_home_view.dart` a importar por barril donde corresponda (sección 2) — `selector_ubicacion_screen.dart` y el bug de null-safety que tenía ya se corrigieron.
