// trabajador.js PRO: UX y accesibilidad óptimas

function calcularDV(rutCuerpo) {
  let suma = 0;
  let factor = 2;
  for (let i = rutCuerpo.length - 1; i >= 0; i--) {
    suma += parseInt(rutCuerpo[i]) * factor;
    factor = factor === 7 ? 2 : factor + 1;
  }
  const dv = 11 - (suma % 11);
  if (dv === 11) return '0';
  if (dv === 10) return 'K';
  return dv.toString();
}

function validarRutJS(rutCuerpo, rutDV) {
  if (!rutCuerpo || !rutDV) return "Ambos campos RUT y dígito verificador son obligatorios.";
  if (!/^\d{7,8}$/.test(rutCuerpo)) return "El RUT debe tener entre 7 y 8 dígitos numéricos.";
  if (!/^[0-9Kk]$/.test(rutDV)) return "El dígito verificador debe ser un número o la letra K.";
  const dvCalculado = calcularDV(rutCuerpo);
  if (dvCalculado !== rutDV.toUpperCase()) return `RUT inválido. El dígito verificador debería ser ${dvCalculado}.`;
  return true;
}

document.addEventListener("DOMContentLoaded", function () {
  const rutCuerpoInput = document.getElementById("rut_cuerpo");
  const rutDVInput = document.getElementById("rut_dv");
  const nombreInput = document.getElementById("nombre");
  const form = document.getElementById("trabajador-form");

  let modalMostrado = false;

  function mostrarModal(idModal) {
    const modal = new bootstrap.Modal(document.getElementById(idModal));
    modal.show();
  }

  // MODAL ERROR RUT: limpieza y foco SOLO después que el modal se oculta completamente
  const modalRutInvalido = document.getElementById("modalRutInvalido");
  if (modalRutInvalido) {
    modalRutInvalido.addEventListener("hidden.bs.modal", function () {
      rutCuerpoInput.value = '';
      rutDVInput.value = '';
      setTimeout(() => rutCuerpoInput.focus(), 0); // Foco seguro tras cierre real
      modalMostrado = false;
    });
  }

  // MODAL RUT YA EXISTE: limpiar campos y devolver foco a RUT
  const modalRutExiste = document.getElementById("modalRutExiste");
  if (modalRutExiste) {
    document.getElementById("modalRutExisteBtn").onclick = function () {
      rutCuerpoInput.value = '';
      rutDVInput.value = '';
      rutCuerpoInput.focus();
      modalMostrado = false;
    };
    modalRutExiste.addEventListener("hidden.bs.modal", function () {
      rutCuerpoInput.value = '';
      rutDVInput.value = '';
      rutCuerpoInput.focus();
      modalMostrado = false;
    }, { once: true });
  }

  // Validación en el evento "input" (apenas escribe el DV)
  rutDVInput.addEventListener("input", function () {
    if (modalMostrado) return;
    const rutCuerpo = rutCuerpoInput.value.trim();
    const rutDV = rutDVInput.value.trim();

    if (rutDV.length === 1) {
      const valido = validarRutJS(rutCuerpo, rutDV);
      if (valido !== true) {
        mostrarModal("modalRutInvalido");
        modalMostrado = true;
        return;
      }

      // Consulta al backend solo si el RUT es válido
      fetch(`/trabajadores/api/trabajador/existe?rut_cuerpo=${rutCuerpo}&rut_dv=${rutDV}`)
        .then(resp => resp.json())
        .then(data => {
          if (data.existe) {
            mostrarModal("modalRutExiste");
            modalMostrado = true;
          } else {
            mostrarModal("modalRutNuevo");
            modalMostrado = true;
            document.getElementById("modalRutNuevoBtn").onclick = function () {
              nombreInput.focus();
              modalMostrado = false;
            };
            document.getElementById("modalRutNuevo").addEventListener("hidden.bs.modal", function () {
              nombreInput.focus();
              modalMostrado = false;
            }, { once: true });
          }
        }).catch(err => {
          console.error("Error al consultar existencia de RUT:", err);
        });
    }
  });

  // Validación en submit para bloquear envío si RUT inválido
  form.addEventListener("submit", function (event) {
    const rutCuerpo = rutCuerpoInput.value.trim();
    const rutDV = rutDVInput.value.trim();
    const valido = validarRutJS(rutCuerpo, rutDV);

    if (valido !== true) {
      event.preventDefault();  // Evita envío del formulario
      if (!modalMostrado) {
        mostrarModal("modalRutInvalido");
        modalMostrado = true;
      }
    }
  });
});
