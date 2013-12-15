package org.uqbar.research.languages.base.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.runner.RunWith
import org.uqbar.research.languages.BaseInjectorProvider
import org.uqbar.research.languages.base.Program
import org.junit.Test

/**
 * @author jfernandes
 */
@InjectWith(BaseInjectorProvider)
@RunWith(XtextRunner)
class MethodTest {
	@Inject extension ParseHelper<Program> parser
	@Inject extension TestHelpers
	
	@Test
	def void testMethodCallWithoutParenthesis() {
		'''
			class Perro {
				def ladrar : String = {
					"guau"
				}
			}
			class Entrenador {
				def hacerLadrar(perro : Perro) : Unit = {
					perro.ladrar
				}
			}
		'''	.parseExpectingNoErrors
	}
	
	@Test
	def void testMethodCallWithOneArgumentIntTypeWithLiteral() {
		'''
			class Programa {
				def iniciar(hora : Int) : Unit = {
					//
				}
			}
			
			class Emisora {
				def transmitir(programa : Programa) : Unit = {
					programa.iniciar(23)
				}
			}
		'''	.parseExpectingNoErrors
	}
	
	@Test
	def void testMethodCallWithOneArgumentIntTypeAndIncompatibleArgumentType() {
		'''
			class Programa {
				def iniciar(hora : Int) : Unit = {
					//
				}
			}
			
			class Emisora {
				def transmitir(programa : Programa) : Unit = {
					programa.iniciar("A String!")
				}
			}
		'''	.parse
			.assertErrorsFound(1)
	}
	
	// migrados de BaseTest
	
		@Test
	def void testSimpleMethodCallOnThisWithoutParameters() {
		'''
		class Example {
			def simpleMethod : Unit = {
				//.. algo
			}
			def caller : Unit = {
				this.simpleMethod
			}
		}
		'''	.parseExpectingNoErrors
	}
	
	@Test
	def void testSimpleMethodCallOnParameterWithoutParameters() {
		'''
		class Example {
			def simpleMethod : Unit = {
			}
			
			def sendMessageToP(p : Example) : Unit = {
				p.simpleMethod
			}
		}
		'''	.parseExpectingNoErrors
	}
	
	@Test
	def void testMethodCallOnThisWithSingleParameterAndExactlySameConcreteClass() {
		'''
		class Persona
		
		class Patova {
			def cacheaA(p : Persona) : Unit = {
				// algo
			}
			def hacer : Unit = {
				this.cacheaA(new Persona)
			}
		}
		'''	.parseExpectingNoErrors
	}
	
	@Test
	def void testMethodCallOnThisWithSingleParameterAndSubtypeArgument() {
		'''
		class Persona
		class VIP extends Persona
		
		class Patova {
			def cacheaA(p : Persona) : Unit = {
				// algo
			}
			def hacer : Unit = {
				this.cacheaA(new VIP)
			}
		}
		'''	.parseExpectingNoErrors
	}
	
}