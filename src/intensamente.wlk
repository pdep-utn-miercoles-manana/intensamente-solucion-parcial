
class Persona {
	
	var property felicidad
	var emocionDominante
	const recuerdosDelDia = []
	const property pensamientosCentrales = #{}
	const procesosMentales = []
	
	method vivirUnEvento(descripcion) {
		const recuerdo = new Recuerdo(descripcion 		= descripcion,
									  fecha 			= new Date(),
									  emocionDominante  = emocionDominante,
									  poseedora 		= self)
		
		recuerdosDelDia.add(recuerdo)
	}
	
	method agregarAPensamientoCentral(recuerdo) {
		pensamientosCentrales.add(recuerdo)
	}
	
	method disminuirFelicidadEn10Porciento() {
		const felicidadDisminuida = felicidad * 0.9
		self.validarFelicidadNecesaria(felicidadDisminuida)

		felicidad = felicidadDisminuida
	}
	
	method validarFelicidadNecesaria(unaFelicidad) {
		if (unaFelicidad < 1) {
			throw new Exception(message = "La felicidad es demasiado baja :-(")
		}
	}
	
	method recuerdosRecientes() {
		return recuerdosDelDia.sortBy { r1, r2 => r1.fecha() > r2.fecha() }.take(5)
	}
	
	method pensamientosCentralesDificilesDeExplicar() {
		return pensamientosCentrales.filter { recuerdo => recuerdo.dificilDeExplicar() }
	}
	
	method niegaUnRecuerdo(recuerdo) {
		emocionDominante.niegaUnRecuerdo(recuerdo)
	}
	
	method irADormir() {
		// antes deben ordenarse en función de su prioridad,
		// para que liberar recuerdos del día sea el último...
		procesosMentales.forEach { proceso => proceso.apply(self) }
	}
	
	method asentarRecuerdosDelDia() {
		self.asentarEsto(recuerdosDelDia)
	}
	
	method asentarRecuerdosDelDiaQueContienen(palabra) {
		self.asentarEsto(recuerdosDelDia.filter { recuerdo => recuerdo.contiene(palabra) })
	}
	
	method asentarEsto(recuerdos) {
		recuerdos.forEach { recuerdo => recuerdo.asentar(self) }
	}
	
	method restaurar100PuntosDeFelicidad() {
		felicidad = 1000.min(felicidad + 100)
	}
	
	method agregarProcesoMental(proceso) {
		procesosMentales.add(proceso)
	}
}

object asentamiento {
	method apply(persona) {
		persona.asentarRecuerdosDelDia()	
	}
}

class AsentamientoSelectivo {
	var palabraClave
	
	method apply(persona) {
		persona.asentarRecuerdosDelDiaQueContienen(palabraClave)
	}
}

object restauracionCognitiva {
	method apply(persona) {
		persona.restaurar100PuntosDeFelicidad()
	}
}

class Recuerdo {
	
	var descripcion
	var property fecha
	var emocionDominante
	var poseedora
	
	method asentar() {
		emocionDominante.asentar(self, poseedora)
	}
	
	method dificilDeExplicar() {
		return descripcion.words().size() > 10
	}
	
	method contiene(palabra) {
		return descripcion.contains(palabra)
	}
}

object alegria {
	method asentar(recuerdo, persona) {
		if (self.puedoAsentarmeEn(persona)) {
			persona.agregarAPensamientoCentral(recuerdo)
		}
	}
	
	method puedoAsentarmeEn(persona) {
		return persona.felicidad() > 500
	}
	
	method niegaUnRecuerdo(recuerdo) {
		return recuerdo.emocionDominante() != self
	}
}

object tristeza {
	method asentarse(recuerdo, persona) {
		persona.agregarAPensamientoCentral(recuerdo)
		persona.disminuirFelicidadEn10Porciento()
	}
	
	method niegaUnRecuerdo(recuerdo) {
		return recuerdo.emocionDominante() == alegria
	}
}

object furia {
	method asentarse() {
		
	}
	
	method niegaUnRecuerdo() {
		return false
	}
}

object temor {
	method asentarse() {
		
	}
	
	method niegaUnRecuerdo() {
		return false
	}
}

object disgusto {
	method asentarse() {
		
	}
	
	method niegaUnRecuerdo() {
		return false
	}
}
