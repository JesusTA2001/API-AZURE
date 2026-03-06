# API Backend - Sistema de Gestión Escolar

API REST desarrollada con Express.js y MySQL para gestión de sistema escolar de inglés.

## 🚀 Tecnologías

- **Node.js** 18.x
- **Express.js** 4.x
- **MySQL** 8.0 (Azure Database)
- **JWT** para autenticación
- **bcrypt** para encriptación

## 📦 Instalación

```bash
npm install
```

## ▶️ Ejecución

### Desarrollo
```bash
npm run dev
```

### Producción
```bash
npm start
```

## 🔐 Variables de Entorno

Crear archivo `.env` con:

```env
DB_HOST=mysqlingles.mysql.database.azure.com
DB_USER=admin_ingles
DB_PASSWORD=Gui11ermo1
DB_NAME=proyectoIngles
DB_PORT=3306
PORT=5000
JWT_SECRET=tu_clave_secreta_super_segura_2024
NODE_ENV=development
```

## 📚 API Endpoints

### Autenticación
- `POST /api/auth/login` - Login de usuario
- `GET /api/auth/verify` - Verificar token

### Alumnos
- `GET /api/alumnos` - Listar alumnos
- `GET /api/alumnos/:id` - Obtener alumno
- `POST /api/alumnos` - Crear alumno
- `PUT /api/alumnos/:id` - Actualizar alumno
- `DELETE /api/alumnos/:id` - Eliminar alumno

### Profesores
- `GET /api/profesores` - Listar profesores
- `POST /api/profesores` - Crear profesor
- (CRUD completo disponible)

### Grupos
- `GET /api/grupos` - Listar grupos
- `POST /api/grupos` - Crear grupo
- `POST /api/grupos/:id/estudiantes` - Asignar alumnos
- (CRUD completo disponible)

### Otros módulos
- `/api/administradores`
- `/api/niveles`
- `/api/periodos`
- `/api/horarios`
- `/api/asistencias`
- `/api/calificaciones`

## 🧪 Testing

```bash
npm test
```

## 📄 Licencia

ISC
