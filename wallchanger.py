#!/usr/bin/python3
import os
path = "/home/julius/wallpaper"
import time
time_switch = False

def main_loop(wallpaper):
    while True:
        choice = input()
        if(choice == "r"):
            wallpaper = get_wallpaper()
        
        elif(choice == "q"):
            break
        elif (choice == "t"):
            for elements in wallpaper:
                os.system(f"wallust run {path}/{elements}")
        else:
            open("/home/julius/.config/hypr/hyprpaper.conf", "w").write(f"""
preload = {path}/{wallpaper[int(choice)]}
wallpaper = , {path}/{wallpaper[int(choice)]}""")
            
            os.system(f"wallust run {path}/{wallpaper[int(choice)]} > /dev/null 2>&1")
            os.system(f"hyprctl hyprpaper reload , {path}/{wallpaper[int(choice)]}")
            os.system("kitten themes --reload-in=all Kittycolors")
            os.system("pkill waybar && hyprctl dispatch exec waybar")
            os.system("spicetify apply > /dev/null 2>&1")


def get_wallpaper():
    wallpaper =[]
    for i, elements in enumerate(os.listdir(path)):
        if elements == "switch.py":
            pass
        else:
            print(f"[{i}] " + elements)
            os.system(f"kitten icat --use-window-size 100,100,600,500 {path}/{elements}")

            wallpaper.append(elements)
    print("\n press r to reload \n press q to quit \n press t to generate templates")
    return wallpaper

if(time_switch == False):
    main_loop(get_wallpaper())
else:
    wallpaper = get_wallpaper()
    while True:
        for i,elements in enumerate(wallpaper):
            print(elements)
            time.sleep(8)
            os.system(f"hyprctl hyprpaper reload , {path}/{wallpaper[int(i)]}")



