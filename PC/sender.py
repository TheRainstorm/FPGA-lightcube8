import serial
import time

def parse_frames(file_name):
    frame_list = []
    with open(file_name, encoding='utf-8') as f:
        frames = f.readlines()
        for i, line in enumerate(frames):
            if i%9 ==0:
                # print('第 {} 帧'.format(i//9))
                frame = []
            else:
                line_split = line.split(',')[0:7]
                int_list = [int(e, 16) for e in line_split]
                frame.append(bytes(int_list))
                if i%9 == 8:
                    frame_list.append(frame)
    return frame_list

FPS = 30
file_name = 'frames.txt'

with serial.Serial(port='COM1', baudrate=115200, timeout=None) as ser:

    frame_list = parse_frames(file_name)
    print('共{}帧, FPS={}, 时间={}s'.format(len(frame_list), FPS, len(frame_list)/FPS))

    for frame in frame_list:
        for line in frame:
            ser.write(line)
        time.sleep(0.9/FPS)     #0.9用于修正