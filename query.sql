CREATE DATABASE DBContactos;
GO

USE DBContactos;
GO

CREATE TABLE Contactos (
    IdContacto INT IDENTITY(1,1) PRIMARY KEY,
    Nombres NVARCHAR(100) NOT NULL,
    Apellidos NVARCHAR(100) NOT NULL,
    Telefono NVARCHAR(20) DEFAULT 'Sin número',
    CorreoElectronico NVARCHAR(150) DEFAULT 'Sin correo',
    Direccion NVARCHAR(200) NULL,
    Notas NVARCHAR(MAX) NULL,
    Estado BIT DEFAULT 1, -- 1 = Activo, 0 = Eliminado lógicamente
    FechaCreacion DATETIME DEFAULT GETDATE(),
    UsuarioCreacion NVARCHAR(50),
    FechaModificacion DATETIME NULL,
    UsuarioModificacion NVARCHAR(50) NULL,
    FechaEliminacion DATETIME NULL,
    UsuarioEliminacion NVARCHAR(50) NULL
);
GO

CREATE PROCEDURE InsertarContacto
    @Nombres NVARCHAR(100),
    @Apellidos NVARCHAR(100),
    @Telefono NVARCHAR(20) = NULL,
    @CorreoElectronico NVARCHAR(150) = NULL,
    @Direccion NVARCHAR(200) = NULL,
    @Notas NVARCHAR(MAX) = NULL,
    @UsuarioCreacion NVARCHAR(50),
    @Mensaje NVARCHAR(200) OUTPUT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Contactos (
            Nombres, Apellidos, Telefono, CorreoElectronico,
            Direccion, Notas, UsuarioCreacion
        )
        VALUES (
            @Nombres, @Apellidos,
            ISNULL(@Telefono, 'Sin número'),
            ISNULL(@CorreoElectronico, 'Sin correo'),
            @Direccion, @Notas, @UsuarioCreacion
        );

        DECLARE @IdNuevo INT = SCOPE_IDENTITY();

        SET @Mensaje = CONCAT('Contacto insertado exitosamente. ID: ', @IdNuevo);

        SELECT * FROM Contactos WHERE IdContacto = @IdNuevo;
    END TRY
    BEGIN CATCH
        SET @Mensaje = ERROR_MESSAGE();
        SELECT ERROR_MESSAGE() AS Error;
    END CATCH
END;
GO

CREATE PROCEDURE ActualizarContacto
    @IdContacto INT,
    @Nombres NVARCHAR(100),
    @Apellidos NVARCHAR(100),
    @Telefono NVARCHAR(20),
    @CorreoElectronico NVARCHAR(150),
    @Direccion NVARCHAR(200),
    @Notas NVARCHAR(MAX),
    @UsuarioModificacion NVARCHAR(50),
    @Mensaje NVARCHAR(200) OUTPUT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Contactos WHERE IdContacto = @IdContacto AND Estado = 1)
        BEGIN
            UPDATE Contactos
            SET Nombres = @Nombres,
                Apellidos = @Apellidos,
                Telefono = ISNULL(@Telefono, 'Sin número'),
                CorreoElectronico = ISNULL(@CorreoElectronico, 'Sin correo'),
                Direccion = @Direccion,
                Notas = @Notas,
                FechaModificacion = GETDATE(),
                UsuarioModificacion = @UsuarioModificacion
            WHERE IdContacto = @IdContacto;

            SET @Mensaje = 'Contacto actualizado correctamente.';
            SELECT * FROM Contactos WHERE IdContacto = @IdContacto;
        END
        ELSE
        BEGIN
            SET @Mensaje = 'No se encontró el contacto o ya está eliminado.';
            SELECT @Mensaje AS Mensaje;
        END
    END TRY
    BEGIN CATCH
        SET @Mensaje = ERROR_MESSAGE();
        SELECT ERROR_MESSAGE() AS Error;
    END CATCH
END;
GO

CREATE PROCEDURE EliminarContacto
    @IdContacto INT,
    @UsuarioEliminacion NVARCHAR(50),
    @Mensaje NVARCHAR(200) OUTPUT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Contactos WHERE IdContacto = @IdContacto AND Estado = 1)
        BEGIN
            UPDATE Contactos
            SET Estado = 0,
                FechaEliminacion = GETDATE(),
                UsuarioEliminacion = @UsuarioEliminacion
            WHERE IdContacto = @IdContacto;

            SET @Mensaje = 'Contacto eliminado lógicamente.';
            SELECT * FROM Contactos WHERE IdContacto = @IdContacto;
        END
        ELSE
        BEGIN
            SET @Mensaje = 'No se encontró el contacto o ya está eliminado.';
            SELECT @Mensaje AS Mensaje;
        END
    END TRY
    BEGIN CATCH
        SET @Mensaje = ERROR_MESSAGE();
        SELECT ERROR_MESSAGE() AS Error;
    END CATCH
END;
GO

CREATE PROCEDURE ObtenerContactosActivos
AS
BEGIN
    BEGIN TRY
        SELECT * FROM Contactos WHERE Estado = 1;
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS Error;
    END CATCH
END;
