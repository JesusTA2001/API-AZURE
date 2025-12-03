# ⚠️ ERROR 503 - SERVIDOR NO DISPONIBLE

## 🔍 DIAGNÓSTICO

Tu API responde con error **503 (Service Unavailable)**

### Causas posibles:

1. ✅ **Aplicación aún no desplegada** (más probable)
2. ⚠️ Variables de entorno faltantes
3. ⚠️ Error al iniciar la aplicación
4. ⚠️ Código no subido correctamente

---

## 🔧 SOLUCIONES PASO A PASO

### PASO 1: Verificar que el código esté en GitHub

```powershell
# ¿Ya ejecutaste el script?
.\setup-github.ps1
```

**Verifica en:** https://github.com/JesusTA2001/API-AZURE

Debe tener:
- ✅ Carpeta `backend/` con todo el código
- ✅ `package.json`
- ✅ `server.js`
- ✅ `config/db.js`

---

### PASO 2: Verificar el despliegue en Azure

#### En Azure Portal:

1. Ve a tu **App Service**: `api-escolar-backend-cbgrhtfkbxgsdra9`

2. **Información general** → Verificar:
   - Estado: ¿Dice "En ejecución"? ✅
   - URL: `https://api-escolar-backend-cbgrhtfkbxgsdra9.eastus2-01.azurewebsites.net`

3. **Centro de implementación** → Verificar:
   - ¿GitHub está conectado? ✅
   - ¿Hay un despliegue reciente?
   - ¿El último despliegue es exitoso? ✅ (debe estar verde)

---

### PASO 3: Verificar variables de entorno

#### En Azure Portal → Tu App Service → Configuración → Configuración de la aplicación

**DEBEN ESTAR ESTAS 8 VARIABLES:**

```
✅ DB_HOST = mysqlingles.mysql.database.azure.com
✅ DB_USER = admin_ingles
✅ DB_PASSWORD = Gui11ermo1
✅ DB_NAME = proyectoIngles
✅ DB_PORT = 3306
✅ PORT = 8080
✅ JWT_SECRET = tu_clave_secreta_super_segura_2024_produccion
✅ NODE_ENV = production
```

Si faltan, agrégalas y **GUARDA** (botón arriba).

---

### PASO 4: Ver los logs de la aplicación

#### En Azure Portal:

1. Tu App Service → **Secuencia de registro** (menú izquierdo)
2. Espera a que cargue
3. Busca errores en rojo

#### Errores comunes:

**"Cannot find module"**
- Solución: Falta ejecutar `npm install` en el despliegue

**"Error: connect ECONNREFUSED"**
- Solución: Variables de base de datos incorrectas

**"Port already in use"**
- Solución: Cambia `PORT` a `8080` en variables de entorno

---

### PASO 5: Forzar redespliegue

#### Opción A: Desde GitHub (si conectaste GitHub Actions)

```powershell
cd C:\Users\jesus\OneDrive\Escritorio\api-azure

# Hacer un cambio trivial y push
git add .
git commit -m "Force redeploy"
git push origin master
```

#### Opción B: Desde Azure Portal

1. Tu App Service → **Centro de implementación**
2. Click en **"Sincronizar"** o **"Volver a implementar"**
3. Espera 3-5 minutos

---

### PASO 6: Reiniciar la aplicación

#### En Azure Portal:

1. Tu App Service → **Información general**
2. Click en **"Reiniciar"** (botón arriba)
3. Confirmar
4. Espera 1-2 minutos

---

### PASO 7: Verificar la configuración de inicio

#### En Azure Portal:

1. Tu App Service → **Configuración** → **Configuración general**
2. **Comando de inicio:** debe estar **VACÍO** o tener:
   ```
   npm start
   ```
3. Si está vacío, Azure usará automáticamente el script `start` de `package.json`

---

## 🧪 PROBAR NUEVAMENTE

Después de hacer los pasos anteriores, espera **2-3 minutos** y ejecuta:

```powershell
.\probar-api-azure.ps1
```

O prueba manualmente en el navegador:
```
https://api-escolar-backend-cbgrhtfkbxgsdra9.eastus2-01.azurewebsites.net
```

---

## 📋 CHECKLIST DE VERIFICACIÓN

### GitHub
- [ ] Código subido a https://github.com/JesusTA2001/API-AZURE
- [ ] Carpeta `backend/` visible en el repo
- [ ] Archivo `package.json` presente

### Azure App Service
- [ ] App Service creado y **"En ejecución"**
- [ ] 8 variables de entorno configuradas
- [ ] GitHub conectado en "Centro de implementación"
- [ ] Último despliegue exitoso (✅ verde)

### Despliegue
- [ ] GitHub Actions ejecutado (si usas GitHub Actions)
- [ ] Logs sin errores graves
- [ ] App reiniciada después de configurar variables

---

## 🆘 SI SIGUE SIN FUNCIONAR

### Verifica la ruta del código

El problema puede ser que Azure no encuentra tu código. 

#### En Azure Portal → Centro de implementación:

**Verifica que esté así:**
```
Carpeta raíz de la aplicación: /backend
```

O en **Configuración → Ruta de acceso**:
```
Directorio de inicio: backend
```

Si tu código está en la carpeta `backend/` del repo, Azure necesita saberlo.

---

## 🔄 SOLUCIÓN ALTERNATIVA: Despliegue manual

Si GitHub Actions no funciona, puedes desplegar manualmente:

### Opción 1: VS Code con extensión Azure

1. Instalar extensión "Azure App Service"
2. Click derecho en carpeta `backend`
3. "Deploy to Web App"
4. Seleccionar tu App Service

### Opción 2: Azure CLI

```powershell
# Instalar Azure CLI si no lo tienes
winget install Microsoft.AzureCLI

# Login
az login

# Desplegar
az webapp up --name api-escolar-backend-cbgrhtfkbxgsdra9 --resource-group rg-api-escolar --runtime "NODE:18-lts"
```

---

## 📞 SIGUIENTE PASO

1. **Verifica el PASO 3** (variables de entorno) - es lo más común
2. **Verifica el PASO 4** (logs) - te dirá exactamente qué falla
3. **Ejecuta PASO 6** (reiniciar) después de configurar variables
4. **Espera 2-3 minutos** y prueba nuevamente

Si después de esto sigue sin funcionar, comparte los logs y te ayudo específicamente.
