package org.uqbar.research.languages.scoping

import com.google.inject.Inject
import it.xsemantics.runtime.RuleEnvironment
import it.xsemantics.runtime.RuleFailedException
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import org.uqbar.research.languages.base.Assignment
import org.uqbar.research.languages.base.Class
import org.uqbar.research.languages.base.ConstructorCallArg
import org.uqbar.research.languages.base.Expression
import org.uqbar.research.languages.base.Property
import org.uqbar.research.languages.base.Reference
import org.uqbar.research.languages.typing.BaseSemantics

import static extension org.uqbar.research.languages.util.BaseTypeUtils.*
import org.uqbar.research.languages.base.ConstructorCall
import org.uqbar.research.languages.base.MessageSend
import org.uqbar.research.languages.base.Selector
import org.uqbar.research.languages.base.ClassRef

/**
 * This class contains custom scoping description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation.html#scoping
 * on how and when to use it 
 *
 */
class BaseScopeProvider extends AbstractDeclarativeScopeProvider {
	@Inject extension BaseSemantics semantics

	def IScope scope_Referenciable(Reference reference, EReference ref) {
		reference.containingClass.allProperties.asScope + reference.containingMethod.formals.asScope
	}
	
	def IScope scope_Assignable(Assignment assignment, EReference ref) {
		assignment.containingClass.allProperties.asScope
	}
	
	def IScope scope_ConstructorCallArg_property(ConstructorCallArg context, EReference reference) {
		context.container(ConstructorCall).classRef.ref.allProperties.asScope
	}
	
	def IScope scope_Selector_ref(Selector selector, EReference reference) {
		var typeOfReceiver = typeExpression(selector.container(MessageSend).receiver)
		if (typeOfReceiver.failed)
			IScope.NULLSCOPE
		else
			(typeOfReceiver.first as ClassRef).ref.methods.asScope
	}
	
	// *****************************
	// ** Helpers
	// *****************************
	
	def getExpressionType(Expression receiver) {
		semantics.typeExpression(receiver.environment, receiver).value
	}

	def Iterable<Property> getAllProperties(Class cl) {
		safeTypeSystem [ allProperties(cl) ]
	}

	/**
	 * Invokes a rule of the type system and returns an empty list if the rule fails.
	 * 
	 * In an interactive environment, this allows that the editor keeps some level of responsiveness
	 * even while editing a program with type system errors.
	 * 
	 * I am not sure if this is necessary, but is done this way in the XSemantics examples 
	 * (with some refactorings I made)
	 */
	def <T> Iterable<T> safeTypeSystem((BaseSemantics)=>Iterable<T> block) {
		try {
			block.apply(semantics)
		} catch (RuleFailedException e) {
			#[]
		}
	}

	def RuleEnvironment getEnvironment(Expression expression) {
		var containingClass = expression.containingClass
		if (containingClass != null) {
			new RuleEnvironment(semantics.environmentEntry("this", containingClass.asRef))
		} else {
			null
		}
	}
	
	// *****************************************
	// ** extension methods 
	// *****************************************

	def operator_plus(IScope outer, IScope inner) {
		Scopes.scopeFor(inner.allElements.map[e| e.EObjectOrProxy], outer)
	}
	
	def asScope(Iterable<? extends EObject> elements) {
		Scopes.scopeFor(elements)
	}
	
	def asScope(EObject justOne) {
		#[justOne].asScope
	}
}
