def output, name
import org.activiti.engine.delegate.BpmnError
import org.apache.log4j.BasicConfigurator
import org.slf4j.LoggerFactory

def log = LoggerFactory.getLogger(this.getClass().getCanonicalName().toString())
name = this.getClass().getCanonicalName()

log.info("Debug log, name is ${output}!")

//	throw new BpmnError("Throw test error! Name is ${output}!")

context.setVariable(execution, 'output', output.toString())
