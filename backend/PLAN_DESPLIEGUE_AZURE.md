# 🚀 PLAN DE DESPLIEGUE A AZURE APP SERVICE

**Fecha:** 3 de diciembre de 2025  
**Objetivo:** Desplegar API Express.js a Azure App Service con GitHub Actions

---

## 📋 RESUMEN EJECUTIVO

### ✅ Lo que ya tienes listo:
- ✅ API funcionando localmente
- ✅ Conexión a MySQL Azure configurada
- ✅ 10 módulos API operativos
- ✅ Autenticación JWT implementada
- ✅ CORS configurado para producción

### 🎯 Lo que vamos a hacer:
1. Preparar el proyecto para Azure
2. Conectar GitHub al repositorio
3. Crear Azure App Service
4. Configurar variables de entorno
5. Configurar GitHub Actions para CI/CD
6. Desplegar automáticamente

**Tiempo estimado:** 30-40 minutos

---

## 🔧 FASE 1: PREPARACIÓN DEL PROYECTO (10 min)

### 1.1 Verificar archivos necesarios

#### ✅ `package.json` - Verificar scripts
```json
{
  "scripts": {
    "start": "node server.js",
    "test": "node -e \"require('./config/db').testConnection()\""
  },
  "engines": {
    "node": ">=18.x"
  }
}
```

#### ✅ Crear `.gitignore`
```
node_modules/
.env
.DS_Store
*.log
.vscode/
.idea/
```

#### ✅ Crear `web.config` para IIS (Azure usa IIS)
**YA EXISTE** ✅ - No requiere cambios

#### ✅ Verificar que `.env` NO esté en el repositorio
- Las variables de entorno irán en Azure App Service

### 1.2 Ajustes necesarios en el código

#### Archivo: `server.js`
**CAMBIO REQUERIDO:** Puerto dinámico para Azure
```javascript
const PORT = process.env.PORT || 5000;
```
✅ **YA ESTÁ CONFIGURADO** - No requiere cambios

#### Archivo: `config/db.js`
**ESTADO ACTUAL:** Credenciales hardcodeadas
**ACCIÓN:** Moverlas a variables de entorno

---

## 📦 FASE 2: CONFIGURAR GITHUB (5 min)

### 2.1 Inicializar Git (si no está inicializado)
```powershell
cd C:\Users\jesus\OneDrive\Escritorio\api-azure\backend
git init
git add .
git commit -m "Initial commit - API funcionando"
```

### 2.2 Crear repositorio en GitHub
1. Ve a https://github.com/new
2. Nombre: `api-escolar-azure` (o el que prefieras)
3. Descripción: "API Backend Sistema Gestión Escolar"
4. Visibilidad: **Private** (recomendado)
5. NO inicializar con README (ya tienes archivos)
6. Click en **Create repository**

### 2.3 Conectar repositorio local con GitHub
```powershell
git remote add origin https://github.com/TU_USUARIO/api-escolar-azure.git
git branch -M main
git push -u origin main
```

---

## ☁️ FASE 3: CREAR AZURE APP SERVICE (10 min)

### 3.1 Acceder a Azure Portal
1. Ve a https://portal.azure.com
2. Inicia sesión con tu cuenta

### 3.2 Crear App Service
1. Click en **"Crear un recurso"**
2. Buscar **"Web App"** o **"App Service"**
3. Click en **Crear**

### 3.3 Configuración básica
```
PESTAÑA: Básico
├── Suscripción: [Tu suscripción]
├── Grupo de recursos: [Crear nuevo] "rg-api-escolar"
├── Nombre: "api-escolar-backend" (debe ser único)
├── Publicar: "Código"
├── Pila de tiempo de ejecución: "Node 18 LTS" o "Node 20 LTS"
├── Sistema operativo: "Linux" (recomendado)
└── Región: "East US" o la más cercana
```

### 3.4 Plan de App Service
```
PESTAÑA: Plan de App Service
├── Plan de Linux: [Crear nuevo] "plan-api-escolar"
├── SKU y tamaño: 
│   ├── DESARROLLO: "F1 (Gratis)" - 1 GB RAM, 60 min/día
│   ├── BÁSICO: "B1" - $13/mes, 1.75 GB RAM
│   └── PRODUCCIÓN: "P1V2" - $73/mes, 3.5 GB RAM
└── [Seleccionar el plan según tu necesidad]
```

### 3.5 Revisión y creación
1. Click en **"Revisar y crear"**
2. Verificar configuración
3. Click en **"Crear"**
4. Esperar 2-3 minutos mientras se despliega

---

## 🔐 FASE 4: CONFIGURAR VARIABLES DE ENTORNO (5 min)

### 4.1 Ir a configuración de App Service
1. En Azure Portal, ir a tu App Service creado
2. En el menú izquierdo: **"Configuración"** → **"Configuración de la aplicación"**

### 4.2 Agregar variables de entorno
Click en **"Nueva configuración de aplicación"** para cada una:

```
NOMBRE: DB_HOST
VALOR: mysqlingles.mysql.database.azure.com

NOMBRE: DB_USER
VALOR: admin_ingles

NOMBRE: DB_PASSWORD
VALOR: Gui11ermo1

NOMBRE: DB_NAME
VALOR: proyectoIngles

NOMBRE: DB_PORT
VALOR: 3306

NOMBRE: PORT
VALOR: 8080

NOMBRE: JWT_SECRET
VALOR: tu_clave_secreta_super_segura_2024_produccion

NOMBRE: NODE_ENV
VALOR: production
```

### 4.3 Guardar configuración
1. Click en **"Guardar"** (arriba)
2. Confirmar cuando pregunte
3. La app se reiniciará automáticamente

---

## 🔄 FASE 5: CONFIGURAR CI/CD CON GITHUB ACTIONS (10 min)

### 5.1 Habilitar despliegue desde GitHub

#### Opción A: Desde Azure Portal (más fácil)
1. En tu App Service → **"Centro de implementación"**
2. Origen: Seleccionar **"GitHub"**
3. Autorizar conexión con GitHub
4. Seleccionar:
   - **Organización:** Tu usuario de GitHub
   - **Repositorio:** api-escolar-azure
   - **Rama:** main
5. Click en **"Guardar"**

Azure creará automáticamente el workflow de GitHub Actions.

#### Opción B: Manual (más control)
Crear archivo: `.github/workflows/azure-deploy.yml`

```yaml
name: Deploy to Azure App Service

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18.x'
    
    - name: Install dependencies
      run: |
        cd backend
        npm ci --production
    
    - name: Test connection
      run: |
        cd backend
        npm test
    
    - name: Deploy to Azure Web App
      uses: azure/webapps-deploy@v2
      with:
        app-name: 'api-escolar-backend'
        publish-profile: ${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE }}
        package: ./backend
```

### 5.2 Obtener Publish Profile (solo si usas Opción B)
1. En Azure Portal → Tu App Service
2. Click en **"Obtener perfil de publicación"** (barra superior)
3. Se descarga un archivo XML

### 5.3 Agregar secreto en GitHub (solo si usas Opción B)
1. Ve a tu repositorio GitHub
2. **Settings** → **Secrets and variables** → **Actions**
3. Click en **"New repository secret"**
4. Nombre: `AZURE_WEBAPP_PUBLISH_PROFILE`
5. Valor: Pegar todo el contenido del XML descargado
6. Click en **"Add secret"**

---

## 🚀 FASE 6: DESPLIEGUE Y VERIFICACIÓN (5 min)

### 6.1 Hacer push para desplegar
```powershell
# Hacer cualquier cambio o forzar redeploy
git add .
git commit -m "Configurar despliegue a Azure"
git push origin main
```

### 6.2 Monitorear despliegue
1. Ve a GitHub → Tu repositorio → **Actions**
2. Verás el workflow ejecutándose
3. Espera a que termine (2-5 minutos)
4. Debe mostrar ✅ verde si fue exitoso

### 6.3 Verificar en Azure
1. Ve a Azure Portal → Tu App Service
2. En **"Información general"** verás la URL
3. Ejemplo: `https://api-escolar-backend.azurewebsites.net`

### 6.4 Probar la API desplegada
```powershell
# Probar endpoint raíz
Invoke-RestMethod -Uri "https://api-escolar-backend.azurewebsites.net/"

# Probar conexión a BD
Invoke-RestMethod -Uri "https://api-escolar-backend.azurewebsites.net/api/test-db"

# Probar login
$loginBody = @{
    usuario = "admin1"
    "contraseña" = "123456"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://api-escolar-backend.azurewebsites.net/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
```

---

## 🔧 AJUSTES NECESARIOS EN EL CÓDIGO

### Archivo: `config/db.js`

**CAMBIAR DE:**
```javascript
const pool = mysql.createPool({
  host: 'mysqlingles.mysql.database.azure.com',
  user: 'admin_ingles',
  password: 'Gui11ermo1',
  database: 'proyectoIngles',
  // ...
});
```

**CAMBIAR A:**
```javascript
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'mysqlingles.mysql.database.azure.com',
  user: process.env.DB_USER || 'admin_ingles',
  password: process.env.DB_PASSWORD || 'Gui11ermo1',
  database: process.env.DB_NAME || 'proyectoIngles',
  port: process.env.DB_PORT || 3306,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  ssl: {
    rejectUnauthorized: true
  }
});
```

### Archivo: `server.js`

**AGREGAR DESPUÉS DE LAS RUTAS:**
```javascript
// Health check para Azure
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', timestamp: new Date() });
});
```

---

## 🎨 CONFIGURACIÓN ADICIONAL DE AZURE

### Configurar dominio personalizado (opcional)
1. App Service → **"Dominios personalizados"**
2. Agregar tu dominio (ej: api.tuescuela.com)
3. Configurar DNS según instrucciones

### Configurar SSL/HTTPS (automático)
- Azure proporciona SSL gratis para *.azurewebsites.net
- Para dominio personalizado: usar certificado administrado gratis

### Configurar escalado (opcional)
1. App Service → **"Escalar verticalmente"**
2. Seleccionar plan según tráfico esperado
3. Configurar autoescalado en **"Escalar horizontalmente"**

### Habilitar logs
1. App Service → **"Registros de App Service"**
2. Activar:
   - Registro de aplicaciones (filesystem)
   - Mensajes de error detallados
   - Seguimiento de solicitudes con error
3. Ver logs en: **"Secuencia de registro"**

---

## 📊 MONITOREO Y DIAGNÓSTICO

### Ver logs en tiempo real
1. Azure Portal → Tu App Service
2. **"Secuencia de registro"** (menú izquierdo)
3. Verás console.log() de tu aplicación

### Consola SSH/Kudu
1. Azure Portal → Tu App Service
2. **"Herramientas de desarrollo"** → **"Consola"**
3. O visitar: `https://api-escolar-backend.scm.azurewebsites.net`

### Application Insights (opcional pero recomendado)
1. App Service → **"Application Insights"**
2. **"Activar Application Insights"**
3. Crear nuevo recurso
4. Monitorear rendimiento, errores, uso

---

## ✅ CHECKLIST FINAL

### Antes de desplegar:
- [ ] `.gitignore` creado y `.env` excluido
- [ ] `config/db.js` usa variables de entorno
- [ ] `package.json` tiene script `start` correcto
- [ ] `web.config` existe (ya lo tienes)
- [ ] Código committed en Git
- [ ] Repositorio GitHub creado

### En Azure:
- [ ] App Service creado
- [ ] Variables de entorno configuradas
- [ ] GitHub Actions configurado
- [ ] Primer despliegue exitoso
- [ ] Health check responde
- [ ] API test-db funciona
- [ ] Login funciona

### Post-despliegue:
- [ ] URL de producción documentada
- [ ] Frontend actualizado con nueva URL
- [ ] Logs verificados
- [ ] Rendimiento monitoreado

---

## 🆘 TROUBLESHOOTING COMÚN

### Error: "Application Error"
**Causa:** Aplicación no inicia correctamente  
**Solución:**
1. Verificar logs en Azure Portal
2. Verificar variables de entorno
3. Verificar que `package.json` tiene `start` script

### Error: "Cannot connect to database"
**Causa:** Variables de entorno mal configuradas  
**Solución:**
1. Verificar DB_HOST, DB_USER, DB_PASSWORD en Azure
2. Verificar firewall de MySQL Azure permite conexiones
3. Agregar IP de Azure App Service a firewall MySQL

### Despliegue exitoso pero API no responde
**Causa:** Puerto incorrecto  
**Solución:**
1. Verificar `PORT` en variables de entorno es `8080`
2. Verificar código usa `process.env.PORT`

### GitHub Actions falla
**Causa:** Secretos mal configurados  
**Solución:**
1. Verificar `AZURE_WEBAPP_PUBLISH_PROFILE` en GitHub
2. Re-descargar publish profile de Azure
3. Actualizar secreto en GitHub

---

## 📞 CONTACTOS Y RECURSOS

### Documentación oficial:
- Azure App Service: https://docs.microsoft.com/azure/app-service/
- GitHub Actions: https://docs.github.com/actions
- Node.js en Azure: https://docs.microsoft.com/azure/app-service/quickstart-nodejs

### Soporte:
- Azure Support: https://portal.azure.com → Support
- GitHub Support: https://support.github.com

---

## 🎯 PRÓXIMOS PASOS DESPUÉS DEL DESPLIEGUE

1. **Actualizar CORS en el código**
   - Agregar la URL de Azure App Service
   - Mantener la URL del frontend

2. **Configurar CI/CD completo**
   - Branch `develop` para desarrollo
   - Branch `main` para producción
   - Pull requests con revisión

3. **Implementar backup automatizado**
   - Configurar backup de App Service
   - Backup de base de datos MySQL

4. **Monitoreo y alertas**
   - Application Insights
   - Alertas por errores o alta latencia

5. **Optimización**
   - Cache con Redis
   - CDN para assets estáticos
   - Compresión GZIP

---

## 💰 COSTOS ESTIMADOS

### Plan Free (F1):
- **Costo:** $0/mes
- **Límites:** 60 min/día, 1 GB RAM
- **Ideal para:** Testing, demos

### Plan Basic (B1):
- **Costo:** ~$13/mes
- **Recursos:** Always-on, 1.75 GB RAM
- **Ideal para:** Desarrollo, APIs pequeñas

### Plan Standard (S1):
- **Costo:** ~$69/mes
- **Recursos:** 1.75 GB RAM, autoescalado, slots
- **Ideal para:** Producción pequeña/mediana

### Plan Premium (P1V2):
- **Costo:** ~$73/mes
- **Recursos:** 3.5 GB RAM, mejor rendimiento
- **Ideal para:** Producción con tráfico alto

**RECOMENDACIÓN:** Empezar con F1 o B1, escalar según necesidad.

---

**¡LISTO PARA DESPLEGAR! 🚀**

Sigue el plan paso a paso y tu API estará en producción en 30-40 minutos.
