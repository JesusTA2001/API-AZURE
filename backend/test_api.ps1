# Script para probar la API desde PowerShell
# Uso: .\test_api.ps1

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "    PROBANDO API - SISTEMA ESCOLAR   " -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# 1. PROBAR CONEXIÓN AL SERVIDOR
Write-Host "1. Probando servidor..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:5000/" -Method GET
    Write-Host "   ✅ Servidor funcionando" -ForegroundColor Green
    Write-Host "   Mensaje: $($response.message)" -ForegroundColor Gray
} catch {
    Write-Host "   ❌ Error: $_" -ForegroundColor Red
    exit
}

Write-Host ""

# 2. PROBAR CONEXIÓN A BASE DE DATOS
Write-Host "2. Probando conexión a MySQL..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:5000/api/test-db" -Method GET
    Write-Host "   ✅ Base de datos conectada" -ForegroundColor Green
    Write-Host "   Base de datos: $($response.database)" -ForegroundColor Gray
} catch {
    Write-Host "   ❌ Error: $_" -ForegroundColor Red
}

Write-Host ""

# 3. HACER LOGIN
Write-Host "3. Haciendo login (usuario: 1000, password: 123456)..." -ForegroundColor Yellow
try {
    $loginBody = @{
        usuario = "1000"
        "contraseña" = "123456"
    } | ConvertTo-Json

    $loginResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    
    Write-Host "   ✅ Login exitoso" -ForegroundColor Green
    Write-Host "   Usuario: $($loginResponse.user.nombre) $($loginResponse.user.apellidoPaterno)" -ForegroundColor Gray
    Write-Host "   Rol: $($loginResponse.user.rol)" -ForegroundColor Gray
    Write-Host "   Token: $($loginResponse.token.Substring(0, 30))..." -ForegroundColor Gray
    
    $token = $loginResponse.token
} catch {
    Write-Host "   ❌ Error en login: $_" -ForegroundColor Red
    exit
}

Write-Host ""

# 4. OBTENER LISTA DE ALUMNOS
Write-Host "4. Obteniendo lista de alumnos..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $token"
    }
    
    $alumnos = Invoke-RestMethod -Uri "http://localhost:5000/api/alumnos" -Method GET -Headers $headers
    
    Write-Host "   ✅ Total de alumnos: $($alumnos.Count)" -ForegroundColor Green
    Write-Host "   Primeros 5 alumnos:" -ForegroundColor Gray
    $alumnos | Select-Object -First 5 | ForEach-Object {
        Write-Host "      - $($_.nControl): $($_.nombre) $($_.apellidoPaterno) - $($_.ubicacion)" -ForegroundColor White
    }
} catch {
    Write-Host "   ❌ Error: $_" -ForegroundColor Red
}

Write-Host ""

# 5. OBTENER LISTA DE PROFESORES
Write-Host "5. Obteniendo lista de profesores..." -ForegroundColor Yellow
try {
    $profesores = Invoke-RestMethod -Uri "http://localhost:5000/api/profesores" -Method GET -Headers $headers
    
    Write-Host "   ✅ Total de profesores: $($profesores.Count)" -ForegroundColor Green
    Write-Host "   Primeros 5 profesores:" -ForegroundColor Gray
    $profesores | Select-Object -First 5 | ForEach-Object {
        Write-Host "      - ID $($_.id_Profesor): $($_.nombre) $($_.apellidoPaterno) - $($_.ubicacion)" -ForegroundColor White
    }
} catch {
    Write-Host "   ❌ Error: $_" -ForegroundColor Red
}

Write-Host ""

# 6. OBTENER LISTA DE GRUPOS
Write-Host "6. Obteniendo lista de grupos..." -ForegroundColor Yellow
try {
    $grupos = Invoke-RestMethod -Uri "http://localhost:5000/api/grupos" -Method GET -Headers $headers
    
    Write-Host "   ✅ Total de grupos: $($grupos.Count)" -ForegroundColor Green
    Write-Host "   Primeros 3 grupos:" -ForegroundColor Gray
    $grupos | Select-Object -First 3 | ForEach-Object {
        Write-Host "      - Grupo $($_.grupo): Profesor $($_.profesor_nombre) - $($_.num_alumnos) alumnos" -ForegroundColor White
    }
} catch {
    Write-Host "   ❌ Error: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "   ✅ PRUEBAS COMPLETADAS" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Token guardado en variable: `$token" -ForegroundColor Yellow
Write-Host "Puedes usarlo para más consultas manualmente" -ForegroundColor Yellow
