import com.dalet.webservice.services.errors.ResourceDoesNotExist
import com.dalet.webservice.services.errors.ResourcePreconditionViolation
import org.apache.log4j.BasicConfigurator
import org.slf4j.LoggerFactory

import org.activiti.engine.delegate.DelegateTask


//varIF = (DelegateTask.getCategory()).toString() + " lll " + (DelegateTask.getName()).toString() 
varIF = (DelegateTask.metaClass.methods*.name.sort().unique()).toString() 
context.setVariable(execution, 'varIF', varIF)

output = (this.metaClass.methods*.name.sort().unique()).toString()
context.setVariable(execution, 'varDebug', output)
