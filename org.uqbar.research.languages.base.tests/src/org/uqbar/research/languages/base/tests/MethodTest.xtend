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
	
}