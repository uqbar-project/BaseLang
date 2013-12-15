package org.uqbar.research.languages.base.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import org.uqbar.research.languages.BaseInjectorProvider
import org.uqbar.research.languages.base.Class
import org.uqbar.research.languages.base.Program

import static org.junit.Assert.*

@InjectWith(BaseInjectorProvider)
@RunWith(XtextRunner)
class BaseTest {
	@Inject extension ParseHelper<Program> parser
	@Inject extension ValidationTestHelper
	@Inject extension TestHelpers

	@Test
	def void testEmptyClass() {
		val model = "class Pepita {}".parseExpectingNoErrors
		val clazz = model.classes.head as Class
		assertEquals("Pepita", clazz.name)
	}
	
	@Test
	def void testEmptyClassWithNoCurlyBraces() {
		val model = "class Pepita".parseExpectingNoErrors
		val entity = model.classes.head as Class
		assertEquals("Pepita", entity.name)
	}
	
	@Test
	def void testSimpleClassInheritance() {
		'''
			class Animal
			class Golondrina extends Animal
		'''.parseExpectingNoErrors
	}
	
	// *****************************
	// ** Properties
	// *****************************
	
	@Test
	def void testSimpleIntProperty() {
		'''
		class Animal {
			var energia : Int
		}
		'''.parseExpectingNoErrors
	}
	
	@Test
	def void testPropertyTypeCannotBeUnit() {
		'''
		class Animal {
			var padre : Unit
		}
		'''	.parse
			.assertErrorsFound(1)  //TODO: refinar
	}
	
	@Test
	def void testCannotHaveDuplicatedPropertyInSameClass() {
		'''
		class Animal {
			var padre : Animal
			var padre : Animal
		}
		'''	.parse
			.assertErrorsFound(2)  //TODO: refinar
	}
	
	@Test
	def void testCannotHaveDuplicatedPropertyInInheritance() {
		'''
			class ParentClass {
				var aProperty : String
			}

			class ChildClass extends ParentClass {
				var aProperty : String
			}
		'''	.parse
			.assertErrorsFound(1)  //TODO: refinar
	}
	
	@Test
	def void testIntPropertyWithInitializationLiteralValue() {
		'''
		class Animal {
			var energia : Int = 23
		}
		'''.parseExpectingNoErrors
	}
	
	@Test
	def void testPropertyWithInitializationConstructorValue() {
		'''
		class Animal {
			var padre : Animal = new Animal
		}
		'''.parseExpectingNoErrors
	}
	
	@Test
	def void testPropertyWithTypingErrorInInitialization() {
		'''
		class Humano
		class Animal {
			var padre : Animal = new Humano
		}
		'''	.parse
			.assertErrorsFound(1)  //por ahora es precario, debería hacer un assert
			// del tipo especifico de error y que está en el new Humano 
	}
	
	// *****************************
	// ** Methods (Declaration)
	// *****************************
	
	@Test
	def void testMethodWithoutArgumentsDontNeedToHaveEmptyParenthesisInDef() {
		'''
		class Animal {
			def doNothing : Unit
		}
		'''	.parseExpectingNoErrors
	}
	
	@Test
	def void testUnitTypeMethodWithEmptyBody() {
		'''
		class Animal {
			def doNothing : Unit = {
			}
		}
		'''	.parseExpectingNoErrors
	}
	
	// *****************************
	// ** Assignments
	// *****************************
	
	@Test
	def void testAssignToExactlyTheSamePropertyType() {
		'''
		class Animal {
			var padre : Animal
			
			def cambiarPadre(nuevo : Animal) : Unit = {
				padre := nuevo
			}
		}
		'''	.parseExpectingNoErrors
	}
	
	@Test
	def void testAssignToPropertySubType() {
		'''
		class Perro extends Animal
		class Animal {
			var padre : Animal
			
			def cambiarPadre(nuevo : Perro) : Unit = {
				padre := nuevo
			}
		}
		'''	.parseExpectingNoErrors
	}
	
	@Test
	def void testAssignToInvalidTypeMustFail() {
		'''
		class Humano
		class Animal {
			var padre : Animal
			
			def cambiarPadre(nuevo : Humano) : Unit = {
				padre := nuevo
			}
		}
		'''	.parse
			.assertErrorsFound(1)
	}
	
	@Test
	def void testAssignToValidPrimitiveTypes() {
		'''
		class Banco {
			var interes : Int

			def calcularInteres : Int = {
				interes := 23
			}
		}
		'''	.parseExpectingNoErrors
	}
	
	@Test
	def void testAssignToInvalidPrimitiveTypesMustFail() {
		'''
		class Banco {
			var interes : Int

			def calcularInteres : Int = {
				interes := "hola"
			}
		}
		'''	.parse
			.assertErrorsFound(1)
	}
	
	@Test
	def void testValidMethodReturnTypeWithLiteral() {
		'''
		class Banco {
			def calcularInteres : Int = 17
		}
		'''	.parseExpectingNoErrors
	}
	
	@Test
	def void testInvalidMethodReturnTypeWithLiteral() {
		'''
		class Banco {
			def calcularInteres : Int = "aStringNotValid"
		}
		'''	.parse
			.assertErrorsFound(1)
	}
	
	@Test
	def void testValidMethodReturnTypeWithBlock() {
		'''
		class Banco {
			def calcularInteres : Int = {
				17
			}
		}
		'''	.parseExpectingNoErrors
	}
	
	@Test
	def void testInvalidMethodReturnTypeWithBlock() {
		'''
		class Banco {
			def calcularInteres : Int = {
				"aStringNotValid"
			}
		}
		'''	.parse
			.assertErrorsFound(1)
	}
	
	@Test
	def void testBodyTypeDoesNotMatterForUnitTypedMethod() {
		'''
		class Banco {
			def calcularInteres : Unit = {
				"aStringNotValid"
			}
		}
		'''	.parseExpectingNoErrors
	}
	
	// *****************************
	// ** This
	// *****************************
	
	@Test
	def void testMethodReturningThisWithExactConcreteType() {
		'''
		class PersonaSoberbia {
			def quienEsElMejorDelMundo : PersonaSoberbia = {
				this
			}
		}
		'''	.parseExpectingNoErrors
	}
	
	@Test
	def void testMethodWithSuperTypeReturningThis() {
		'''
		class Persona
		class PersonaSoberbia extends Persona {
			def quienEsElMejorDelMundo : Persona = {
				this
			}
		}
		'''	.parseExpectingNoErrors
	}
	
	// *****************************
	// ** Scopes
	// *****************************
	
	@Test
	def void testScopeForAssignableInAssingmentUsingPropertyDeclaredOnTheSameClass() {
		'''
		class Persona {
			var edad : Int
			def nacer : Unit = {
				edad := 0
			}
		}
		'''	.parseExpectingNoErrors
	}
	
	@Test
	def void testScopeForAssignableInAssingmentUsingPropertyInheritedFromSuperClass() {
		'''
		class Animal {
			var energia : Int
		}
		class Golondrina extends Animal {
			def volar(metros: Int) : Unit = {
				energia := 23
			}
		}
		'''	.parseExpectingNoErrors
	}
	

	
}
