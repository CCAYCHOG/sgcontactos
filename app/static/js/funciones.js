let contactos = [];

function renderContactos() {
    const buscar = $('#buscar').val().toLowerCase();
    const filas = contactos
        .filter(c => c.nombres.toLowerCase().includes(buscar) || c.apellidos.toLowerCase().includes(buscar))
        .map(c => `
            <tr>
                <td>${c.nombres} ${c.apellidos}</td>
                <td>${c.telefono}</td>
                <td>${c.correo}</td>
                <td>
                    <button class="btn btn-sm btn-warning" onclick="editar(${c.id})"><i class="bi bi-pencil"></i></button>
                    <button class="btn btn-sm btn-danger" onclick="eliminar(${c.id})"><i class="bi bi-trash"></i></button>
                </td>
            </tr>
        `);
    $('#tablaContactos').html(filas.join(''));
}

$('#formContacto').on('submit', function(e) {
    e.preventDefault();
    const nuevo = {
        id: Date.now(),
        nombres: $('#nombres').val(),
        apellidos: $('#apellidos').val(),
        telefono: $('#telefono').val() || 'Sin número',
        correo: $('#correo').val() || 'Sin correo',
        direccion: $('#direccion').val(),
        notas: $('#notas').val()
    };
    contactos.push(nuevo);
    this.reset();
    renderContactos();
});

$('#buscar').on('input', renderContactos);

function editar(id) {
    const c = contactos.find(x => x.id === id);
    $('#editId').val(c.id);
    $('#editNombres').val(c.nombres);
    $('#editApellidos').val(c.apellidos);
    $('#editTelefono').val(c.telefono);
    $('#editCorreo').val(c.correo);
    $('#editDireccion').val(c.direccion);
    $('#editNotas').val(c.notas);
    new bootstrap.Modal(document.getElementById('modalEditar')).show();
}

$('#guardarCambios').on('click', function() {
    const id = parseInt($('#editId').val());
    const c = contactos.find(x => x.id === id);
    c.nombres = $('#editNombres').val();
    c.apellidos = $('#editApellidos').val();
    c.telefono = $('#editTelefono').val();
    c.correo = $('#editCorreo').val();
    c.direccion = $('#editDireccion').val();
    c.notas = $('#editNotas').val();
    renderContactos();
    bootstrap.Modal.getInstance(document.getElementById('modalEditar')).hide();
});

function eliminar(id) {
    if (confirm('¿Seguro que deseas eliminar este contacto?')) {
        contactos = contactos.filter(c => c.id !== id);
        renderContactos();
    }
}