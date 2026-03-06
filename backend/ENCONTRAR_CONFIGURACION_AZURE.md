# 🔍 ENCONTRAR CONFIGURACIÓN EN AZURE (PASO A PASO)

## 📋 UBICACIÓN ACTUALIZADA

### PASO 1: Ir a tu App Service

1. Abre https://portal.azure.com
2. En el buscador superior (dice "Buscar recursos"), escribe:
   ```
   api-escolar-backend-cbgrhtfkbxgsdra9
   ```
3. Click en tu App Service

---

### PASO 2: Encontrar Variables de Entorno

**En el menú lateral IZQUIERDO**, busca en este orden:

#### Opción A: Nueva interfaz (2024+)
```
└── Settings (Configuración)
    └── Environment variables (Variables de entorno)
        └── App settings (Configuración de la aplicación)
```

#### Opción B: Interfaz anterior
```
└── Configuration (Configuración)
    └── Application settings (Configuración de la aplicación)
```

#### Opción C: Si el menú está en español
```
└── Configuración
    └── Variables de entorno
        └── Configuración de la aplicación
```

---

### PASO 3: Agregar Variables

Una vez dentro, verás:
- Una lista de variables existentes (puede estar vacía)
- Un botón que dice **"+ Nueva configuración de aplicación"** o **"+ New application setting"**

**Para cada variable:**
1. Click en **"+ Nueva configuración de aplicación"**
2. Nombre: `DB_HOST`
3. Valor: `mysqlingles.mysql.database.azure.com`
4. Click **"Aceptar"** o **"OK"**

**Repite para todas estas variables:**

```
Nombre: DB_HOST
Valor: mysqlingles.mysql.database.azure.com

Nombre: DB_USER
Valor: admin_ingles

Nombre: DB_PASSWORD
Valor: Gui11ermo1

Nombre: DB_NAME
Valor: proyectoIngles

Nombre: DB_PORT
Valor: 3306

Nombre: PORT
Valor: 8080

Nombre: JWT_SECRET
Valor: tu_clave_secreta_super_segura_2024_produccion

Nombre: NODE_ENV
Valor: production
```

---

### PASO 4: GUARDAR (IMPORTANTE)

Después de agregar TODAS las variables:
1. Click en **"Guardar"** (botón arriba) o **"Save"**
2. Click **"Continuar"** cuando pregunte si quieres reiniciar

La aplicación se reiniciará automáticamente (toma 1-2 minutos).

---

## 🔍 SI NO ENCUENTRAS EL MENÚ

### Usa el buscador del menú:

1. En tu App Service, arriba del menú izquierdo hay un **campo de búsqueda** 🔍
2. Escribe: `configuration` o `variables`
3. Te mostrará las opciones relevantes

### Términos que puedes buscar:
- `configuration`
- `environment`
- `variables`
- `settings`
- `configuración`

---

## 📸 CAPTURAS DE REFERENCIA

### Lo que debes ver:

**Menú lateral (busca esto):**
```
⚙️ Configuración (o Settings)
   ├── Configuración general
   ├── Variables de entorno ← AQUÍ
   ├── Ruta de acceso
   └── ...
```

**O en inglés:**
```
⚙️ Settings
   ├── Configuration ← AQUÍ
   ├── Environment variables ← O AQUÍ
   ├── Path mappings
   └── ...
```

---

## ✅ VERIFICAR QUE FUNCIONÓ

Después de guardar, espera 2 minutos y ejecuta:

```powershell
.\probar-api-azure.ps1
```

O abre en el navegador:
```
https://api-escolar-backend-cbgrhtfkbxgsdra9.eastus2-01.azurewebsites.net
```

Debe mostrar el mensaje de bienvenida de tu API.

---

## 🆘 ALTERNATIVA: Configurar desde Azure CLI

Si de plano no encuentras el menú, puedes configurar las variables desde PowerShell:

```powershell
# Instalar Azure CLI (si no lo tienes)
winget install Microsoft.AzureCLI

# Login
az login

# Configurar variables (ejecuta cada línea)
az webapp config appsettings set --name api-escolar-backend-cbgrhtfkbxgsdra9 --resource-group [TU_GRUPO_RECURSOS] --settings DB_HOST="mysqlingles.mysql.database.azure.com"

az webapp config appsettings set --name api-escolar-backend-cbgrhtfkbxgsdra9 --resource-group [TU_GRUPO_RECURSOS] --settings DB_USER="admin_ingles"

az webapp config appsettings set --name api-escolar-backend-cbgrhtfkbxgsdra9 --resource-group [TU_GRUPO_RECURSOS] --settings DB_PASSWORD="Gui11ermo1"

az webapp config appsettings set --name api-escolar-backend-cbgrhtfkbxgsdra9 --resource-group [TU_GRUPO_RECURSOS] --settings DB_NAME="proyectoIngles"

az webapp config appsettings set --name api-escolar-backend-cbgrhtfkbxgsdra9 --resource-group [TU_GRUPO_RECURSOS] --settings DB_PORT="3306"

az webapp config appsettings set --name api-escolar-backend-cbgrhtfkbxgsdra9 --resource-group [TU_GRUPO_RECURSOS] --settings PORT="8080"

az webapp config appsettings set --name api-escolar-backend-cbgrhtfkbxgsdra9 --resource-group [TU_GRUPO_RECURSOS] --settings JWT_SECRET="tu_clave_secreta_super_segura_2024_produccion"

az webapp config appsettings set --name api-escolar-backend-cbgrhtfkbxgsdra9 --resource-group [TU_GRUPO_RECURSOS] --settings NODE_ENV="production"
```

**Nota:** Reemplaza `[TU_GRUPO_RECURSOS]` con el nombre del grupo de recursos que usaste (probablemente `rg-api-escolar`).

---

## 💡 CONSEJO

Si tu Azure Portal está en inglés, busca **"Configuration"** en el menú izquierdo.
Si está en español, busca **"Configuración"** o **"Variables de entorno"**.

El botón de búsqueda 🔍 en el menú es tu mejor amigo - escribe "config" y te mostrará todas las opciones relacionadas.
