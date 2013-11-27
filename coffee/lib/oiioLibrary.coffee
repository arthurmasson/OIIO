lib = """
oiios:

    Osc:              # the user can add OSC addresses to listen: thanks to oscOutList, manually type addresses
        extendable_outputs:
            - { name: drum1, type: oscOut, default: drum/1/i }
            - { name: drum2, type: oscOut, default: drum/2/i }
            - { name: drum3, type: oscOut, default: drum/3/i }

    Drums:            # the user can not add OSC addresses to listen: those are set by default
        outputs:
            - { name: drum1, type: oscOut, default: drum/1/i }
            - { name: drum2, type: oscOut, default: drum/2/i }
            - { name: drum3, type: oscOut, default: drum/3/i }
            - { name: drum4, type: oscOut, default: drum/4/i }

    Keyboard:           # the user can add keys: keyList
        extendable_outputs:
            - { name: y, type: key }
            - { name: ctrl, type: key }
            - { name: space, type: key }

    KeyboardExample:    # the user can not add keys: static
        outputs:
            - { name: a, type: key }
            - { name: z, type: key }
            - { name: e, type: key }
            - { name: r, type: key }
            - { name: t, type: key }
            - { name: y, type: key }
            - { name: ctrl, type: key }
            - { name: space, type: key }
            - { name: click-right, type: mouse }
            - { name: arrow-up, type: key }
            - { name: arrow-down, type: key }

    VideoPlayer:        # the user can add video path: enter video path with dialog window
        extendable_inputs:
            - { name: video1, type: path, default: /home/user/video1.avi }
            - { name: video2, type: path, default: /home/user/video2.avi }
            - { name: video3, type: path, default: /home/user/video3.avi }

    VideoPlayerExample:     # the user can not add video path: those are set by default
        inputs:
            - { name: video1, type: path, default: /home/user/video1.avi }
            - { name: video2, type: path, default: /home/user/video2.avi }
            - { name: video3, type: path, default: /home/user/video3.avi }
            - { name: video4, type: path, default: /home/user/video4.avi }
        outputs:
            - { name: video, type: video }
"""