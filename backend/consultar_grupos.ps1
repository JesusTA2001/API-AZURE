# Script para consultar grupos con autenticacion
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "    CONSULTANDO GRUPOS" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# PASO 1: Hacer login para obtener el token
Write-Host "1. Haciendo login..." -ForegroundColor Yellow
$loginBody = @{
    usuario = "admin1"
    "contraseña" = "123456"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    $token = $loginResponse.token
    Write-Host "   Login exitoso como: $($loginResponse.user.nombre) $($loginResponse.user.apellidoPaterno)" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "   Error en login: $_" -ForegroundColor Red
    exit
}

# PASO 2: Crear headers con el token
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# PASO 3: Consultar grupos
Write-Host "2. Consultando grupos..." -ForegroundColor Yellow
try {
    $grupos = Invoke-RestMethod -Uri "http://localhost:5000/api/grupos" -Method GET -Headers $headers
    
    Write-Host "   Total de grupos: $($grupos.Count)" -ForegroundColor Green
    Write-Host ""
    
    if ($grupos.Count -gt 0) {
        Write-Host "LISTA DE GRUPOS:" -ForegroundColor Cyan
        Write-Host "===================================================" -ForegroundColor Cyan
        
        foreach ($grupo in $grupos) {
            Write-Host ""
            Write-Host "Grupo: $($grupo.grupo) (ID: $($grupo.id_Grupo))" -ForegroundColor Yellow
            Write-Host "   Profesor: $($grupo.profesor_nombre)" -ForegroundColor White
            Write-Host "   Ubicacion: $($grupo.ubicacion)" -ForegroundColor White
            Write-Host "   Nivel: $($grupo.nivel_nombre)" -ForegroundColor White
            Write-Host "   Horario: $($grupo.diaSemana) - $($grupo.hora)" -ForegroundColor White
            Write-Host "   Alumnos: $($grupo.num_alumnos)" -ForegroundColor White
            
            if ($grupo.alumnos -and $grupo.alumnos.Count -gt 0) {
                Write-Host "   Lista de alumnos:" -ForegroundColor Gray
                $grupo.alumnos | Select-Object -First 5 | ForEach-Object {
                    Write-Host "      - $($_.nControl) - $($_.nombre_completo)" -ForegroundColor Gray
                }
                if ($grupo.alumnos.Count -gt 5) {
                    Write-Host "      ... y $($grupo.alumnos.Count - 5) mas" -ForegroundColor DarkGray
                }
            }
        }
        
        Write-Host ""
        Write-Host "===================================================" -ForegroundColor Cyan
    } else {
        Write-Host "   No hay grupos registrados" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "   Error al consultar grupos: $_" -ForegroundColor Red
    Write-Host "   Detalle: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Token guardado en variable: `$token" -ForegroundColor Yellow
Write-Host "Headers en variable: `$headers" -ForegroundColor Yellow
Write-Host ""
Write-Host "PUEDES HACER MAS CONSULTAS:" -ForegroundColor Green
Write-Host "  Invoke-RestMethod -Uri 'http://localhost:5000/api/grupos' -Method GET -Headers `$headers" -ForegroundColor Gray
Write-Host "  Invoke-RestMethod -Uri 'http://localhost:5000/api/alumnos' -Method GET -Headers `$headers" -ForegroundColor Gray
Write-Host "  Invoke-RestMethod -Uri 'http://localhost:5000/api/profesores' -Method GET -Headers `$headers" -ForegroundColor Gray
Write-Host ""
