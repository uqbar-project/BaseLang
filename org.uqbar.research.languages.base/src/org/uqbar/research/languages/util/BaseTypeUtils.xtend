package org.uqbar.research.languages.util

import org.eclipse.xtext.EcoreUtil2
import org.uqbar.research.languages.base.BaseFactory
import org.uqbar.research.languages.base.Class
import org.uqbar.research.languages.base.Expression
import org.uqbar.research.languages.base.Method
import org.eclipse.emf.ecore.EObject

class BaseTypeUtils {

	static def asRef(Class cl) {
		var type = BaseFactory.eINSTANCE.createClassRef()
		type.ref = cl
		type
	}

	static def getContainingClass(EObject expression) {
		EcoreUtil2.getContainerOfType(expression, Class)
	}
	
	static def <T extends EObject> container(EObject expression, java.lang.Class<T> containerType) {
		EcoreUtil2.getContainerOfType(expression, containerType) as T 
	}

	static def getContainingMethod(Expression expression) {
		EcoreUtil2.getContainerOfType(expression, Method)
	}
	
	static def <T> Integer count(Iterable<T> iterable, (T) => boolean predicate) {
		iterable.filter(predicate).size
	}
	
}
