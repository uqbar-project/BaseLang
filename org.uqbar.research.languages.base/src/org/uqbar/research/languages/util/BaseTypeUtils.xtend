package org.uqbar.research.languages.util

import org.eclipse.xtext.EcoreUtil2
import org.uqbar.research.languages.base.BaseFactory
import org.uqbar.research.languages.base.Class
import org.uqbar.research.languages.base.Expression
import org.uqbar.research.languages.base.Method

class BaseTypeUtils {

	static def asRef(Class cl) {
		var type = BaseFactory.eINSTANCE.createClassRef()
		type.ref = cl
		type
	}

	static def getContainingClass(Expression expression) {
		EcoreUtil2.getContainerOfType(expression, Class)
	}

	static def getContainingMethod(Expression expression) {
		EcoreUtil2.getContainerOfType(expression, Method)
	}
}
