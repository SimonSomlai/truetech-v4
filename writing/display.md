How to Make an E-paper Quote Display

<img src="./header.jpeg">

’Tis the holiday season. 

Oh boy oh boy.

Time to get together with family, enjoy some nice meals and exchange some gifts. 

Happy times!

If you're still looking for a cool gift for your (nerdy) friend, I just might have the solution for you!

A fancy <b>e-paper quote display</b> to display all the random stuff you can think of! 

Quotes? - check!

Jokes? - double-check! 

That picture of your grandma you love so much? - triple-check!

Let's dive in 🤿.

# What you’ll need

- 7.5 inch/19cm e-paper display. ([I got this one](https://www.waveshare.com/7.5inch-e-paper-hat.htm)). There are also bigger, higher resolution and multi-colored displays but those tend to get really 💰💰💰, fast.
- Raspberry pi zero 2 W ([I got this one](https://www.raspberrypi.com/products/raspberry-pi-zero-2-w/)). You can also get the one with pre-soldered headers if you don't feel like doing it yourself.
- Picture frame ([I got this one](https://www.action.com/nl-be/p/fotolijst38/)). The screen will be 17X11cm, so you'll just have to find something slightly larger.
- Micro SD card (8GB+ is ideal)
- Micro usb charging cable
- 2X20 Pin header + Soldering station/skills (unless you got the pi with pre-soldered headers)

<b>Total project cost: +-80€</b> or about 0,016 camels 🐫.

# And we’re off..

Sooo...

The first thing you’ll need to do is <b>setting up your raspberry pi hardware</b>. You do this by soldering the headers onto your raspberry pi. After that you can just plugin the e-Paper Driver HAT on top of it and you should be good to go.

The final result should look something like this;

<video width="320" height="240" controls>
 <source src="./setup.mp4">
</video>


After that’s done you can follow this really handy youtube tutorial to help you setup the software;

<img src="http://i3.ytimg.com/vi/GkBskiRatwM/hqdefault.jpg"/>
<video width="320" height="240" controls>
 <source src="https://www.youtube.com/watch?v=GkBskiRatwM">
</video>

## Some additions

- You can also add multiple wifi configs to the wpa_supplicant.conf file. This way you can move your pi around between the home/main office and it’ll automatically work there as well.

```sh
country=BE
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
  scan_ssid=1
  ssid="SSID1"
  psk="PW1"
}

update_config=1
network={
  scan_ssid=1
  ssid="SSID2"
  psk="PW2"
}
```

- I also wouldn't do the static ip part if you plan on moving the raspberry pi between locations. You can find the ip address of you pi by;

```sh
sudo nmap -sn 192.168.1.0/24
```

# Making it come alive 🧟‍♂️

Once that’s done you can start importing several python example scripts to test the display. The most basic one that you can try out is [this repo](https://github.com/waveshare/e-Paper) provided by waveshare electronics themselves. So you can clone the repo;

```sh
git clone https://github.com/waveshare/e-Paper
cd e-Paper/RaspberryPi_JetsonNano/python
```

And then some basic install commands for the libraries you'll need;

```sh
sudo apt-get update
sudo apt-get install python3-pip
sudo apt-get install python3-pil
sudo apt-get install python3-numpy
sudo pip3 install Jetson.GPIO
```

After this you’ll be able to run some basic example in the  the examples  directory

```bash
python examples/epd_7in5_V2_test.py
```

And if all went well you should see the standard waveshare demo springing to life on your screen. This looks something like this;

https://youtu.be/QU4LxcYIbuE?t=139

Congratulations! 🥳

Now you can start making changes to whatever you want to have displayed on the screen. I decided I wanted to have some jokes displayed from [JokeApi](https://sv443.net/jokeapi/v2/). I basically copied the example script and started from there.  

I used the [FTP simple VS Code extension](https://marketplace.visualstudio.com/items?itemName=humy2833.ftp-simple) to easily change the files on my pi. Here's the full code;

```py
#!/usr/bin/python
# -*- coding:utf-8 -*-
import sys
import os
picdir = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), 'pic')
mediadir = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), 'media')
libdir = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), 'lib')
if os.path.exists(libdir):
    sys.path.append(libdir)

import logging
from waveshare_epd import epd7in5_V2 as epd_driver
import time
from PIL import Image,ImageDraw,ImageFont
import traceback
import textwrap
import pdb
import requests
import random
from functools import reduce
import re
import datetime

# Log to output file to see what's going on
logging.basicConfig(level=logging.INFO, filename='/home/pi/e-Paper/src/examples/quotes.log')

# Splits a long text to smaller lines which can fit in a line with max_width.
# Uses a Font object for more accurate calculations
def text_wrap(text, font = None, max_width = None):
  lines = []
  if font.getsize(text)[0] < max_width:
    lines.append(text)
  else:
    words = text.split(' ')
    i = 0
    while i < len(words):
      line = ''
      while i < len(words) and font.getsize(line + words[i])[0] <= max_width:
        line = line + words[i] + " "
        i += 1
      if not line:
        line = words[i]
        i += 1
      lines.append(line)
  return lines

def slice_index(x):
    i = 0
    for c in x:
        if c.isalpha():
            i = i + 1
            return i
        i = i + 1

def upperfirst(x):
    i = slice_index(x)
    return x[:i].upper() + x[i:]

# Calculates font-size, line-wrapping, vertical centering, # of lines, strips not-needed parts
def make_it_pretty(quotes, spacing, screen_height, screen_width, padding):
  logging.info("Formatting...")
  font_sizes = [64,56,48,40,32,24]
  attempt = 0
  while True:
    attempt += 1
    text = random.choice(quotes)
    logging.info(f"Quote try {attempt}")
    for size in font_sizes:
      font = ImageFont.truetype(os.path.join(mediadir, 'vollkorn.ttf'), size)
      line_height = font.getsize('hg')[1] + spacing
      max_lines = (screen_height // line_height)
      splitted_quote = text.split("\n")
      result = [text_wrap(part, font = font, max_width = screen_width - (padding * 2)) for part in splitted_quote]
      blocks = reduce(lambda x, y: x+y, result)
      trimmed_blocks = [x.strip() for x in blocks]
      r = re.compile("[\w\"]+")
      filtered_list = list(filter(r.match, trimmed_blocks))
      line_length = len(filtered_list)
      quote_height = line_height * line_length
      offset_y = (screen_height / 2) - (quote_height / 2) 
      if (line_length <= max_lines) and (quote_height + offset_y < screen_height):
        quote = upperfirst("\n".join(filtered_list))
        logging.info(f"{quote},\n Font size: {size}, Line count: {line_length}, Quote height: {quote_height}, Offset: {offset_y}, Screen height: {screen_height}")
        return {
          "quote": quote,
          "offset": offset_y,
          "font": font
        }

# Resize PIL image keeping ratio and using white background.
def resize(image, width, height):
    ratio_w = width / image.width
    ratio_h = height / image.height
    if ratio_w < ratio_h:
        # It must be fixed by width
        resize_width = width
        resize_height = round(ratio_w * image.height)
    else:
        # Fixed by height
        resize_width = round(ratio_h * image.width)
        resize_height = height
    image_resize = image.resize((resize_width, resize_height), Image.ANTIALIAS)
    background = Image.new('RGBA', (width, height), (255, 255, 255, 255))
    offset = (round((width - resize_width) / 2), round((height - resize_height) / 2))
    background.paste(image_resize, offset)
    return background.convert('RGB')

def get_jokes():
 logging.info("Fetching joke..")
 url = "https://v2.jokeapi.dev/joke/Miscellaneous,Dark"
 json = requests.get(url).json()
 return ["\n".join([json["setup"],json["delivery"]])] if json["type"] == "twopart" else [json["joke"]] 

try:
    now = datetime.datetime.now()
    logging.info(f"\n{now.strftime('%Y-%m-%d %H:%M:%S')}")
    logging.info(f"Waking up...")
    epd = epd_driver.EPD()
    epd.init()

    result = get_jokes()
    
    screen_width = epd.width
    screen_height = epd.height
    line_spacing = 1
    padding = 30
    
    view = Image.new('1', (epd.width, epd.height), 255)  # 255: clear the frame
    draw = ImageDraw.Draw(view)
    formatted_result = make_it_pretty(result, line_spacing, screen_height, screen_width, padding)
    
    quote = formatted_result["quote"]
    offset_y = formatted_result["offset"]
    font = formatted_result["font"]
    
    logging.info("Updating...")
    draw.text((padding, offset_y), quote, fill = 0, align = "left", spacing = line_spacing, font = font)
    epd.display(epd.getbuffer(view))

    logging.info("Standby...")
    epd.sleep()
    
except IOError as e:
    logging.info(e)
    time.sleep(5)
    
    
except KeyboardInterrupt:    
    logging.info("ctrl + c:")
    epd.epdconfig.module_exit()
    exit()

````

Now to finish it up, You can schedule it with a cronjob to update at whatever interval you want. This will update the screen once every hour.

```sh
0 * * * * /bin/bash -l -c 'python /home/pi/e-Paper/src/examples/quotes.py'
```

Now all that's left is to put it int a nice picture frame and hot-glue your raspberry pi to the back. Aand..

Tadaaa! 🧙🐰🎩 You're done!!

<img src="./joke.jpg">

# Conclusion

This makes for some really nice decoration for your desk and will significantly increase the # of laughs you'll have per day, so it's definitely a worthwhile investment. Also makes for a fun gift (I think :p)

Off-course it can be extended to display whatever you want;

- Movies 
- Jokes
- Quotes
- Images
- Cartoons
<img src="./jeroom.jpeg">

If you’ve made one as well, let me know in the comments below!

## Resources
- [https://github.com/TomWhitwell/SlowMovie](https://github.com/TomWhitwell/SlowMovie)
- [https://github.com/waveshare/e-Paper](https://github.com/waveshare/e-Paper)
- [https://github.com/aceisace/Inkycal](https://github.com/aceisace/Inkycal)
  - [https://github.com/aceisace/Inkycal/blob/main/inkycal/modules/inkycal_jokes.py](https://github.com/aceisace/Inkycal/blob/main/inkycal/modules/inkycal_jokes.py)
  - [https://github.com/veebch/edify/blob/main/edify.py](https://github.com/veebch/edify/blob/main/edify.py)
- [https://medium.com/swlh/create-an-e-paper-display-for-your-raspberry-pi-with-python-2b0de7c8820c](https://medium.com/swlh/create-an-e-paper-display-for-your-raspberry-pi-with-python-2b0de7c8820c)
