# Sistema de Backup Automático de Base de Datos

## 📋 Descripción
Sistema de backup automático para la base de datos MySQL del hospital. Crea copias de seguridad comprimidas y gestiona la rotación automática de backups antiguos.

## 🚀 Uso Manual

### Backup básico
```bash
cd /path/to/proyectohospital
/path/to/project/venv/bin/python manage.py backup_database
```

### Backup comprimido (recomendado)
```bash
/path/to/project/venv/bin/python manage.py backup_database --compress
```

### Mantener más días de backups
```bash
/path/to/project/venv/bin/python manage.py backup_database --compress --keep-days=30
```

### Especificar directorio de backups
```bash
/path/to/project/venv/bin/python manage.py backup_database --backup-dir=/ruta/custom
```

## ⚙️ Configuración Automática (Cron)

### 1. Dar permisos de ejecución al script
```bash
chmod +x /path/to/proyectohospital/backup_diario.sh
```

### 2. Editar crontab
```bash
crontab -e
```

### 3. Agregar una de estas líneas:

#### Backup diario a las 3:00 AM
```
0 3 * * * /path/to/proyectohospital/backup_diario.sh
```

#### Backup cada 12 horas (3:00 AM y 3:00 PM)
```
0 3,15 * * * /path/to/proyectohospital/backup_diario.sh
```

#### Backup cada 6 horas
```
0 */6 * * * /path/to/proyectohospital/backup_diario.sh
```

### 4. Verificar que el cron se agregó
```bash
crontab -l
```

## 📁 Ubicación de Backups
Por defecto: `/path/to/proyectohospital/backups/`

Formato de archivos:
- **Sin comprimir**: `backup_hospital_20241124_153045.sql`
- **Comprimido**: `backup_hospital_20241124_153045.sql.gz`

## 🔄 Rotación Automática
- **Por defecto**: Mantiene los últimos 7 días de backups
- Los backups más antiguos se eliminan automáticamente
- Configurable con `--keep-days=N`

## 📊 Características
✅ Backup completo de la base de datos MySQL
✅ Compresión automática con gzip (ahorra ~70-80% de espacio)
✅ Rotación automática de backups antiguos
✅ Nombres de archivo con timestamp
✅ Incluye rutinas, triggers y eventos
✅ Transacciones consistentes (--single-transaction)
✅ Logs de ejecución

## 🛠️ Restaurar un Backup

### Backup sin comprimir (.sql)
```bash
mysql -u admin -p hospital < backup_hospital_20241124_153045.sql
```

### Backup comprimido (.sql.gz)
```bash
gunzip -c backup_hospital_20241124_153045.sql.gz | mysql -u admin -p hospital
```

## 📝 Logs
Los logs de ejecución se guardan en:
```
/path/to/project/backups/backup.log
```

Para ver los últimos logs:
```bash
tail -f /path/to/project/backups/backup.log
```

## ⚠️ Notas Importantes
1. **Espacio en disco**: Asegúrate de tener suficiente espacio (al menos 2-3x el tamaño de la BD)
2. **Permisos**: El usuario debe tener permisos para ejecutar `mysqldump`
3. **Credenciales**: Las credenciales se toman de `settings.py`
4. **Backup externo**: Considera copiar backups a otro servidor o nube periódicamente

## 🔐 Seguridad
- Los backups contienen datos sensibles
- Mantén el directorio `backups/` con permisos restringidos
- No versionar el directorio `backups/` en git (ya está en .gitignore)

## 📞 Solución de Problemas

### Error: "mysqldump: command not found"
Instalar MySQL:
```bash
brew install mysql
```

### Error de permisos
```bash
chmod +x backup_diario.sh
chmod 755 /path/to/proyectohospital/backups
```

### Ver si el cron está funcionando
```bash
# Ver logs del sistema (macOS)
log show --predicate 'process == "cron"' --last 1h
```
