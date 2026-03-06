# 🌐 CONFIGURACIÓN DE CORS

## ✅ CÓDIGO ACTUALIZADO

Tu archivo `server.js` ahora tiene CORS configurado automáticamente para:
- ✅ Frontend en Azure Static Web Apps
- ✅ Desarrollo local (localhost:3000, 5173, 4200)
- ✅ Herramientas de testing (Postman, Thunder Client)

---

## 🔧 EN AZURE APP SERVICE (PORTAL)

### Opción 1: Usar configuración del código (RECOMENDADO)
**NO configures CORS en Azure Portal** - El código ya lo maneja.

Tu código tiene CORS configurado para:
```
✅ https://gray-beach-0cdc4470f.3.azurestaticapps.net
✅ http://localhost:3000 (desarrollo)
✅ http://localhost:5173 (desarrollo)
✅ http://localhost:4200 (desarrollo)
```

### Opción 2: Configurar en Azure Portal (solo si el código no funciona)

1. Ve a tu **App Service** → **CORS** (menú izquierdo)

2. En **"Orígenes permitidos"** agrega cada origen en una línea separada:
```
https://gray-beach-0cdc4470f.3.azurestaticapps.net
http://localhost:3000
http://localhost:5173
```

3. **NO marques** "Enable Access-Control-Allow-Credentials"

4. Click **"Guardar"**

---

## 🎯 RECOMENDACIÓN

**NO configures CORS en Azure Portal** porque:
- ✅ Tu código ya lo maneja correctamente
- ✅ Es más flexible (distingue entre desarrollo y producción)
- ✅ Permite localhost automáticamente en desarrollo
- ✅ Da mejor control y logs

---

## 🔍 CÓMO AGREGAR MÁS ORÍGENES

Si necesitas agregar más URLs de frontend, edita `server.js`:

```javascript
const allowedOrigins = [
  "https://gray-beach-0cdc4470f.3.azurestaticapps.net",
  "https://tu-otro-frontend.com",  // 👈 Agregar aquí
  "http://localhost:3000",
  "http://localhost:5173",
  "http://localhost:4200"
];
```

---

## ⚠️ SOLO PARA TESTING (NO PRODUCCIÓN)

Si necesitas permitir TODOS los orígenes temporalmente (solo para probar):

```javascript
app.use(cors({
  origin: "*",  // ⚠️ PELIGROSO - Solo para testing
  methods: "GET,POST,PUT,DELETE,OPTIONS,PATCH",
  allowedHeaders: "Content-Type, Authorization"
}));
```

**NO uses esto en producción** - es un riesgo de seguridad.

---

## ✅ VERIFICAR QUE CORS FUNCIONA

### Desde el navegador (consola):
```javascript
fetch('https://tu-api.azurewebsites.net/api/test-db')
  .then(r => r.json())
  .then(d => console.log(d))
  .catch(e => console.error('Error CORS:', e))
```

### Desde PowerShell:
```powershell
$headers = @{
    "Origin" = "https://gray-beach-0cdc4470f.3.azurestaticapps.net"
}
Invoke-RestMethod -Uri "https://tu-api.azurewebsites.net/" -Headers $headers
```

---

## 🐛 PROBLEMAS COMUNES

### Error: "No 'Access-Control-Allow-Origin' header"
**Causa:** El origin no está en la lista permitida  
**Solución:** Agregar el origin a `allowedOrigins` en server.js

### Error: "CORS policy blocked"
**Causa:** Frontend usa URL diferente a la configurada  
**Solución:** Verificar la URL exacta del frontend y agregarla

### Error en desarrollo local
**Causa:** NODE_ENV está en 'production'  
**Solución:** Verificar que `.env` tenga `NODE_ENV=development` para local

---

## 📋 CHECKLIST

- [ ] Código CORS actualizado en `server.js` ✅ (ya está)
- [ ] Frontend URL agregada a `allowedOrigins` ✅ (ya está)
- [ ] NO configurar CORS en Azure Portal (dejar vacío)
- [ ] Probar desde frontend que funciona
- [ ] Verificar que no hay errores CORS en consola del navegador

---

## 🎯 RESUMEN

**Para tu caso:**
1. ✅ El código ya tiene CORS configurado correctamente
2. ✅ NO necesitas configurar nada en Azure Portal
3. ✅ Funcionará automáticamente con tu frontend
4. ✅ Permite localhost para desarrollo

**¡No hagas nada más! Ya está listo.** 🚀
