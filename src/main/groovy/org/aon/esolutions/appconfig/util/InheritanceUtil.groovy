package org.aon.esolutions.appconfig.util

import org.aon.esolutions.appconfig.model.Environment
import org.aon.esolutions.appconfig.model.Variable
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.neo4j.support.Neo4jTemplate
import org.springframework.stereotype.Service

@Service
class InheritanceUtil {
	
	@Autowired
	private Neo4jTemplate template;
	
	public Collection<Variable> getVariablesForEnvironment(Environment env) {
		Map<String, Variable> answer = [:];
		
		Environment currentEnv = env;
		while (currentEnv != null) {
			currentEnv.getVariableEntries().each {
				if (answer.containsKey(it.key) == false) {
					def inheritedFrom = env == currentEnv ? null : currentEnv;
					answer.put(it.key, new Variable([key: it.key, value: it.value, inheritedFrom: inheritedFrom]))
					
					if (currentEnv?.getEncryptedVariables()?.contains(it.key))
						answer.get(it.key).setEncrypted(Boolean.TRUE);
				} else {
					answer.get(it.key).overrides = currentEnv
					answer.get(it.key).overrideValue = it.value
					
					if (currentEnv?.getEncryptedVariables()?.contains(it.key))
						answer.get(it.key).setOverrideEncrypted(Boolean.TRUE);
				}
			}
			
			currentEnv = currentEnv.getParent();
			fetchPersistable(currentEnv);
		}
		
		answer.values().sort { a, b ->
			a.key <=> b.key
		}
	}
	
	protected void fetchPersistable(def persistable) {
		template.fetch(persistable);
	}
}
