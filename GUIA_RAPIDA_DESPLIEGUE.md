# 🚀 GUÍA RÁPIDA DE DESPLIEGUE

## ⏱️ Tiempo estimado: 30-40 minutos

---

## 📋 PASO 1: CONECTAR CON GITHUB (5 min)

### En tu computadora:
```powershell
cd C:\Users\jesus\OneDrive\Escritorio\api-azure
.\setup-github.ps1
```

**El script te pedirá:**
1. Usuario de GitHub
2. Nombre del repositorio (sugerido: api-escolar-azure)
3. Autenticación de GitHub

**Resultado:** ✅ Código en GitHub

---

## ☁️ PASO 2: CREAR APP SERVICE EN AZURE (10 min)

### 1. Ir a Azure Portal
```
https://portal.azure.com
```

### 2. Crear Web App
- Click: **"Crear un recurso"**
- Buscar: **"Web App"**
- Click: **"Crear"**

### 3. Configurar
```
Nombre: api-escolar-backend
Runtime: Node 18 LTS
Sistema: Linux
Región: East US
Plan: F1 (Gratis) o B1 (Básico $13/mes)
```

### 4. Crear
- Click: **"Revisar y crear"**
- Click: **"Crear"**
- Esperar 2-3 minutos

**Resultado:** ✅ App Service creado

---

## 🔐 PASO 3: CONFIGURAR VARIABLES DE ENTORNO (5 min)

### En Azure Portal:

1. Ve a tu App Service → **"Configuración"** → **"Configuración de la aplicación"**

2. Agregar estas variables (click "Nueva configuración"):

```
DB_HOST = mysqlingles.mysql.database.azure.com
DB_USER = admin_ingles
DB_PASSWORD = Gui11ermo1
DB_NAME = proyectoIngles
DB_PORT = 3306
PORT = 8080
JWT_SECRET = tu_clave_secreta_super_segura_2024_produccion
NODE_ENV = production
```

3. Click **"Guardar"**

**Resultado:** ✅ Variables configuradas

---

## 🔄 PASO 4: CONECTAR GITHUB CON AZURE (5 min)

### En Azure Portal:

1. Tu App Service → **"Centro de implementación"**

2. Configurar:
```
Origen: GitHub
Organización: JesusTA2001
Repositorio: API-AZURE
Rama: master
```

3. Click **"Guardar"**

Azure creará automáticamente el workflow de GitHub Actions.

**Resultado:** ✅ CI/CD configurado

---

## 🚀 PASO 5: DESPLEGAR (5 min)

### El despliegue es automático:

1. Ve a GitHub → Tu repositorio → **"Actions"**
2. Verás el workflow ejecutándose
3. Espera 2-5 minutos
4. Debe mostrar ✅ verde

**Resultado:** ✅ API desplegada

---

## ✅ PASO 6: VERIFICAR (5 min)

### 1. Obtener URL de tu API

En Azure Portal → Tu App Service → **"Información general"**

URL ejemplo: `https://api-escolar-backend.azurewebsites.net`

### 2. Probar endpoints

```powershell
# Test básico
Invoke-RestMethod -Uri "https://api-escolar-backend.azurewebsites.net/"

# Test base de datos
Invoke-RestMethod -Uri "https://api-escolar-backend.azurewebsites.net/api/test-db"

# Test login
$body = @{
    usuario = "admin1"
    "contraseña" = "123456"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://api-escolar-backend.azurewebsites.net/api/auth/login" -Method POST -Body $body -ContentType "application/json"
```

**Resultado:** ✅ API funcionando en la nube

---

## 🎯 CHECKLIST COMPLETO

### GitHub
- [ ] Script `setup-github.ps1` ejecutado
- [ ] Código en GitHub
- [ ] Repositorio visible en tu perfil

### Azure App Service
- [ ] App Service creado
- [ ] Variables de entorno configuradas (8 variables)
- [ ] GitHub conectado en "Centro de implementación"

### Despliegue
- [ ] GitHub Actions ejecutado exitosamente
- [ ] URL de Azure responde
- [ ] `/` muestra mensaje de bienvenida
- [ ] `/api/test-db` muestra conexión exitosa
- [ ] `/api/auth/login` funciona correctamente

---

## ❓ PROBLEMAS COMUNES

### "Application Error" en Azure
**Solución:** Verificar logs en Azure Portal → Tu App Service → "Secuencia de registro"

### GitHub Actions falla
**Solución:** Verificar que las variables de entorno están en Azure

### No conecta a base de datos
**Solución:** Verificar que DB_HOST, DB_USER, DB_PASSWORD son correctos

---

## 📞 AYUDA ADICIONAL

**Guía detallada:** `backend/PLAN_DESPLIEGUE_AZURE.md`

**Documentación:** https://docs.microsoft.com/azure/app-service/

---

## 🎉 ¡LISTO!

Tu API está desplegada en Azure y lista para usarse en producción.

**URL de tu API:** `https://[tu-app-service].azurewebsites.net`

**Próximo paso:** Actualizar frontend con la nueva URL.
