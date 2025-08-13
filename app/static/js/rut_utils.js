/* app/static/js/rut_utils.js
 * Utilitario genérico para validar RUT (Chile) en formularios.
 * - Cálculo de DV, validación de formato y consistencia.
 * - Consulta al backend para verificar existencia (endpoint configurable).
 * - Manejo de modales (inválido / ya existe / válido).
 * - Enfoque y limpieza de campos según resultado.
 *
 * Uso en el template:
 *  <script src="{{ url_for('static', filename='js/rut_utils.js') }}"></script>
 *  <script>
 *    document.addEventListener('DOMContentLoaded', function(){
 *      initRutValidation({
 *        formId: 'empleador-form',                // ID del <form>
 *        rutCuerpoId: 'rut_cuerpo',               // ID del input del cuerpo del RUT
 *        rutDvId: 'rut_dv',                       // ID del input del DV
 *        nextFocusId: 'razon_social',             // ID del siguiente campo a enfocar cuando el RUT está OK
 *        modals: {
 *          invalidId: 'modalRutInvalido',         // Modal para RUT inválido
 *          existsId: 'modalRutExiste',            // Modal para RUT ya existente
 *          existsBtnId: 'modalRutExisteBtn',      // (opcional) Botón de aceptar del modal 'existe'
 *          okId: 'modalRutNuevo',                 // Modal para RUT válido y no existente
 *          okBtnId: 'modalRutNuevoBtn'            // (opcional) Botón de aceptar del modal 'nuevo'
 *        },
 *        endpoint: '/empleadores/api/empleador/existe' // Endpoint GET ?rut_cuerpo=...&rut_dv=...
 *      });
 *    });
 *  </script>
 */

(function () {
  // ------- Helpers de DOM / Modal -------

  function $(id) {
    return document.getElementById(id);
  }

  function showModal(id) {
    const el = $(id);
    if (!el) return null;
    const instance = bootstrap ? new bootstrap.Modal(el) : null;
    if (instance) instance.show();
    return el;
  }

  // ------- Lógica de RUT (genérica) -------

  function calcularDV(rutCuerpo) {
    let suma = 0;
    let factor = 2;
    for (let i = rutCuerpo.length - 1; i >= 0; i--) {
      suma += parseInt(rutCuerpo[i], 10) * factor;
      factor = factor === 7 ? 2 : factor + 1;
    }
    const dv = 11 - (suma % 11);
    if (dv === 11) return '0';
    if (dv === 10) return 'K';
    return String(dv);
  }

  function validarRutJS(rutCuerpo, rutDV) {
    if (!rutCuerpo || !rutDV) return "Ambos campos RUT y dígito verificador son obligatorios.";
    if (!/^\d{7,8}$/.test(rutCuerpo)) return "El RUT debe tener entre 7 y 8 dígitos numéricos.";
    if (!/^[0-9Kk]$/.test(rutDV)) return "El dígito verificador debe ser un número o la letra K.";
    const dvCalculado = calcularDV(rutCuerpo);
    if (dvCalculado !== rutDV.toUpperCase()) return `RUT inválido. El dígito verificador debería ser ${dvCalculado}.`;
    return true;
  }

  // ------- Núcleo configurable -------

  function initRutValidation(options) {
    // Evitar errores por opciones ausentes
    if (!options || !options.formId || !options.rutCuerpoId || !options.rutDvId) {
      console.warn("[rut_utils] Faltan opciones obligatorias: formId, rutCuerpoId, rutDvId");
      return;
    }
    if (!options.modals || !options.modals.invalidId || !options.modals.existsId || !options.modals.okId) {
      console.warn("[rut_utils] Debes definir modals.invalidId, modals.existsId y modals.okId");
      return;
    }
    if (!options.endpoint) {
      console.warn("[rut_utils] Debes definir 'endpoint' para verificar existencia.");
      return;
    }

    const form = $(options.formId);
    const rutCuerpoInput = $(options.rutCuerpoId);
    const rutDvInput = $(options.rutDvId);

    if (!form || !rutCuerpoInput || !rutDvInput) {
      console.warn("[rut_utils] No se encontraron elementos con los IDs declarados.", {
        form: options.formId, rutCuerpo: options.rutCuerpoId, rutDv: options.rutDvId
      });
      return;
    }

    // Evitar doble inicialización sobre el mismo form
    if (form.dataset.rutValidationBound === "1") {
      return;
    }
    form.dataset.rutValidationBound = "1";

    const nextFocusId = options.nextFocusId || null;

    const modals = {
      invalidId: options.modals.invalidId,
      existsId: options.modals.existsId,
      existsBtnId: options.modals.existsBtnId || null,
      okId: options.modals.okId,
      okBtnId: options.modals.okBtnId || null
    };

    const endpoint = options.endpoint;
    let modalMostrado = false;

    // Limpieza y foco tras modal "inválido"
    const modalInvalidEl = $(modals.invalidId);
    if (modalInvalidEl) {
      modalInvalidEl.addEventListener("hidden.bs.modal", function () {
        rutCuerpoInput.value = "";
        rutDvInput.value = "";
        setTimeout(() => rutCuerpoInput.focus(), 0);
        modalMostrado = false;
      });
    }

    // Limpieza y foco tras modal "existe"
    const modalExistsEl = $(modals.existsId);
    if (modalExistsEl) {
      if (modals.existsBtnId && $(modals.existsBtnId)) {
        $(modals.existsBtnId).onclick = function () {
          rutCuerpoInput.value = "";
          rutDvInput.value = "";
          rutCuerpoInput.focus();
          modalMostrado = false;
        };
      }
      modalExistsEl.addEventListener("hidden.bs.modal", function () {
        rutCuerpoInput.value = "";
        rutDvInput.value = "";
        rutCuerpoInput.focus();
        modalMostrado = false;
      }, { once: true });
    }

    // Enfoque tras modal "ok"
    const modalOkEl = $(modals.okId);
    function focusNextAfterOk() {
      if (nextFocusId && $(nextFocusId)) {
        $(nextFocusId).focus();
      }
      modalMostrado = false;
    }
    if (modalOkEl) {
      if (modals.okBtnId && $(modals.okBtnId)) {
        $(modals.okBtnId).onclick = focusNextAfterOk;
      }
      modalOkEl.addEventListener("hidden.bs.modal", focusNextAfterOk, { once: true });
    }

    // Disparador: al completar el DV (1 caracter) o al perder foco
    function runCheckIfReady() {
      if (modalMostrado) return;

      const rutCuerpo = (rutCuerpoInput.value || "").trim();
      const rutDV = (rutDvInput.value || "").trim();

      // Valida solo si hay 1 caracter en DV (comportamiento actual) o si el DV pierde foco
      if (rutDV.length !== 1) return;

      const valid = validarRutJS(rutCuerpo, rutDV);
      if (valid !== true) {
        showModal(modals.invalidId);
        modalMostrado = true;
        return;
      }

      // RUT válido → consultar existencia al backend
      const url = `${endpoint}?rut_cuerpo=${encodeURIComponent(rutCuerpo)}&rut_dv=${encodeURIComponent(rutDV)}`;
      fetch(url, { method: "GET" })
        .then(resp => resp.json())
        .then(data => {
          if (data && data.existe) {
            showModal(modals.existsId);
            modalMostrado = true;
          } else {
            showModal(modals.okId);
            modalMostrado = true;
          }
        })
        .catch(err => {
          console.error("[rut_utils] Error al consultar existencia de RUT:", err);
          // En caso de error de red, no bloqueamos al usuario: continuamos sin modal.
        });
    }

    rutDvInput.addEventListener("input", runCheckIfReady);
    rutDvInput.addEventListener("blur", runCheckIfReady);

    // Validación en submit: bloquea si el RUT es inválido
    form.addEventListener("submit", function (event) {
      const rutCuerpo = (rutCuerpoInput.value || "").trim();
      const rutDV = (rutDvInput.value || "").trim();
      const valid = validarRutJS(rutCuerpo, rutDV);

      if (valid !== true) {
        event.preventDefault();
        if (!modalMostrado) {
          showModal(modals.invalidId);
          modalMostrado = true;
        }
      }
    });
  }

  // Exponer funciones necesarias a nivel global (si hiciera falta)
  window.initRutValidation = initRutValidation;
  window.calcularDV = calcularDV;       // opcional, por si lo quieres reutilizar
  window.validarRutJS = validarRutJS;   // opcional, por si lo quieres reutilizar
})();
