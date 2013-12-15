package org.uqbar.research.languages.base.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import org.uqbar.research.languages.BaseInjectorProvider
import org.uqbar.research.languages.base.Program

@InjectWith(BaseInjectorProvider)
@RunWith(XtextRunner)
class ConstructorsTest {
	@Inject extension ParseHelper<Program> parser
	@Inject extension ValidationTestHelper
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
	
}