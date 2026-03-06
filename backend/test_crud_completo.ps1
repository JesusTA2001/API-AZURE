# Test CRUD completo - Crea, Lee, Actualiza y Elimina registros
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TEST CRUD COMPLETO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$errores = 0
$exitos = 0

# Login como admin
Write-Host "Haciendo login..." -ForegroundColor Yellow
$loginBody = @{
    usuario = "admin1"
    "contraseña" = "123456"
} | ConvertTo-Json

$loginResponse = Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
$token = $loginResponse.token
Write-Host "Login exitoso como: $($loginResponse.user.nombre)" -ForegroundColor Green
Write-Host ""

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# ============================================
# TEST 1: CREAR ALUMNO (POST)
# ============================================
Write-Host "[TEST 1] Creando nuevo alumno..." -ForegroundColor Yellow
$nuevoAlumno = @{
    apellidoPaterno = "TestApellido"
    apellidoMaterno = "TestMaterno"
    nombre = "TestNombre"
    email = "test@ejemplo.com"
    genero = "M"
    CURP = "TEST123456HDFRNN01"
    telefono = "6141234567"
    direccion = "Calle Test 123"
    ubicacion = "Tecnologico"
    usuario = "test.alumno"
    "contraseña" = "123456"
} | ConvertTo-Json

try {
    $resultado = Invoke-RestMethod -Uri "http://localhost:5000/api/alumnos" -Method POST -Body $nuevoAlumno -Headers $headers
    $nControlCreado = $resultado.nControl
    Write-Host "   OK - Alumno creado con nControl: $nControlCreado" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - No se pudo crear alumno: $($_.Exception.Message)" -ForegroundColor Red
    $errores++
}

# ============================================
# TEST 2: LEER ALUMNO CREADO (GET)
# ============================================
if ($nControlCreado) {
    Write-Host "[TEST 2] Leyendo alumno creado..." -ForegroundColor Yellow
    try {
        $alumnoLeido = Invoke-RestMethod -Uri "http://localhost:5000/api/alumnos/$nControlCreado" -Method GET -Headers $headers
        Write-Host "   OK - Alumno leido: $($alumnoLeido.nombre) $($alumnoLeido.apellidoPaterno)" -ForegroundColor Green
        $exitos++
    } catch {
        Write-Host "   ERROR - No se pudo leer alumno: $($_.Exception.Message)" -ForegroundColor Red
        $errores++
    }
}

# ============================================
# TEST 3: ACTUALIZAR ALUMNO (PUT)
# ============================================
if ($nControlCreado) {
    Write-Host "[TEST 3] Actualizando alumno..." -ForegroundColor Yellow
    $alumnoActualizado = @{
        apellidoPaterno = "TestApellidoModificado"
        apellidoMaterno = "TestMaternoModificado"
        nombre = "TestNombreModificado"
        email = "testmodificado@ejemplo.com"
        genero = "M"
        CURP = "TEST123456HDFRNN01"
        telefono = "6149999999"
        direccion = "Calle Test Modificada 456"
        ubicacion = "Centro de Idiomas"
        estado = "activo"
    } | ConvertTo-Json

    try {
        $resultado = Invoke-RestMethod -Uri "http://localhost:5000/api/alumnos/$nControlCreado" -Method PUT -Body $alumnoActualizado -Headers $headers
        Write-Host "   OK - Alumno actualizado correctamente" -ForegroundColor Green
        $exitos++
        
        # Verificar que se actualizo
        $alumnoVerificado = Invoke-RestMethod -Uri "http://localhost:5000/api/alumnos/$nControlCreado" -Method GET -Headers $headers
        if ($alumnoVerificado.telefono -eq "6149999999") {
            Write-Host "   OK - Verificacion: datos actualizados correctamente" -ForegroundColor Green
            $exitos++
        } else {
            Write-Host "   ERROR - Verificacion: datos no se actualizaron" -ForegroundColor Red
            $errores++
        }
    } catch {
        Write-Host "   ERROR - No se pudo actualizar alumno: $($_.Exception.Message)" -ForegroundColor Red
        $errores++
    }
}

# ============================================
# TEST 4: CREAR PROFESOR (POST)
# ============================================
Write-Host "[TEST 4] Creando nuevo profesor..." -ForegroundColor Yellow
$nuevoProfesor = @{
    apellidoPaterno = "ProfesorTest"
    apellidoMaterno = "TestMaterno"
    nombre = "ProfeNombre"
    email = "profesor.test@ejemplo.com"
    genero = "F"
    CURP = "PROF123456MDFRNN01"
    telefono = "6141111111"
    direccion = "Calle Profesor 789"
    ubicacion = "Tecnologico"
    RFC = "PROF123456ABC"
    nivelEstudio = "Maestria"
    usuario = "test.profesor"
    "contraseña" = "123456"
} | ConvertTo-Json

try {
    $resultado = Invoke-RestMethod -Uri "http://localhost:5000/api/profesores" -Method POST -Body $nuevoProfesor -Headers $headers
    $idProfesorCreado = $resultado.id_profesor
    Write-Host "   OK - Profesor creado con ID: $idProfesorCreado" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - No se pudo crear profesor: $($_.Exception.Message)" -ForegroundColor Red
    $errores++
}

# ============================================
# TEST 5: CREAR GRUPO (POST)
# ============================================
Write-Host "[TEST 5] Creando nuevo grupo..." -ForegroundColor Yellow
$nuevoGrupo = @{
    grupo = "Grupo Test"
    id_Profesor = 1
    ubicacion = "Tecnologico"
    id_Nivel = 1
    id_Periodo = 1
    dia = "Lunes-Miercoles"
    horaInicio = "10:00"
    horaFin = "12:00"
} | ConvertTo-Json

try {
    $resultado = Invoke-RestMethod -Uri "http://localhost:5000/api/grupos" -Method POST -Body $nuevoGrupo -Headers $headers
    $idGrupoCreado = $resultado.id_Grupo
    Write-Host "   OK - Grupo creado con ID: $idGrupoCreado" -ForegroundColor Green
    $exitos++
} catch {
    Write-Host "   ERROR - No se pudo crear grupo: $($_.Exception.Message)" -ForegroundColor Red
    $errores++
}

# ============================================
# TEST 6: ASIGNAR ALUMNOS A GRUPO (POST)
# ============================================
if ($idGrupoCreado -and $nControlCreado) {
    Write-Host "[TEST 6] Asignando alumnos al grupo..." -ForegroundColor Yellow
    $asignacion = @{
        alumnoIds = @($nControlCreado, "1000", "1002")
    } | ConvertTo-Json

    try {
        $resultado = Invoke-RestMethod -Uri "http://localhost:5000/api/grupos/$idGrupoCreado/estudiantes" -Method POST -Body $asignacion -Headers $headers
        Write-Host "   OK - Alumnos asignados al grupo correctamente" -ForegroundColor Green
        $exitos++
    } catch {
        Write-Host "   ERROR - No se pudo asignar alumnos: $($_.Exception.Message)" -ForegroundColor Red
        $errores++
    }
}

# ============================================
# TEST 7: TOGGLE ESTADO ALUMNO (PATCH)
# ============================================
if ($nControlCreado) {
    Write-Host "[TEST 7] Cambiando estado del alumno..." -ForegroundColor Yellow
    try {
        $resultado = Invoke-RestMethod -Uri "http://localhost:5000/api/alumnos/$nControlCreado/toggle-estado" -Method PATCH -Headers $headers
        Write-Host "   OK - Estado del alumno cambiado correctamente" -ForegroundColor Green
        $exitos++
    } catch {
        Write-Host "   ERROR - No se pudo cambiar estado: $($_.Exception.Message)" -ForegroundColor Red
        $errores++
    }
}

# ============================================
# LIMPIEZA: ELIMINAR REGISTROS DE PRUEBA
# ============================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  LIMPIEZA - Eliminando datos de prueba" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($idGrupoCreado) {
    Write-Host "[LIMPIEZA] Eliminando grupo de prueba..." -ForegroundColor Yellow
    try {
        Invoke-RestMethod -Uri "http://localhost:5000/api/grupos/$idGrupoCreado" -Method DELETE -Headers $headers
        Write-Host "   OK - Grupo eliminado" -ForegroundColor Green
        $exitos++
    } catch {
        Write-Host "   ERROR - No se pudo eliminar grupo: $($_.Exception.Message)" -ForegroundColor Red
        $errores++
    }
}

if ($idProfesorCreado) {
    Write-Host "[LIMPIEZA] Eliminando profesor de prueba..." -ForegroundColor Yellow
    try {
        Invoke-RestMethod -Uri "http://localhost:5000/api/profesores/$idProfesorCreado" -Method DELETE -Headers $headers
        Write-Host "   OK - Profesor eliminado" -ForegroundColor Green
        $exitos++
    } catch {
        Write-Host "   ERROR - No se pudo eliminar profesor: $($_.Exception.Message)" -ForegroundColor Red
        $errores++
    }
}

if ($nControlCreado) {
    Write-Host "[LIMPIEZA] Eliminando alumno de prueba..." -ForegroundColor Yellow
    try {
        Invoke-RestMethod -Uri "http://localhost:5000/api/alumnos/$nControlCreado" -Method DELETE -Headers $headers
        Write-Host "   OK - Alumno eliminado" -ForegroundColor Green
        $exitos++
    } catch {
        Write-Host "   ERROR - No se pudo eliminar alumno: $($_.Exception.Message)" -ForegroundColor Red
        $errores++
    }
}

# ============================================
# RESUMEN FINAL
# ============================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  RESUMEN FINAL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Operaciones exitosas: $exitos" -ForegroundColor Green
Write-Host "Operaciones fallidas: $errores" -ForegroundColor $(if ($errores -gt 0) { "Red" } else { "Green" })
Write-Host ""

if ($errores -eq 0) {
    Write-Host "TODAS LAS OPERACIONES CRUD FUNCIONAN CORRECTAMENTE" -ForegroundColor Green
    Write-Host ""
    Write-Host "Operaciones probadas:" -ForegroundColor Cyan
    Write-Host "  - CREATE (POST): Crear alumnos, profesores y grupos" -ForegroundColor White
    Write-Host "  - READ (GET): Leer registros individuales y listados" -ForegroundColor White
    Write-Host "  - UPDATE (PUT): Actualizar datos de registros" -ForegroundColor White
    Write-Host "  - DELETE (DELETE): Eliminar registros" -ForegroundColor White
    Write-Host "  - PATCH: Cambiar estados" -ForegroundColor White
    Write-Host "  - Relaciones: Asignar alumnos a grupos" -ForegroundColor White
} else {
    Write-Host "ALGUNAS OPERACIONES CRUD TIENEN PROBLEMAS" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
