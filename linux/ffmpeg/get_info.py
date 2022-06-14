#!/usr/bin/python
# Copied from https://youtu.be/Gle9gtIWUJ8
import sys, subprocess, json
 
def safe_print(dict, key, name):
    if key in dict:
        print (name + ': {}').format(dict[key])
 
def main(argv):
    if len(argv) == 0:
        print 'Usage: ffprobe.py file'
        sys.exit(2)
 
    output = subprocess.check_output([
        "ffprobe",
        "-v", "error",
        "-print_format", "json",
        "-show_format",
        "-show_streams",
        argv[0]
    ])
    data = json.loads(output)
    format, streams = [data[k] for k in ('format','streams')]
 
    for s in streams:
        print 'Stream #{} {}'.format(s['index'], s['codec_type'])
        print 'Codec: {}'.format(s['codec_name'])
        if s['codec_type'] == 'video':
            print 'Resolution: {}x{}'.format(
                s.get('width', '?'), s.get('height', '?'))
        elif s['codec_type'] == 'audio':
            print 'Sample Rate: {}'.format(s.get('sample_rate', '?'))
        print ''
 
    safe_print(format, 'duration', 'Duration')
 
if __name__ == "__main__":
    main(sys.argv[1:])