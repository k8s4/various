/**
 * Script that searches for subtitles of the video asset and returns list of subtitles IDs.
 * - 'Video Title Id' is mandatory parameter.
 * - 'Channel name' is optional parameter.
 *      If 'Channel name' is defined than subtitles with studioChannelName equals to 'Channel name' will be returned.
 *      If 'Channel name' is wrong than empty list will be returned.
 *      If "Channel name' is empty than all subtitles related to video asset will be returned.
 *
 * 
 *
 */

import com.dalet.webservice.services.errors.ResourceDoesNotExist
import com.dalet.webservice.services.errors.ResourcePreconditionViolation
import org.activiti.engine.delegate.BpmnError
import org.apache.log4j.BasicConfigurator
import org.slf4j.LoggerFactory

// For tests only.
BasicConfigurator.configure()

def log = LoggerFactory.getLogger('GetSubtitleIdsScript')
def titleId
def channelName
def output

try {
    titleId = Long.parseLong(context.getVariable(execution, "VideoTitleId"))
    log.debug("Title id is ${titleId}")
} catch (RuntimeException e) {
    log.error("Title ID variable is not defined.")
    throw new BpmnError("Title ID variable is not defined.")
}

try {
    channelName = context.getVariable(execution, "ChannelName")
    log.debug("Channel name is ${channelName}.")
} catch (RuntimeException e) {
    channelName = 'None'
    log.debug("Channel name is not defined.")
}

try {
    def subtitles = daletAPI.AssetService().getSubtitlesToVideoAssociationByMediaAsset(titleId)
    if (subtitles == null) {
        subtitles = [];
    }
    log.debug("${subtitles.size} subtitles fetched for the video title ${titleId}.")
    subtitles.each { log.debug("Subtitle id is ${it.subtitlesAssetId}") }
    if (channelName != 'None' && channelName != '') {
        output = subtitles.findAll { it.studioChannelName.equals channelName }.collect { it.subtitlesAssetId }
        context.setVariable(execution, 'output', output)
    } else {
        output = subtitles.collect { it.subtitlesAssetId }
        context.setVariable(execution, 'output', output)
    }
    if (output.size > 0) {
        log.debug("Subtitles for titleId ${titleId}:")
        output.each { log.debug("${it}") }
    }
} catch (ResourcePreconditionViolation e1) {
    log.error("Error during API invocation.")
    throw new BpmnError("Error during API invocation.")
} catch (ResourceDoesNotExist e2) {
    log.error("Title with id ${titleId} not fountd.")
    throw new BpmnError("Title with id ${titleId} not fountd.")
}
