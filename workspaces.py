#!/usr/bin/env python

import sys

import i3ipc

i3 = i3ipc.Connection()

colors = {
    "fg": "#282a36",
    "bg": "#f8f8f2"
}

def render_workspaces(display):
    wsp_items = ''
    for wsp in i3.get_workspaces():
        wsp_name = wsp.name
        wsp_icon = wsp_name.split(":")[-1]
        wsp_action = "%%{A:i3-msg workspace \"%s\":}" % wsp_name
        if wsp.output != display and not wsp.urgent:
            continue
        if wsp.focused:
            # Possibly add dark red tint if urgent
            # wsp_items += ("%%{F%s}%%{B%s}%s %s %%{F-}%%{B-}%%{A}" %
            #               (colors["fg"], colors["bg"], wsp_action, wsp_icon))
            wsp_items += ("%%{F%s}%%{B%s} %s %%{F-}%%{B-}" %
                          (colors["fg"], colors["bg"], wsp_icon))
        elif wsp.urgent:
            # wsp_items += ("%%{F%s}%%{B%s}%s %s %%{F-}%%{B-}%%{A}" %
            #               (colors["bg"], colors["fg"], wsp_action, wsp_icon))
            wsp_items += ("%%{F%s}%%{B%s} %s %%{F-}%%{B-}" %
                          (colors["bg"], colors["fg"], wsp_icon))
        else:
            # wsp_items += ("%%{F%s}%%{B%s}%s %s %%{F-}%%{B-}%%{A}" %
            #               (colors["bg"], colors["fg"], wsp_action, wsp_icon))
            wsp_items += ("%%{F%s}%%{B%s} %s %%{F-}%%{B-}" %
                          (colors["bg"], colors["fg"], wsp_icon))
    return f"{wsp_items}"


# outputs = ["eDP-1-1", "HDMI-0"]

print(render_workspaces(sys.argv[1]))
# for idx,output in enumerate([ out.name for out in i3.get_outputs() if out.active]):
#     print(idx, output)
#     print(render_workspaces(output))
    # out += "%s %s" % (idx, render_workspaces(display=output))

# print(out)
