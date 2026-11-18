#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUPS_DIR="${BACKUPS_DIR:-$SCRIPT_DIR/backups}"

# Script para restaurar un backup de la base de datos
# Uso: ./restaurar_backup.sh backup_hospital_20251124_204442.sql.gz

if [ -z "$1" ]; then
    echo "❌ Error: Debes especificar el archivo de backup"
    echo "Uso: ./restaurar_backup.sh <archivo_backup>"
    echo ""
    echo "Backups disponibles:"
    ls -lh "$BACKUPS_DIR"/
    exit 1
fi

BACKUP_FILE="$1"
BACKUP_PATH="$BACKUPS_DIR/$BACKUP_FILE"

# Verificar que el archivo existe
if [ ! -f "$BACKUP_PATH" ]; then
    echo "❌ Error: El archivo $BACKUP_FILE no existe"
    echo ""
    echo "Backups disponibles:"
    ls -lh "$BACKUPS_DIR"/
    exit 1
fi

# Configuración de la base de datos (debe coincidir con settings.py)
DB_NAME="${DB_NAME:-hospital}"
DB_USER="${DB_USER:-root}"
DB_PASS="${DB_PASSWORD:-}"

echo "⚠️  ADVERTENCIA: Esto sobrescribirá la base de datos actual '$DB_NAME'"
read -p "¿Estás seguro? (escribe 'SI' para continuar): " confirmacion

if [ "$confirmacion" != "SI" ]; then
    echo "❌ Restauración cancelada"
    exit 0
fi

echo "🔄 Restaurando backup: $BACKUP_FILE"

# Restaurar según el tipo de archivo
if [[ "$BACKUP_FILE" == *.gz ]]; then
    echo "📦 Descomprimiendo y restaurando..."
    gunzip -c "$BACKUP_PATH" | mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME"
else
    echo "📝 Restaurando archivo SQL..."
    mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$BACKUP_PATH"
fi

if [ $? -eq 0 ]; then
    echo "✅ Base de datos restaurada exitosamente!"
else
    echo "❌ Error al restaurar la base de datos"
    exit 1
fi
