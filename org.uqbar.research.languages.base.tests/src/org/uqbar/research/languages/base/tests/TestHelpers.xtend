package org.uqbar.research.languages.base.tests

import com.google.inject.Inject
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.validation.Issue
import org.uqbar.research.languages.base.Program
import static org.junit.Assert.*

class TestHelpers {
	@Inject extension ParseHelper<Program> parser
	@Inject extension ValidationTestHelper
	
	// *****************************
	// ** Helpers
	// *****************************
	
	def Program parseExpectingNoErrors(CharSequence text) throws Exception {
		val m = text.parse
		m.assertNoErrors
		return m
	}
	
	def void assertErrorsFound(EObject model, int numberOfErrors) {
		val issues = model.validate
		val errors = issues.filter[i| Severity::ERROR == i.severity]
		if (errors.size != numberOfErrors)
			fail(
			'''Expecting «numberOfErrors» errors, but got «errors.size»: «issues.asString(model)»''');
	}
	
	def String asString(List<Issue> issues, EObject model) {
		issues.fold(new StringBuilder)[s,i|
			val obj = model.eResource.resourceSet.getEObject(i.uriToProblem, true)
			s.append('''«i.severity» («i.code»)'«i.message»' on  «obj.eClass.name»
			''')
		].toString
	}
	
}