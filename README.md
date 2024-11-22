# SQL-Archivo

https://www.utnianos.com.ar/foro/attachment.php?aid=17347

 -- Verificar si es un INSERT
    IF EXISTS (SELECT 1 FROM INSERTED) AND NOT EXISTS (SELECT 1 FROM DELETED)
    BEGIN
        PRINT 'INSERT detected'
        -- Acciones para INSERT
    END

    -- Verificar si es un DELETE
    ELSE IF NOT EXISTS (SELECT 1 FROM INSERTED) AND EXISTS (SELECT 1 FROM DELETED)
    BEGIN
        PRINT 'DELETE detected'
        -- Acciones para DELETE
    END

    -- Verificar si es un UPDATE
    ELSE IF EXISTS (SELECT 1 FROM INSERTED) AND EXISTS (SELECT 1 FROM DELETED)
    BEGIN
        PRINT 'UPDATE detected'
        -- Acciones para UPDATE
    END
