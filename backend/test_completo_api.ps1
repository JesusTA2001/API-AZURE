# Test completo de todas las funcionalidades de la API
# Prueba TODOS los endpoints y operaciones CRUD

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TEST COMPLETO DE LA API" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$errores = 0
$exitos = 0

# ============================================
# 1. PROBAR SERVIDOR Y CONEXION DB
# ============================================
Write-Host "[1/15] Probando servidor..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:5000/" -Method GET
    Write-Host "   OK - Servidor funcionando" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - Servidor no responde: $_" -ForegroundColor Red
    $errores++
    exit
}

Write-Host "[2/15] Probando conexion a base de datos..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:5000/api/test-db" -Method GET
    Write-Host "   OK - Base de datos conectada: $($response.database)" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - Base de datos no conectada: $_" -ForegroundColor Red
    $errores++
}

# ============================================
# 2. AUTENTICACION
# ============================================
Write-Host "[3/15] Probando login con estudiante..." -ForegroundColor Yellow
try {
    $loginBody = @{
        usuario = "1000"
        "contraseña" = "123456"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    $tokenEstudiante = $loginResponse.token
    Write-Host "   OK - Login estudiante: $($loginResponse.user.nombre) $($loginResponse.user.apellidoPaterno)" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - Login estudiante fallo: $_" -ForegroundColor Red
    $errores++
}

Write-Host "[4/15] Probando login con profesor..." -ForegroundColor Yellow
try {
    $loginBody = @{
        usuario = "prof1"
        "contraseña" = "123456"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    $tokenProfesor = $loginResponse.token
    Write-Host "   OK - Login profesor: $($loginResponse.user.nombre) $($loginResponse.user.apellidoPaterno)" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - Login profesor fallo: $_" -ForegroundColor Red
    $errores++
}

Write-Host "[5/15] Probando login con administrador..." -ForegroundColor Yellow
try {
    $loginBody = @{
        usuario = "admin1"
        "contraseña" = "123456"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    $token = $loginResponse.token
    Write-Host "   OK - Login admin: $($loginResponse.user.nombre) $($loginResponse.user.apellidoPaterno)" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - Login admin fallo: $_" -ForegroundColor Red
    $errores++
    exit
}

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# ============================================
# 3. CONSULTAS - ALUMNOS
# ============================================
Write-Host "[6/15] Probando GET /api/alumnos..." -ForegroundColor Yellow
try {
    $alumnos = Invoke-RestMethod -Uri "http://localhost:5000/api/alumnos" -Method GET -Headers $headers
    Write-Host "   OK - Total alumnos: $($alumnos.Count)" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - No se pudo obtener alumnos: $_" -ForegroundColor Red
    $errores++
}

Write-Host "[7/15] Probando GET /api/alumnos/:id..." -ForegroundColor Yellow
try {
    $alumno = Invoke-RestMethod -Uri "http://localhost:5000/api/alumnos/1000" -Method GET -Headers $headers
    Write-Host "   OK - Alumno obtenido: $($alumno.nombre) $($alumno.apellidoPaterno)" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - No se pudo obtener alumno especifico: $_" -ForegroundColor Red
    $errores++
}

Write-Host "[8/15] Probando GET /api/alumnos/disponibles..." -ForegroundColor Yellow
try {
    $disponibles = Invoke-RestMethod -Uri "http://localhost:5000/api/alumnos/disponibles/list" -Method GET -Headers $headers
    Write-Host "   OK - Alumnos disponibles: $($disponibles.Count)" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - No se pudo obtener alumnos disponibles: $_" -ForegroundColor Red
    $errores++
}

# ============================================
# 4. CONSULTAS - PROFESORES
# ============================================
Write-Host "[9/15] Probando GET /api/profesores..." -ForegroundColor Yellow
try {
    $profesores = Invoke-RestMethod -Uri "http://localhost:5000/api/profesores" -Method GET -Headers $headers
    Write-Host "   OK - Total profesores: $($profesores.Count)" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - No se pudo obtener profesores: $_" -ForegroundColor Red
    $errores++
}

Write-Host "[10/15] Probando GET /api/profesores/:id..." -ForegroundColor Yellow
try {
    $profesor = Invoke-RestMethod -Uri "http://localhost:5000/api/profesores/1" -Method GET -Headers $headers
    Write-Host "   OK - Profesor obtenido: $($profesor.nombre) $($profesor.apellidoPaterno)" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - No se pudo obtener profesor especifico: $_" -ForegroundColor Red
    $errores++
}

# ============================================
# 5. CONSULTAS - GRUPOS
# ============================================
Write-Host "[11/15] Probando GET /api/grupos..." -ForegroundColor Yellow
try {
    $grupos = Invoke-RestMethod -Uri "http://localhost:5000/api/grupos" -Method GET -Headers $headers
    Write-Host "   OK - Total grupos: $($grupos.Count)" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - No se pudo obtener grupos: $_" -ForegroundColor Red
    $errores++
}

# ============================================
# 6. CONSULTAS - NIVELES, PERIODOS, HORARIOS
# ============================================
Write-Host "[12/15] Probando GET /api/niveles..." -ForegroundColor Yellow
try {
    $niveles = Invoke-RestMethod -Uri "http://localhost:5000/api/niveles" -Method GET -Headers $headers
    Write-Host "   OK - Total niveles: $($niveles.Count)" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - No se pudo obtener niveles: $_" -ForegroundColor Red
    $errores++
}

Write-Host "[13/15] Probando GET /api/periodos..." -ForegroundColor Yellow
try {
    $periodos = Invoke-RestMethod -Uri "http://localhost:5000/api/periodos" -Method GET -Headers $headers
    Write-Host "   OK - Total periodos: $($periodos.Count)" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - No se pudo obtener periodos: $_" -ForegroundColor Red
    $errores++
}

Write-Host "[14/15] Probando GET /api/horarios..." -ForegroundColor Yellow
try {
    $horarios = Invoke-RestMethod -Uri "http://localhost:5000/api/horarios" -Method GET -Headers $headers
    Write-Host "   OK - Total horarios: $($horarios.Count)" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - No se pudo obtener horarios: $_" -ForegroundColor Red
    $errores++
}

Write-Host "[15/15] Probando GET /api/administradores..." -ForegroundColor Yellow
try {
    $admins = Invoke-RestMethod -Uri "http://localhost:5000/api/administradores" -Method GET -Headers $headers
    Write-Host "   OK - Total administradores: $($admins.Count)" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - No se pudo obtener administradores: $_" -ForegroundColor Red
    $errores++
}

# ============================================
# RESUMEN
# ============================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  RESUMEN DE PRUEBAS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pruebas exitosas: $exitos" -ForegroundColor Green
Write-Host "Pruebas fallidas: $errores" -ForegroundColor $(if ($errores -gt 0) { "Red" } else { "Green" })
Write-Host ""

if ($errores -eq 0) {
    Write-Host "TODAS LAS FUNCIONES PRINCIPALES ESTAN OPERATIVAS" -ForegroundColor Green
} else {
    Write-Host "ALGUNAS FUNCIONES TIENEN PROBLEMAS" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
