##### daletAPI
[AccessRightsService, AssetService, CategoryService, ConfigurationService, GlossaryService, JobService, LocatorService, LockingService, MediaService, MetadataService, PlanningService, RecordingJobService, RundownService, StoryContentService, TrackStackService, TxVersionContentService, UserService, WireService, equals, getClass, hashCode, init, list, notify, notifyAll, toString, wait]

##### daletAPI.ConfigurationService().metaClass.methods*.name.sort().unique()
[convertLocatorTypesToServiceTuples, convertServicesToServiceTuples, convertStudiosToServiceTuples, equals, getAllCGAssetTypes, getAllDataFieldTypes, getAllDataFields, getAllDeployedSolrIndexes, getAllExtendedAssetTypes, getAllLanguages, getAllLocatorFamilies, getAllLocatorsTypes, getAllStations, getAllStatuses, getAllStoryTemplates, getAllStudios, getAllSubtitlesAssetTypes, getAllTrackStackTemplates, getClass, getMediaFormatDescription, getMediaFormatInfos, getMediaMigrationPolicyInfos, getStorageUnits, getUserMediaFormatInfos, hashCode, notify, notifyAll, toString, wait]

##### MetadataService 
daletAPI.MetadataService().metaClass.methods*.name.sort().unique()
addMetadataToObject, addMetadataToObjects, addRow, appendValueToObjects, equals, getClass, getObjectMetadata, getObjectMetadataByFields, getObjectsMetadataByFields, getObjectsMetadataByFieldsOrderedBy, getTableOfType, getTableTypes, hashCode, notify, notifyAll, removeMetadataFromObject, removeRow, removeValueFromObject, toString, updateRow, wait]

##### ConfigurationService
daletAPI.ConfigurationService().getAllDataFields().metaClass.methods*.name.sort().unique()
[add, addAll, clear, clone, contains, containsAll, ensureCapacity, equals, forEach, get, getClass, hashCode, indexOf, isEmpty, iterator, lastIndexOf, listIterator, notify, notifyAll, remove, removeAll, removeIf, replaceAll, retainAll, set, size, sort, spliterator, subList, toArray, toString, trimToSize, wait]

### Get all fields
def object_meta1 = daletAPI.ConfigurationService().getAllDataFields()
object_meta1.each {  output += "   " + it.name }



##### getAsset
daletAPI.AssetService().getAsset(titleid).metaClass.methods*.name.sort().unique()
 [addCategoryId, equals, getAuthor, getCategoryIds, getClass, getDuration, getId, getItemCode, getLastModifiedTime, getName, getPrimaryCategoryId, getStatusId, hashCode, notify, notifyAll, setAuthor, setCategoryIds, setDuration, setId, setItemCode, setLastModifiedTime, setName, setPrimaryCategoryId, setStatusId, toString, wait]
 
##### getObjectMetadataByFields 
daletAPI.MetadataService().getObjectMetadataByFields.metaClass.methods*.name.sort().unique()
[add, addAll, addFirst, addLast, clear, clone, contains, containsAll, descendingIterator, element, equals, get, getClass, getFirst, getLast, hashCode, indexOf, isEmpty, iterator, lastIndexOf, listIterator, notify, notifyAll, offer, offerFirst, offerLast, peek, peekFirst, peekLast, poll, pollFirst, pollLast, pop, push, remove, removeAll, removeFirst, removeFirstOccurrence, removeLast, removeLastOccurrence, retainAll, set, size, spliterator, subList, toArray, toString, wait] 
 
 
##### EXECUTION
output = (execution.metaClass.methods*.name.sort().unique() ).toString()
[addEventSubscription, addIdentityLink, addJob, addTask, createExecution, createSubProcessInstance, createVariableLocal, createVariablesLocal, deleteCascade, deleteIdentityLink, deleteVariablesInstanceForLeavingScope, destroy, destroyScope, disposeStartingExecution, end, equals, executeActivity, findActiveActivityIds, findExecution, findInactiveConcurrentExecutions, forceUpdate, getActivity, getActivityId, getBusinessKey, getCachedElContext, getCachedEntityState, getClass, getCompensateEventSubscriptions, getCurrentActivityId, getCurrentActivityName, getDeleteReason, getDeploymentId, getDescription, getEngineServices, getEventName, getEventSource, getEventSubscriptions, getEventSubscriptionsInternal, getExecutionListenerIndex, getExecutions, getId, getIdentityLinks, getJobs, getLocalizedDescription, getLocalizedName, getLockTime, getName, getParent, getParentId, getPersistentState, getProcessBusinessKey, getProcessDefinition, getProcessDefinitionId, getProcessDefinitionKey, getProcessDefinitionName, getProcessDefinitionVersion, getProcessInstance, getProcessInstanceId, getProcessVariables, getQueryVariables, getReplacedBy, getRevision, getRevisionNext, getStartingExecution, getSubProcessInstance, getSuperExecution, getSuperExecutionId, getSuspensionState, getTasks, getTenantId, getTransition, getTransitionBeingTaken, getUsedVariablesCache, getVariable, getVariableInstance, getVariableInstanceEntities, getVariableInstanceLocal, getVariableInstances, getVariableInstancesLocal, getVariableLocal, getVariableNames, getVariableNamesLocal, getVariableValues, getVariables, getVariablesLocal, hasVariable, hasVariableLocal, hasVariables, hasVariablesLocal, hashCode, inactivate, initialize, insert, involveUser, isActive, isConcurrent, isDeleteRoot, isEnded, isEventScope, isProcessInstanceType, isScope, isSuspended, notify, notifyAll, performOperation, remove, removeEventSubscription, removeIdentityLinks, removeJob, removeTask, removeVariable, removeVariableLocal, removeVariables, removeVariablesLocal, setActive, setActivity, setBusinessKey, setCachedElContext, setCachedEntityState, setConcurrent, setDeleteReason, setDeleteRoot, setDeploymentId, setDescription, setEnded, setEventName, setEventScope, setEventSource, setExecutionListenerIndex, setExecutions, setId, setLocalizedDescription, setLocalizedName, setLockTime, setName, setParent, setParentId, setProcessDefinition, setProcessDefinitionId, setProcessDefinitionKey, setProcessDefinitionName, setProcessDefinitionVersion, setProcessInstance, setQueryVariables, setReplacedBy, setRevision, setScope, setSubProcessInstance, setSuperExecution, setSuspensionState, setTenantId, setTransition, setTransitionBeingTaken, setVariable, setVariableLocal, setVariables, setVariablesLocal, signal, start, take, takeAll, toString, updateProcessBusinessKey, wait]


getCurrentActivityName
getEventName
getName
getProcessDefinitionName
getVariableNames

setProcessDefinitionName
setName
setEventName


 daletAPI.MetadataService().getObjectMetadataByFields(obj_asset.id, obj_enum, [field_id]).values
 
output = this.getClass().getCanonicalName()
output = this.getClass().getDeclaredFields()
output = this.getClass().getProperties()
output = this.metaClass.methods*.name.sort().unique()  

com.dalet.broker.BrokerClient.metaClass.methods*.name.sort().unique() 
[addBrokerChangedEventListener, equals, getBrokerDomain, getClass, getClientConfiguration, getJobParams, getJobs, getJobsWithBoundedHistorySize, getJobsWithBoundedHistorySizeFromDb, hashCode, isMasterBrokerAvailable, notify, notifyAll, removeBrokerChangedEventListener, removeJob, setClientConfiguration, setClientData, setJobDueDate, setJobsPriority, submitJob, subscribe, toString, unsubscribe, unsubscribeAll, wait]


execution.metaClass.methods*.name.sort().unique()
[addEventSubscription, addIdentityLink, addJob, addTask, createExecution, createSubProcessInstance, createVariableLocal, createVariablesLocal, deleteCascade, deleteIdentityLink, deleteVariablesInstanceForLeavingScope, destroy, destroyScope, disposeStartingExecution, end, equals, executeActivity, findActiveActivityIds, findExecution, findInactiveConcurrentExecutions, forceUpdate, getActivity, getActivityId, getBusinessKey, getCachedElContext, getCachedEntityState, getClass, getCompensateEventSubscriptions, getCurrentActivityId, getCurrentActivityName, getDeleteReason, getDeploymentId, getDescription, getEngineServices, getEventName, getEventSource, getEventSubscriptions, getEventSubscriptionsInternal, getExecutionListenerIndex, getExecutions, getId, getIdentityLinks, getJobs, getLocalizedDescription, getLocalizedName, getLockTime, getName, getParent, getParentId, getPersistentState, getProcessBusinessKey, getProcessDefinition, getProcessDefinitionId, getProcessDefinitionKey, getProcessDefinitionName, getProcessDefinitionVersion, getProcessInstance, getProcessInstanceId, getProcessVariables, getQueryVariables, getReplacedBy, getRevision, getRevisionNext, getStartingExecution, getSubProcessInstance, getSuperExecution, getSuperExecutionId, getSuspensionState, getTasks, getTenantId, getTransition, getTransitionBeingTaken, getUsedVariablesCache, getVariable, getVariableInstance, getVariableInstanceEntities, getVariableInstanceLocal, getVariableInstances, getVariableInstancesLocal, getVariableLocal, getVariableNames, getVariableNamesLocal, getVariableValues, getVariables, getVariablesLocal, hasVariable, hasVariableLocal, hasVariables, hasVariablesLocal, hashCode, inactivate, initialize, insert, involveUser, isActive, isConcurrent, isDeleteRoot, isEnded, isEventScope, isProcessInstanceType, isScope, isSuspended, notify, notifyAll, performOperation, remove, removeEventSubscription, removeIdentityLinks, removeJob, removeTask, removeVariable, removeVariableLocal, removeVariables, removeVariablesLocal, setActive, setActivity, setBusinessKey, setCachedElContext, setCachedEntityState, setConcurrent, setDeleteReason, setDeleteRoot, setDeploymentId, setDescription, setEnded, setEventName, setEventScope, setEventSource, setExecutionListenerIndex, setExecutions, setId, setLocalizedDescription, setLocalizedName, setLockTime, setName, setParent, setParentId, setProcessDefinition, setProcessDefinitionId, setProcessDefinitionKey, setProcessDefinitionName, setProcessDefinitionVersion, setProcessInstance, setQueryVariables, setReplacedBy, setRevision, setScope, setSubProcessInstance, setSuperExecution, setSuspensionState, setTenantId, setTransition, setTransitionBeingTaken, setVariable, setVariableLocal, setVariables, setVariablesLocal, signal, start, take, takeAll, toString, updateProcessBusinessKey, wait]

javax.script.ScriptException: groovy.lang.GroovyRuntimeException: 
Could not find matching constructor for: org.activiti.engine.delegate.BpmnError(java.lang.Integer, java.lang.Str




org.activiti.engine.metaClass.methods*.name.sort().unique() 
com.dalet.bpm.engine.plugins.behavior.ScriptTaskBehavior
org.activiti.engine.impl.scripting.ScriptingEngines

//// Translate frames to String TimeCode, third value is offset in seconds
def frames2tc(varFrames, varRate, offset = 10800) {    
    def frames, seconds, framesout
    frames = varFrames % varRate
    seconds = (varFrames - frames ) / varRate
    def duration = new Date((seconds.toInteger() - offset) * 1000)
    if (frames == 0){ framesout = "00" } else if (frames <= 9) { framesout = "0" + frames } else { framesout = frames }
    return duration.format("HH:mm:ss") + ":" + framesout
}
//// Translate Peroiod to String TimeCode, default rate is 40ms by frame
​def period2tc(varPeriod, varRateMil = 40) {        
    def frames, framesmil, seconds, framesout
    framesmil = varPeriod % 1000
    seconds = varPeriod - framesmil  
    frames = framesmil / varRateMil
    def duration = new Date(seconds.toInteger())
    if (frames == 0){ framesout = "00" } else if (frames <= 9) { framesout = "0" + frames } else { framesout = frames }
    return duration.format("HH:mm:ss") + ":" + framesout
}