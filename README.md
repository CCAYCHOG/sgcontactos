# Sistema de Gestión de Contactos con Flask

Este proyecto es una aplicación web básica para registrar, editar, eliminar y buscar contactos, usando Python Flask y SQL Server como base de datos.

---

## Tecnologías
- Python 3
- Flask
- Bootstrap 5
- jQuery
- SQL Server

---

## Estructura
- `run.py`: Punto de entrada de la app.
- `app/`: Contiene el código fuente Flask, templates y archivos estáticos.
- `models.py`: Lógica de acceso a datos y llamadas a procedimientos almacenados.

---

## Instalación

```bash
git clone https://github.com/CCAYCHOG/sgcontactos.git
cd sgcontactos
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt

python run.py
```