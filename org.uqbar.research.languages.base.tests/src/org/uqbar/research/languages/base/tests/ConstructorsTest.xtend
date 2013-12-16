package org.uqbar.research.languages.base.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith
import org.uqbar.research.languages.BaseInjectorProvider
import org.uqbar.research.languages.base.Program

@InjectWith(BaseInjectorProvider)
@RunWith(XtextRunner)
class ConstructorsTest {
	@Inject extension ParseHelper<Program> parser
	@Inject extension TestHelpers
	
	@Test
	def void testNoArgsConstructorCallWithParenthesis() {
		'''
			class Animal
			class God {
				def createAnimal : Animal = {
					new Animal()
				}
			}
		'''	.parse
			.assertErrorsFound(1)
	}
	
	@Test
	def void testNoArgsConstructorCallWithOutParenthesis() {
		'''
			class Animal
			class God {
				def createAnimal : Animal = {
					new Animal
				}
			}
		'''.parseExpectingNoErrors
	}
	
	@Test
	def void testConstructorCallWithOneParameter() {
		'''
			class Golondrina {
				var energia : Int
			}
			class God {
				def createAnimal : Golondrina = {
					new Golondrina(energia = 23)
				}
			}
		'''.parseExpectingNoErrors
	}
	
	@Test
	def void testConstructorCallWithTwoParametersOneInheritedFromSuperclass() {
		'''
			class Animal {
				var energia : Int
			}
			class PalomaMensajera extends Animal {
				var mensajeActual : String
			}
			class God {
				def createAnimal : Animal = {
					new PalomaMensajera(energia = 23, mensajeActual = "Hola Mundo")
				}
			}
		'''.parseExpectingNoErrors
	}
	
	@Test
	def void testConstructorCallNotInitializingAllTheProperties() {
		'''
			class Animal {
				var energia : Int
			}
			class PalomaMensajera extends Animal {
				var mensajeActual : String
			}
			class God {
				def createAnimal : Animal = {
					new PalomaMensajera(energia = 23)
				}
			}
		'''.parseExpectingNoErrors
	}
	
	@Test
	def void testConstructorCallTypesCompatibilityWithPrimitiveTypes() {
		'''
			class Programa {
					var duracion : Int
					var nombre : String
			}
			
			class Emisora {
				def crearPrograma(nombre : String) : Programa = {
					new Programa(nombre = nombre, duracion = 21)
				}
			}
		'''.parseExpectingNoErrors
	}
	
	@Test
	def void testConstructorCallTypesCompatibilityWithPrimitiveTypesAndInvalidType() {
		'''
			class Programa {
					var duracion : Int
					var nombre : String
			}
			
			class Emisora {
				def crearPrograma(nombre : String) : Programa = {
					new Programa(nombre = nombre, duracion = "Hola Mundo")
				}
			}
		'''.parse
			.assertErrorsFound(1)
	}
	
	@Test
	def void testConstructorCallTypesCompatibilityWithComplexType() {
		'''
			class Conductor
			class Programa {
					var conductor : Conductor
			}
			
			class Emisora {
				def crearPrograma(nombre : String, c : Conductor) : Programa = {
					new Programa(conductor = c)
				}
			}
		'''.parseExpectingNoErrors
	}
	
		@Test
	def void testConstructorCallTypesCompatibilityWithComplexTypeAndSubtype() {
		'''
			class Persona
			class Periodista extends Persona
			class Programa {
					var conductor : Persona
			}
			
			class Emisora {
				def crearPrograma(nombre : String, periodista : Periodista) : Programa = {
					new Programa(conductor = periodista)
				}
			}
		'''.parseExpectingNoErrors
	}

	
}