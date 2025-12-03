# Script para inicializar Git y conectar con GitHub
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CONFIGURAR GIT Y GITHUB" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si Git esta instalado
try {
    $gitVersion = git --version
    Write-Host "Git instalado: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Git no esta instalado" -ForegroundColor Red
    Write-Host "Descarga Git desde: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "Antes de continuar, necesitas:" -ForegroundColor Yellow
Write-Host "  1. Crear un repositorio en GitHub" -ForegroundColor White
Write-Host "  2. Nombre sugerido: api-escolar-azure" -ForegroundColor White
Write-Host "  3. Visibilidad: Private (recomendado)" -ForegroundColor White
Write-Host "  4. NO inicializar con README" -ForegroundColor White
Write-Host ""

$continuar = Read-Host "Ya creaste el repositorio en GitHub? (S/N)"

if ($continuar -ne "S" -and $continuar -ne "s") {
    Write-Host ""
    Write-Host "Pasos para crear repositorio:" -ForegroundColor Cyan
    Write-Host "  1. Ve a: https://github.com/new" -ForegroundColor White
    Write-Host "  2. Nombre: api-escolar-azure" -ForegroundColor White
    Write-Host "  3. Click en 'Create repository'" -ForegroundColor White
    Write-Host "  4. Ejecuta este script nuevamente" -ForegroundColor White
    Write-Host ""
    exit
}

Write-Host ""
Write-Host "Repositorio detectado: API-AZURE" -ForegroundColor Cyan
Write-Host "Usuario: JesusTA2001" -ForegroundColor Cyan
Write-Host ""

$usuario = "JesusTA2001"
$repo = "API-AZURE"

$confirmar = Read-Host "Es correcto este repositorio? (S/N)"
if ($confirmar -ne "S" -and $confirmar -ne "s") {
    $usuario = Read-Host "Ingresa tu usuario de GitHub"
    $repo = Read-Host "Ingresa el nombre del repositorio"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  INICIALIZANDO GIT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Ir al directorio backend
Set-Location "C:\Users\jesus\OneDrive\Escritorio\api-azure"

# Verificar si ya esta inicializado
if (Test-Path ".git") {
    Write-Host "Git ya esta inicializado" -ForegroundColor Yellow
    $reiniciar = Read-Host "Quieres reiniciar? (S/N)"
    if ($reiniciar -eq "S" -or $reiniciar -eq "s") {
        Remove-Item -Recurse -Force .git
        Write-Host "Git reiniciado" -ForegroundColor Green
    }
}

# Inicializar Git
if (-not (Test-Path ".git")) {
    Write-Host "Inicializando Git..." -ForegroundColor Yellow
    git init
    Write-Host "Git inicializado" -ForegroundColor Green
}

# Configurar usuario de Git (si no esta configurado)
$gitUser = git config --global user.name
if ([string]::IsNullOrWhiteSpace($gitUser)) {
    Write-Host ""
    $nombre = Read-Host "Ingresa tu nombre para Git"
    $email = Read-Host "Ingresa tu email para Git"
    git config --global user.name "$nombre"
    git config --global user.email "$email"
    Write-Host "Usuario Git configurado" -ForegroundColor Green
}

Write-Host ""
Write-Host "Agregando archivos..." -ForegroundColor Yellow
git add .

Write-Host "Creando commit inicial..." -ForegroundColor Yellow
git commit -m "Initial commit - API funcionando y verificada"

Write-Host "Configurando rama principal..." -ForegroundColor Yellow
# Verificar si la rama ya es master o main
$ramaActual = git branch --show-current
if ([string]::IsNullOrWhiteSpace($ramaActual)) {
    git branch -M master
    Write-Host "Rama 'master' configurada" -ForegroundColor Green
} else {
    Write-Host "Rama actual: $ramaActual" -ForegroundColor Green
}

Write-Host "Conectando con GitHub..." -ForegroundColor Yellow
$remoteUrl = "https://github.com/$usuario/$repo.git"
git remote add origin $remoteUrl

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SUBIENDO A GITHUB" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Subiendo codigo a GitHub..." -ForegroundColor Yellow
Write-Host "Se te pedira autenticacion de GitHub" -ForegroundColor Yellow
Write-Host ""

try {
    # Detectar la rama actual
    $rama = git branch --show-current
    if ([string]::IsNullOrWhiteSpace($rama)) {
        $rama = "master"
    }
    
    Write-Host "Subiendo a rama: $rama" -ForegroundColor Cyan
    git push -u origin $rama
    Write-Host ""
    Write-Host "CODIGO SUBIDO EXITOSAMENTE" -ForegroundColor Green
    Write-Host ""
    Write-Host "Tu repositorio:" -ForegroundColor Cyan
    Write-Host "  https://github.com/$usuario/$repo" -ForegroundColor White
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "SIGUIENTE PASO: CREAR APP SERVICE EN AZURE" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Sigue las instrucciones en:" -ForegroundColor White
    Write-Host "  backend/PLAN_DESPLIEGUE_AZURE.md" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Fase 3: CREAR AZURE APP SERVICE" -ForegroundColor Yellow
    Write-Host ""
} catch {
    Write-Host ""
    Write-Host "ERROR al subir a GitHub" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Posibles soluciones:" -ForegroundColor Yellow
    Write-Host "  1. Verifica que el repositorio existe en GitHub" -ForegroundColor White
    Write-Host "  2. Verifica tu usuario y repositorio" -ForegroundColor White
    Write-Host "  3. Autenticate con GitHub (token o SSH)" -ForegroundColor White
    Write-Host ""
}
