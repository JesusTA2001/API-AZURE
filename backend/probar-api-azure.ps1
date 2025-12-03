# Script para probar la API desplegada en Azure
$apiUrl = "https://api-escolar-backend-cbgrhtfkbxgsdra9.eastus2-01.azurewebsites.net"

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  PROBANDO API EN AZURE" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "URL: $apiUrl" -ForegroundColor Yellow
Write-Host ""

$exitos = 0
$errores = 0

# TEST 1: Endpoint raíz
Write-Host "[1/6] Probando endpoint raiz (/)..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$apiUrl/" -Method GET
    Write-Host "   OK - Servidor funcionando" -ForegroundColor Green
    Write-Host "   Mensaje: $($response.message)" -ForegroundColor Gray
    Write-Host "   Ambiente: $($response.environment)" -ForegroundColor Gray
    $exitos++
} catch {
    Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
    $errores++
}

Write-Host ""

# TEST 2: Health check
Write-Host "[2/6] Probando health check..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$apiUrl/health" -Method GET
    Write-Host "   OK - Health check exitoso" -ForegroundColor Green
    Write-Host "   Status: $($response.status)" -ForegroundColor Gray
    $exitos++
} catch {
    Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
    $errores++
}

Write-Host ""

# TEST 3: Conexión a base de datos
Write-Host "[3/6] Probando conexion a base de datos..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$apiUrl/api/test-db" -Method GET
    Write-Host "   OK - Base de datos conectada" -ForegroundColor Green
    Write-Host "   Base de datos: $($response.database)" -ForegroundColor Gray
    $exitos++
} catch {
    Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Verifica las variables de entorno en Azure" -ForegroundColor Yellow
    $errores++
}

Write-Host ""

# TEST 4: Login
Write-Host "[4/6] Probando login..." -ForegroundColor Yellow
try {
    $loginBody = @{
        usuario = "admin1"
        "contraseña" = "123456"
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "$apiUrl/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    $token = $response.token
    Write-Host "   OK - Login exitoso" -ForegroundColor Green
    Write-Host "   Usuario: $($response.user.nombre) $($response.user.apellidoPaterno)" -ForegroundColor Gray
    Write-Host "   Rol: $($response.user.rol)" -ForegroundColor Gray
    $exitos++
} catch {
    Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
    $errores++
}

Write-Host ""

# TEST 5: Consultar alumnos (con autenticación)
if ($token) {
    Write-Host "[5/6] Probando consulta de alumnos..." -ForegroundColor Yellow
    try {
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        $alumnos = Invoke-RestMethod -Uri "$apiUrl/api/alumnos" -Method GET -Headers $headers
        Write-Host "   OK - Consulta exitosa" -ForegroundColor Green
        Write-Host "   Total alumnos: $($alumnos.Count)" -ForegroundColor Gray
        $exitos++
    } catch {
        Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
        $errores++
    }
} else {
    Write-Host "[5/6] Saltando consulta de alumnos (no hay token)" -ForegroundColor Yellow
    $errores++
}

Write-Host ""

# TEST 6: Consultar grupos (con autenticación)
if ($token) {
    Write-Host "[6/6] Probando consulta de grupos..." -ForegroundColor Yellow
    try {
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        $grupos = Invoke-RestMethod -Uri "$apiUrl/api/grupos" -Method GET -Headers $headers
        Write-Host "   OK - Consulta exitosa" -ForegroundColor Green
        Write-Host "   Total grupos: $($grupos.Count)" -ForegroundColor Gray
        $exitos++
    } catch {
        Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
        $errores++
    }
} else {
    Write-Host "[6/6] Saltando consulta de grupos (no hay token)" -ForegroundColor Yellow
    $errores++
}

# RESUMEN
Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  RESUMEN DE PRUEBAS" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pruebas exitosas: $exitos / 6" -ForegroundColor $(if ($exitos -eq 6) { "Green" } else { "Yellow" })
Write-Host "Pruebas fallidas: $errores / 6" -ForegroundColor $(if ($errores -gt 0) { "Red" } else { "Green" })
Write-Host ""

if ($errores -eq 0) {
    Write-Host "TODAS LAS PRUEBAS EXITOSAS" -ForegroundColor Green
    Write-Host ""
    Write-Host "Tu API esta funcionando correctamente en:" -ForegroundColor Green
    Write-Host "$apiUrl" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Puedes usar esta URL en tu frontend" -ForegroundColor Yellow
} else {
    Write-Host "ALGUNAS PRUEBAS FALLARON" -ForegroundColor Red
    Write-Host ""
    if ($errores -eq 6) {
        Write-Host "Posibles causas:" -ForegroundColor Yellow
        Write-Host "  1. La aplicacion aun no termino de desplegarse (espera 2-3 min)" -ForegroundColor White
        Write-Host "  2. Variables de entorno no configuradas en Azure" -ForegroundColor White
        Write-Host "  3. Error en el codigo o dependencias" -ForegroundColor White
        Write-Host ""
        Write-Host "Revisa los logs en Azure Portal:" -ForegroundColor Yellow
        Write-Host "  App Service -> Secuencia de registro" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# GUARDAR TOKEN
if ($token) {
    Write-Host "Token guardado en variable: `$token" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Puedes hacer mas pruebas:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "`$headers = @{ 'Authorization' = 'Bearer `$token' }" -ForegroundColor Gray
    Write-Host "Invoke-RestMethod -Uri '$apiUrl/api/profesores' -Headers `$headers" -ForegroundColor Gray
    Write-Host ""
}
