There is template for monitoring (QuickSync)integrated video in Intel processors:
You can monitor theese parameters:
Multi-Format Codec Engine (also known as “MFX” or “VDBOX”); Video Encode (PAK) and Decode
2nd instance of the MultiFormat Codec Engine, if available (Examples of supported processor include 5th generation of Intel® Core™ processors with Intel® HD Graphics 6000, Intel® Iris™ Graphics 6100, Intel® Iris™ Pro Graphics 6200, Intel® Iris™ Pro Graphics P6300); Video Encode (PAK) and Decode
Video Quality Engine (also known as “VEBOX” or Video Quality enhancement pipeline) Deinterlace, Denoise
Render Engine (Execution units, media samplers, VME and their caches) Video Encode (ENC), OpenCL, Video Scaling, VPP Composition including frame rate conversion and image stabilization, VPP copy to CPU
GT Frequency

First of all you need prepare utility for get parameters.
You need build metrics_monitor from repo: https://github.com/Intel-Media-SDK/MediaSDK
For it is correct working you may need add run = 0; at the end of while in cttmetrics_sample.cpp 
while(run)
...
        if (true == isFreq)
            printf("\tGT Freq: %4.2f", metric_values[3]);

        printf("\n");
		run = 0
	}

Add rules to sudoers:
Defaults:zabbix !requiretty
zabbix ALL=(ALL) NOPASSWD: /opt/intel/mediasdk/tools/metrics_monitor/_bin/metrics_monitor

And add needed userparameter in zabbix-agent:
UserParameter=gpu.metrics[*],sudo /opt/intel/mediasdk/tools/metrics_monitor/_bin/metrics_monitor "$2" "$3" | sed 's/ usage://g' | sed 's/\t/\n/g' | sed 's/,//g' | sed 's/T F/T_F/g' | grep "$1" | awk '{print $ 2}'